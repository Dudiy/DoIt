enum eRecurringPolicy {
  NONE,
  DAILY,
  WEEKLY,
  MONTHLY,
  YEARLY,
}

class RecurringPolicyUtils {
  static eRecurringPolicy parse(String string) {
    return eRecurringPolicy.values.firstWhere((e) => e.toString() == string, orElse: null);
  }

  static String policyToString(eRecurringPolicy policy) {
    switch (policy) {
      case eRecurringPolicy.NONE:
        return "None";
      case eRecurringPolicy.DAILY:
        return "Daily";
      case eRecurringPolicy.WEEKLY:
        return "Weekly";
      case eRecurringPolicy.MONTHLY:
        return "Monthly";
      case eRecurringPolicy.YEARLY:
        return "Yearly";
      default:
        return "Invalid value";
    }
  }
}
