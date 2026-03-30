import 'dart:async';

import 'package:dreusables/dirconnect_package.dart';
import 'package:dreusables/src/core/data/datasources/places_functions_data_source.dart';
import 'package:dreusables/src/core/utils/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

const List<String> _defaultCountries = ['au'];

const EdgeInsets _suggestionItemPadding =
    EdgeInsets.symmetric(horizontal: 16, vertical: 12);

const double _suggestionIconSize = 20;

const _debounceMs = 400;
const _minInputLength = 2;
const _uuid = Uuid();

class GooglePlacesAutocompleteField extends StatefulWidget {
  const GooglePlacesAutocompleteField({
    super.key,
    required this.controller,
    this.placesDataSource,
    this.hintText = 'Location - Suburb & State',
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.countries,
    this.onPlaceSelected,
    this.validator,
    this.focusNode,
  });

  final TextEditingController controller;
  final PlacesFunctionsDataSource? placesDataSource;
  final String hintText;
  final TextInputAction textInputAction;
  final bool readOnly;
  final List<String>? countries;
  final void Function(PlaceDetailsResult place)? onPlaceSelected;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  @override
  State<GooglePlacesAutocompleteField> createState() =>
      _GooglePlacesAutocompleteFieldState();
}

class _GooglePlacesAutocompleteFieldState
    extends State<GooglePlacesAutocompleteField> {
  bool _showClearButton = false;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  Key _autoCompleteKey = UniqueKey();
  late PlacesFunctionsDataSource _places;
  late String _sessionToken;
  Timer? _debounce;
  List<PlaceSuggestion> _suggestions = [];
  bool _loadingSuggestions = false;
  int _autocompleteGeneration = 0;

  List<String> get _countries => widget.countries ?? _defaultCountries;

  @override
  void initState() {
    super.initState();
    _sessionToken = _uuid.v4();
    _places = widget.placesDataSource ?? PlacesFunctionsDataSource();
    _showClearButton = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onTextChanged);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant GooglePlacesAutocompleteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.placesDataSource != widget.placesDataSource) {
      _places = widget.placesDataSource ?? PlacesFunctionsDataSource();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    final hadFocus = _hasFocus;
    _hasFocus = _focusNode.hasFocus;
    if (!hadFocus && _hasFocus) {
      _sessionToken = _uuid.v4();
    }
    if (hadFocus && !_hasFocus) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted || _focusNode.hasFocus) return;
        setState(() {
          _suggestions = [];
          _autoCompleteKey = UniqueKey();
        });
      });
    }
  }

  void _onTextChanged() {
    setState(() {
      _showClearButton = widget.controller.text.isNotEmpty;
    });
    _scheduleAutocomplete();
  }

  void _scheduleAutocomplete() {
    _debounce?.cancel();
    final text = widget.controller.text.trim();
    if (text.length < _minInputLength) {
      setState(() {
        _suggestions = [];
        _loadingSuggestions = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: _debounceMs), () {
      _runAutocomplete(text);
    });
  }

  Future<void> _runAutocomplete(String input) async {
    final gen = ++_autocompleteGeneration;
    if (!mounted) return;
    setState(() => _loadingSuggestions = true);

    try {
      final list = await _places.autocomplete(
        input: input,
        sessionToken: _sessionToken,
        includedRegionCodes: _countries,
      );
      if (!mounted || gen != _autocompleteGeneration) return;
      setState(() {
        _suggestions = list;
        _loadingSuggestions = false;
      });
    } catch (e, st) {
      debugPrint('placesAutocomplete failed: $e\n$st');
      if (!mounted || gen != _autocompleteGeneration) return;
      setState(() {
        _suggestions = [];
        _loadingSuggestions = false;
      });
    }
  }

  void _clearText() {
    _debounce?.cancel();
    widget.controller.clear();
    setState(() {
      _sessionToken = _uuid.v4();
      _showClearButton = false;
      _suggestions = [];
    });
  }

  Future<void> _onSuggestionTap(PlaceSuggestion suggestion) async {
    _debounce?.cancel();
    FocusScope.of(context).unfocus();

    final label = suggestion.description.isNotEmpty
        ? suggestion.description
        : (suggestion.secondaryText.isNotEmpty
            ? '${suggestion.primaryText}, ${suggestion.secondaryText}'
            : suggestion.primaryText);
    widget.controller.text = label;

    setState(() {
      _suggestions = [];
      _showClearButton = label.isNotEmpty;
    });

    final token = _sessionToken;

    try {
      final details = await _places.placeDetails(
        placeId: suggestion.placeId,
        sessionToken: token,
      );
      if (!mounted) return;
      _sessionToken = _uuid.v4();
      widget.onPlaceSelected?.call(details);
    } catch (e, st) {
      debugPrint('placesPlaceDetails failed: $e\n$st');
      if (!mounted) return;
      _sessionToken = _uuid.v4();
    }
  }

  InputDecoration _buildInputDecoration() {
    return InputDecorationUtils.filled(
      context: context,
      hintText: widget.hintText,
      prefixIcon: SvgPicture.asset(
        'assets/svgs/search.svg',
        width: InputDecorationUtils.iconSize,
        fit: BoxFit.scaleDown,
      ),
      suffixIcon: _showClearButton
          ? IconButton(
              icon: const Icon(
                Icons.close,
                color: AppColors.greyBlack,
                size: _suggestionIconSize,
              ),
              onPressed: _clearText,
            )
          : (_loadingSuggestions && _focusNode.hasFocus
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null),
    );
  }

  Widget _buildTextField() {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ) ??
        const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        );

    final field = TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      style: textStyle,
      decoration: _buildInputDecoration(),
    );

    return widget.readOnly ? AbsorbPointer(child: field) : field;
  }

  Widget _buildSuggestionsList() {
    if (_suggestions.isEmpty) return const SizedBox.shrink();
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 240),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: _suggestions.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: AppColors.divider,
          ),
          itemBuilder: (context, index) {
            final s = _suggestions[index];
            return InkWell(
              onTap: () => _onSuggestionTap(s),
              child: _PlaceSuggestionTile(suggestion: s),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FormField<String>(
      initialValue: widget.controller.text,
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return _FormFieldControllerSync(
          controller: widget.controller,
          onSync: state.didChange,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.overlayBlack.withValues(alpha: 0.05),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: KeyedSubtree(
                  key: _autoCompleteKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField(),
                      if (_focusNode.hasFocus) _buildSuggestionsList(),
                    ],
                  ),
                ),
              ),
              if (state.hasError) ...[
                const SizedBox(height: 8),
                Text(
                  state.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                        fontSize: 12,
                      ) ??
                      TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _FormFieldControllerSync extends StatefulWidget {
  const _FormFieldControllerSync({
    required this.controller,
    required this.onSync,
    required this.child,
  });

  final TextEditingController controller;
  final void Function(String?) onSync;
  final Widget child;

  @override
  State<_FormFieldControllerSync> createState() =>
      _FormFieldControllerSyncState();
}

class _FormFieldControllerSyncState extends State<_FormFieldControllerSync> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_sync);
  }

  @override
  void didUpdateWidget(covariant _FormFieldControllerSync oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_sync);
      widget.controller.addListener(_sync);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_sync);
    super.dispose();
  }

  void _sync() {
    widget.onSync(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _PlaceSuggestionTile extends StatelessWidget {
  const _PlaceSuggestionTile({required this.suggestion});

  final PlaceSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      color: Colors.white,
      padding: _suggestionItemPadding,
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: AppColors.greyBlack,
            size: _suggestionIconSize,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.primaryText,
                  style: theme.bodyMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ) ??
                      const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                ),
                if (suggestion.secondaryText.isNotEmpty)
                  Text(
                    suggestion.secondaryText,
                    style: theme.bodySmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyBlack,
                        ) ??
                        const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyBlack,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
