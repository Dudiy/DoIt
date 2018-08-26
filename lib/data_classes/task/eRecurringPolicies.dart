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

  static String policyToString(eRecurringPolicy policy){
    switch (policy){
      case eRecurringPolicy.none:
        return "None";
      case eRecurringPolicy.daily:
        return "Daily";
      case eRecurringPolicy.weekly:
        return "Weekly";
      case eRecurringPolicy.monthly:
        return "Monthly";
      case eRecurringPolicy.yearly:
        return "Yearly";
      default:
        return "Invalid value";
    }
  }
}
