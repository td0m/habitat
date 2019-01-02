DateTime getMonthStart(DateTime date) {
  DateTime startingDay = date;
  while (startingDay.day != 1) {
    startingDay = startingDay.subtract(Duration(days: 1));
  }
  return startingDay;
}
