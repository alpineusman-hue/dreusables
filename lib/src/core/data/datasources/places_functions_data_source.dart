import 'package:cloud_functions/cloud_functions.dart';

class PlaceSuggestion {
  const PlaceSuggestion({
    required this.placeId,
    required this.primaryText,
    required this.secondaryText,
    required this.description,
  });

  final String placeId;
  final String primaryText;
  final String secondaryText;
  final String description;
}

class PlaceAddressComponent {
  const PlaceAddressComponent({
    required this.longText,
    required this.shortText,
    required this.types,
  });

  final String longText;
  final String shortText;
  final List<String> types;
}

class PlaceDetailsResult {
  const PlaceDetailsResult({
    required this.placeId,
    required this.displayName,
    required this.formattedAddress,
    required this.lat,
    required this.lng,
    required this.addressComponents,
  });

  final String placeId;
  final String displayName;
  final String formattedAddress;
  final double? lat;
  final double? lng;
  final List<PlaceAddressComponent> addressComponents;
}

class PlacesFunctionsDataSource {
  PlacesFunctionsDataSource({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  Future<List<PlaceSuggestion>> autocomplete({
    required String input,
    required String sessionToken,
    List<String>? includedRegionCodes,
  }) async {
    final payload = <String, dynamic>{
      'input': input,
      'sessionToken': sessionToken,
    };
    if (includedRegionCodes != null && includedRegionCodes.isNotEmpty) {
      payload['includedRegionCodes'] = includedRegionCodes;
    }

    final result =
        await _functions.httpsCallable('placesAutocomplete').call(payload);
    final data = _asStringKeyedMap(result.data);
    final raw = data['suggestions'];
    if (raw is! List) return [];

    final out = <PlaceSuggestion>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final m = _asStringKeyedMap(item);
      final placeId = m['placeId'] as String? ?? '';
      if (placeId.isEmpty) continue;
      out.add(
        PlaceSuggestion(
          placeId: placeId,
          primaryText: m['primaryText'] as String? ?? '',
          secondaryText: m['secondaryText'] as String? ?? '',
          description: m['description'] as String? ?? '',
        ),
      );
    }
    return out;
  }

  Future<PlaceDetailsResult> placeDetails({
    required String placeId,
    required String sessionToken,
  }) async {
    final result = await _functions.httpsCallable('placesPlaceDetails').call({
      'placeId': placeId,
      'sessionToken': sessionToken,
    });
    final m = _asStringKeyedMap(result.data);
    final componentsRaw = m['addressComponents'];
    final components = <PlaceAddressComponent>[];
    if (componentsRaw is List) {
      for (final c in componentsRaw) {
        if (c is! Map) continue;
        final cm = _asStringKeyedMap(c);
        final typesRaw = cm['types'];
        final types = <String>[];
        if (typesRaw is List) {
          for (final t in typesRaw) {
            if (t is String) types.add(t);
          }
        }
        components.add(
          PlaceAddressComponent(
            longText: cm['longText'] as String? ?? '',
            shortText: cm['shortText'] as String? ?? '',
            types: types,
          ),
        );
      }
    }

    final lat = m['lat'];
    final lng = m['lng'];

    return PlaceDetailsResult(
      placeId: m['placeId'] as String? ?? placeId,
      displayName: m['displayName'] as String? ?? '',
      formattedAddress: m['formattedAddress'] as String? ?? '',
      lat: lat is num ? lat.toDouble() : null,
      lng: lng is num ? lng.toDouble() : null,
      addressComponents: components,
    );
  }

  Map<String, dynamic> _asStringKeyedMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v));
    }
    return {};
  }
}
