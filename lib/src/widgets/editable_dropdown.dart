import 'package:dreusables/src/const/theme/app_colors.dart';
import 'package:dreusables/src/const/theme/app_spacing.dart';
import 'package:dreusables/src/core/extensions/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/extensions/widget_extension.dart';

class EditableDropdown<T> extends StatefulWidget {
  const EditableDropdown({
    super.key,
    required this.label,
    required this.items,
    this.selectedId,
    this.selectedIds = const [],
    required this.itemToString,
    required this.itemToId,
    this.onSelected,
    this.onMultiSelected,
    this.isMultiSelect = false,
    this.hintText = 'Select',
    this.emptyMessage = 'No items available',
    this.maxHeight = 200,
    this.isError = false,
  });

  final String label;
  final List<T> items;
  final String? selectedId;
  final List<String> selectedIds;
  final String Function(T item) itemToString;
  final String Function(T item) itemToId;
  final void Function(T item)? onSelected;
  final void Function(List<T> items)? onMultiSelected;
  final String hintText;
  final String emptyMessage;
  final double maxHeight;
  final bool isError;
  final bool isMultiSelect;

  @override
  State<EditableDropdown<T>> createState() => _EditableDropdownState<T>();
}

class _EditableDropdownState<T> extends State<EditableDropdown<T>>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _rotationController.forward();
      } else {
        _rotationController.reverse();
      }
    });
  }

  void _onItemSelected(T item) {
    if (widget.isMultiSelect) {
      // Build updated selection list and notify caller, but keep dropdown open.
      final currentIds = Set<String>.from(widget.selectedIds);
      final id = widget.itemToId(item);
      final wasSelected = currentIds.contains(id);
      if (wasSelected) {
        currentIds.remove(id);
      } else {
        currentIds.add(id);
      }
      final updatedItems = widget.items
          .where((element) => currentIds.contains(widget.itemToId(element)))
          .toList();

      // Debug logging
      debugPrint(
        '🔄 EditableDropdown: Multi-select toggle - Item: ${widget.itemToString(item)}, WasSelected: $wasSelected, UpdatedCount: ${updatedItems.length}',
      );

      // Call the callback to update parent state
      if (widget.onMultiSelected != null) {
        widget.onMultiSelected!(updatedItems);
      } else {
        debugPrint('❌ EditableDropdown: onMultiSelected is null!');
      }

      // Update local UI state immediately for visual feedback
      setState(() {
        // The visual selection will update when parent rebuilds with new selectedIds
        // This setState ensures the dropdown stays open and ready for next selection
      });
    } else {
      widget.onSelected?.call(item);
      setState(() {
        _isExpanded = false;
        _rotationController.reverse();
      });
    }
  }

  T? _getSelectedItem() {
    if (widget.isMultiSelect ||
        widget.selectedId == null ||
        widget.items.isEmpty) {
      return null;
    }
    try {
      return widget.items.firstWhere(
        (item) => widget.itemToId(item) == widget.selectedId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final selectedItem = _getSelectedItem();
    String displayText;
    if (widget.isMultiSelect) {
      final selectedItems = widget.items
          .where((item) => widget.selectedIds.contains(widget.itemToId(item)))
          .toList();
      if (selectedItems.isEmpty) {
        displayText = widget.hintText;
      } else {
        displayText =
            selectedItems.map((e) => widget.itemToString(e)).join(', ');
      }
    } else {
      displayText = selectedItem != null
          ? widget.itemToString(selectedItem)
          : widget.hintText;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: theme.bodyRegular),
        8.heightBox,
        InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.inputPadding,
              vertical: AppSpacing.inputPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
              border: Border.all(
                color:
                    widget.isError ? AppColors.error : const Color(0xffE5E5E5),
                width: widget.isError ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    displayText,
                    style: theme.bodyMedium?.copyWith(
                      color: (widget.isMultiSelect
                              ? widget.selectedIds.isNotEmpty
                              : selectedItem != null)
                          ? AppColors.textPrimary
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: SvgPicture.asset('assets/svgs/Dropdown.svg'),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(maxHeight: widget.maxHeight),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
              border: Border.all(color: const Color(0xffE5E5E5)),
            ),
            child: widget.items.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.emptyMessage,
                      style: theme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => 8.heightBox,
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = widget.isMultiSelect
                          ? widget.selectedIds.contains(widget.itemToId(item))
                          : widget.itemToId(item) == widget.selectedId;
                      return InkWell(
                        onTap: () => _onItemSelected(item),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.backgroundGrey
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.borderLight,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Center(
                                        child: Icon(
                                          size: 12,
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                              8.widthBox,
                              Expanded(
                                child: Text(
                                  widget.itemToString(item),
                                  style: theme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }
}
