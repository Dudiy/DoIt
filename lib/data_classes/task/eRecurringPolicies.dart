import 'package:do_it/app.dart';

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

  static String policyToString(eRecurringPolicy policy) {
    final App app = App.instance;
    switch (policy) {
      case eRecurringPolicy.none:
        return app.strings.recurringPolicyNone;
      case eRecurringPolicy.daily:
        return app.strings.recurringPolicyDaily;
      case eRecurringPolicy.weekly:
        return app.strings.recurringPolicyWeekly;
      case eRecurringPolicy.monthly:
        return app.strings.recurringPolicyMonthly;
      case eRecurringPolicy.yearly:
        return app.strings.recurringPolicyYearly;
      default:
        return app.strings.invalidValue;
    }
  }
}
