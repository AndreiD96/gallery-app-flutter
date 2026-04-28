class AppFormatter {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String formatDate(DateTime? date) {
    if (date == null) {
      return 'N/A';
    }
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }
}
