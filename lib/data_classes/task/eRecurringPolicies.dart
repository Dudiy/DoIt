enum eRecurringPolicy {
  none,
  daily,
  weekly,
  monthly,
  yearly,
}

class RecurringPolicyUtils {
  static eRecurringPolicy parse(String string) {
    return eRecurringPolicy.values.firstWhere((e) => e.toString() == string, orElse: null);
  }
}
