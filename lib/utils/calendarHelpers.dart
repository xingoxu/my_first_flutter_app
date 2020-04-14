int getDayPadding(int year, int month) {
  var _beginMonthPadding = new DateTime(year, month, 1).weekday;
  return _beginMonthPadding == 7
      ? (_beginMonthPadding = 0)
      : _beginMonthPadding;
}

int getNumberOfDaysInMonth(int year, int month) => [
      0,
      31,
      year % 4 == 0 && year % 100 != 0 ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ][month];
