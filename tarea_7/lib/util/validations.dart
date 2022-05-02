extension Validator on String {
  bool get isValidPhon {
    return RegExp(r'^\d{9}$').hasMatch(this);
  }

  bool get isValidPostalCod {
    return RegExp(r'^\d+$').hasMatch(this);
  }

  bool get isNumber {
    return RegExp(r'^\d+$').hasMatch(this);
  }
}
