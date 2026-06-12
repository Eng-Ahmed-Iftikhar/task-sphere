extension TextCasing on String {
  String capitalize() => isNotEmpty ? this[0].toUpperCase() + substring(1) : '';

  String capitalizeWords() => split(' ').map((e) => e.capitalize()).join(' ');
}

String maskString(String value, {int visible = 3}) {
  if (value.length <= visible) return value;
  return value.substring(0, visible) + '*' * (value.length - visible);
}

String shortenString(String value, {int max = 10}) {
  if (value.length <= max) return value;
  return '${value.substring(0, max)}...';
}
