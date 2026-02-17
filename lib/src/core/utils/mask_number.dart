class MaskNumber {
  String mask(String phone) {
    if (phone.length < 4) return phone;
    final start = phone.substring(0, 2);
    final end = phone.substring(phone.length - 2);
    final masked = '*' * (phone.length - 4);
    return '$start$masked$end';
  }
}
