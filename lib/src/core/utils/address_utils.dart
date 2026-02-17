/// Utility functions for address manipulation
class AddressUtils {
  /// Removes house numbers from the beginning of an address string
  /// and formats it to show: Street, Suburb, State
  ///
  /// Examples:
  /// - "123 George Street, Sydney NSW 2000, Australia" -> "George Street, Sydney, NSW"
  /// - "45B Main Street, Melbourne VIC 3000" -> "Main Street, Melbourne, VIC"
  /// - "Richmond, VIC" -> "Richmond, VIC" (unchanged)
  static String removeHouseNumber(String? address) {
    if (address == null || address.isEmpty) {
      return '';
    }

    // Remove house number from the beginning
    // Pattern matches: digits + optional letter + optional unit number (/digits) + space
    final houseNumberPattern = RegExp(r'^\d+[A-Za-z]?(/\d+)?\s+');
    String formatted = address.replaceFirst(houseNumberPattern, '');

    // Remove ", Australia" from the end
    formatted = formatted.replaceAll(RegExp(r',?\s*Australia$'), '');

    // Handle postcode format: "Sydney NSW 2000" -> "Sydney, NSW"
    // Pattern: (Suburb) (State) (Postcode) -> (Suburb), (State)
    final postcodePattern = RegExp(r'\s+([A-Z]{2,3})\s+\d{4}');
    formatted = formatted.replaceAllMapped(postcodePattern, (match) {
      return ', ${match.group(1)}';
    });

    // Clean up any double commas or extra spaces
    formatted = formatted.replaceAll(RegExp(r',\s*,'), ',');
    formatted = formatted.replaceAll(RegExp(r'\s+'), ' ');
    formatted = formatted.trim();

    return formatted;
  }
}
