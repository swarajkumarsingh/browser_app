extension StringExtension on String {
  bool get isValidEmail {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(this);
  }

  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
}

extension Prettify on String {
  /// Shortens a long string by taking the start n chars (5 is default)
  /// and the last n chars (if long enough). Useful for logging/printing.
  String shortenForPrint([int n = 5]) {
    if (length <= 2 * n) {
      return this;
    } else {
      return '${substring(0, n)}...${substring(length - n)}';
    }
  }
}

extension CStringExtension on String? {
  /// String Null Safe Handling
  String get jhNullSafe => this ?? '';
}

extension IntExtension on int? {
  /// Int type to String type integer
  String get jhIntToStr => (this ?? 0).toString();
}

extension NumExtension on num? {
  /// num type to String type integer
  String get jhToIntStr => (this ?? 0).toInt().toString();
}
