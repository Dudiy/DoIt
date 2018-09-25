import 'package:do_it/app.dart';

class Strings {
  final App app = App.instance;
  Map<String, String> _currentLanguageMap;

  final Map<String, String> _english = {
    'email': 'Email',
    'password': 'Password',
    'resetPassword': 'Reset password',
    'name': 'Name',
    'loadingPage': 'Loading page...',
    'invalidValue': 'Invalid value',
    'uploadingImage': "Uploading image...",
    'profilePhotoUploadErrMsg': 'Error while uploading profile photo:',
    'gotIt': 'Got it',
    'loading': 'Loading...',
    // =================================================================
    // ==========================  Login page  =========================
    // =================================================================
    'newUserButton': 'New user?  Create an account',
    'sendingResetPasswordMsg': 'sending reset password mail...',
    'resetPasswordSentMsg': 'Reset password email has been sent to',
    'noRegisteredUserWithEmailMsg': 'There is no registered user with the given Email address',
    'loggingIn': 'Logging in...',
    'loginErrMsg': 'Error while trying to log in:',
    'loginWithGoogle': 'Log in with google',
    'loggingInWithGoogle': 'Logging in with google...',
    'loginWithGoogleErrMsg': 'Error while trying to log in with google:',
    'loginButtonText': 'LOGIN',
    // =================================================================
    // ========================  Register page  ========================
    // =================================================================
    'registerPageTitle': 'Registration',
    'register': 'Register',
    'passwordLenValidationMsg': 'Password must be at least 6 characters long',
    'registeringNewUserMsg': 'Registering new user...',
    'registrationErrMsg': 'Error while trying to register a new user:',
    // =================================================================
    // =======================  Recurring Policies  ====================
    // =================================================================
    'recurringPolicyNone': 'None',
    'recurringPolicyDaily': 'Daily',
    'recurringPolicyWeekly': 'Weekly',
    'recurringPolicyMonthly': 'Monthly',
    'recurringPolicyYearly': 'Yearly',
    // =================================================================
    // =====================  Task Completed results  ==================
    // =================================================================
    'taskCompletedMsg': 'You have completed the task:',
    'loginToCompleteTaskMsg': 'Please log in first in order to complete the task',
    'userCompletedNotInDbErrMsg': 'Please reconnect to the application in order to complete the task',
    'taskNotFoundErrMsg': 'The task associated with this tag does not exist anymore',
    'userNotAssignedToTaskErrMsg': 'You are not assigned to the task associated with this tag',
    'taskDoesNotExistsErrMsg': 'The task associated with this tag does not exist anymore',
    'startTimeAfterEndTimeErrMsg': 'Start time cannot be later than end time',
    'addTaskFailedErrMsg': 'Failed to add task',
    'unknownCompleteTaskStatusErrMsg': 'Unknown complete task status',
  };

  final Map<String, String> _hebrew = {
    'email': 'דוא\"ל',
    'password': 'סיסמא',
    'resetPassword': 'איפוס סיסמא',
    'name': 'שם משתמש',
    'loadingPage': 'טוען דף...',
    'invalidValue': 'ערך לא תקין',
    'uploadingImage': "מעלה את התמונה...",
    'profilePhotoUploadErrMsg': 'אירעה שגיאה בעת העלאת תמונת הפרופיל:',
    'gotIt': 'הבנתי',
    'loading': 'טוען...',
    // =================================================================
    // ==========================  Login page  =========================
    // =================================================================
    'newUserButton': 'משתמש חדש? צור חשבון',
    'sendingResetPasswordMsg': 'שולח הודעת איפוס סיסמא...',
    'resetPasswordSentMsg': 'הודעת איפוס סיסמא נשלחה לכתובת',
    'noRegisteredUserWithEmailMsg': 'אין משתמש רשום עם כתובת זו',
    'loggingIn': 'מתחבר...',
    'loginErrMsg': 'שגיאה בעת ההתחברות:',
    'loginWithGoogle': 'התברות באמצעות Google',
    'loggingInWithGoogle': 'מתחבר באמצעות Google...',
    'loginWithGoogleErrMsg': 'אירעה שגיאה בעת התחברות באמצעות Google:',
    'loginButtonText': 'התחבר',
    // =================================================================
    // ========================  Register page  ========================
    // =================================================================
    'registerPageTitle': 'הרשמה',
    'register': 'הירשם',
    'passwordLenValidationMsg': 'על הסיסמא להכיל לפחות 6 תווים',
    'registeringNewUserMsg': 'מבצע הרשמה...',
    'registrationErrMsg': 'אירעה שגיאה בעת רישום משתמש חדש:',
    // =================================================================
    // =======================  Recurring Policies  ====================
    // =================================================================
    'recurringPolicyNone': 'ללא',
    'recurringPolicyDaily': 'יומי',
    'recurringPolicyWeekly': 'שבועי',
    'recurringPolicyMonthly': 'חודשי',
    'recurringPolicyYearly': 'שנתי',
    // =================================================================
    // =====================  Task Completed results  ==================
    // =================================================================
    'taskCompletedMsg': 'סיימת בהצלחה את המטלה:',
    'loginToCompleteTaskMsg': 'יש לבצע התחברות בכדי לסיים מטלות',
    'userCompletedNotInDbErrMsg': 'לא הצלחנו לזהות אותך, יתכן שהמשתמש שלך נמחק מהמערכת',
    'taskNotFoundErrMsg': 'המטלה שנכתבה על תג זה איננה קיימת יותר, ייתכן שמישהו כבר ביצע אותה',
    'userNotAssignedToTaskErrMsg': 'מטלה זו לא הוקצתה לך',
    'taskDoesNotExistsErrMsg': 'המטלה שנכתבה על תג זה איננה קיימת יותר, ייתכן שמישהו כבר ביצע אותה',
    'startTimeAfterEndTimeErrMsg': 'זמן התחלת המטלה לא יכול להיות לפני תאריך היעד שלה',
    'addTaskFailedErrMsg': 'אירעה שגיאה ביצירת המטלה',
    'unknownCompleteTaskStatusErrMsg': 'שגיאה לא מוגדרת',
  };

  Strings([String languageCode]) {
    setLanguage(languageCode);
  }

  // =================================================================
  // ===========================  General  ===========================
  // =================================================================
  String get email => _currentLanguageMap['email'] ?? _english['email'];
  String get password => _currentLanguageMap['password'] ?? _english['password'];
  String get resetPassword => _currentLanguageMap['resetPassword'] ?? _english['resetPassword'];
  String get name => _currentLanguageMap['name'] ?? _english['name'];
  String get loadingPage => _currentLanguageMap['loadingPage'] ?? _english['loadingPage'];
  String get invalidValue => _currentLanguageMap['invalidValue'] ?? _english['invalidValue'];
  String get uploadingImage => _currentLanguageMap['uploadingImage'] ?? _english['uploadingImage'];
  String get profilePhotoUploadErrMsg =>
      _currentLanguageMap['profilePhotoUploadErrMsg'] ?? _english['profilePhotoUploadErrMsg'];
  String get gotIt => _currentLanguageMap['gotIt'] ?? _english['gotIt'];
  String get loading => _currentLanguageMap['loading'] ?? _english['loading'];
  // =================================================================
  // ==========================  Login page  =========================
  // =================================================================
  String get newUserButton => _currentLanguageMap['newUserButton'] ?? _english['newUserButton'];
  String get sendingResetPasswordMsg =>
      _currentLanguageMap['sendingResetPasswordMsg'] ?? _english['sendingResetPasswordMsg'];
  String get resetPasswordSentMsg => _currentLanguageMap['resetPasswordSentMsg'] ?? _english['resetPasswordSentMsg'];
  String get noRegisteredUserWithEmailMsg =>
      _currentLanguageMap['noRegisteredUserWithEmailMsg'] ?? _english['noRegisteredUserWithEmailMsg'];
  String get loggingIn => _currentLanguageMap['loggingIn'] ?? _english['loggingIn'];
  String get loginErrMsg => _currentLanguageMap['loginErrMsg'] ?? _english['loginErrMsg'];
  String get loginWithGoogle => _currentLanguageMap['loginWithGoogle'] ?? _english['loginWithGoogle'];
  String get loggingInWithGoogle => _currentLanguageMap['loggingInWithGoogle'] ?? _english['loggingInWithGoogle'];
  String get loginWithGoogleErrMsg => _currentLanguageMap['loginWithGoogleErrMsg'] ?? _english['loginWithGoogleErrMsg'];
  String get loginButtonText => _currentLanguageMap['loginButtonText'] ?? _english['loginButtonText'];

  // =================================================================
  // =========================  Register page  =======================
  // =================================================================
  String get registerPageTitle => _currentLanguageMap['registerPageTitle'] ?? _english['registerPageTitle'];
  String get register => _currentLanguageMap['register'] ?? _english['register'];
  String get passwordLenValidationMsg =>
      _currentLanguageMap['passwordLenValidationMsg'] ?? _english['passwordLenValidationMsg'];
  String get registeringNewUserMsg => _currentLanguageMap['registeringNewUserMsg'] ?? _english['registeringNewUserMsg'];
  String get registrationErrMsg => _currentLanguageMap['registrationErrMsg'] ?? _english['registrationErrMsg'];

  // =================================================================
  // =======================  Recurring Policies  ====================
  // =================================================================
  String get recurringPolicyNone => _currentLanguageMap['recurringPolicyNone'] ?? _english['recurringPolicyNone'];
  String get recurringPolicyDaily => _currentLanguageMap['recurringPolicyDaily'] ?? _english['recurringPolicyDaily'];
  String get recurringPolicyWeekly => _currentLanguageMap['recurringPolicyWeekly'] ?? _english['recurringPolicyWeekly'];
  String get recurringPolicyMonthly =>
      _currentLanguageMap['recurringPolicyMonthly'] ?? _english['recurringPolicyMonthly'];
  String get recurringPolicyYearly => _currentLanguageMap['recurringPolicyYearly'] ?? _english['recurringPolicyYearly'];

  // =================================================================
  // =====================  Task Completed results  ==================
  // =================================================================
  String get taskCompletedMsg => _currentLanguageMap['taskCompletedMsg'] ?? _english['taskCompletedMsg'];
  String get loginToCompleteTaskMsg =>
      _currentLanguageMap['loginToCompleteTaskMsg'] ?? _english['loginToCompleteTaskMsg'];
  String get userCompletedNotInDbErrMsg =>
      _currentLanguageMap['userCompletedNotInDbErrMsg'] ?? _english['userCompletedNotInDbErrMsg'];
  String get taskNotFoundErrMsg => _currentLanguageMap['taskNotFoundErrMsg'] ?? _english['taskNotFoundErrMsg'];
  String get userNotAssignedToTaskErrMsg =>
      _currentLanguageMap['userNotAssignedToTaskErrMsg'] ?? _english['userNotAssignedToTaskErrMsg'];
  String get taskDoesNotExistsErrMsg =>
      _currentLanguageMap['taskDoesNotExistsErrMsg'] ?? _english['taskDoesNotExistsErrMsg'];
  String get startTimeAfterEndTimeErrMsg =>
      _currentLanguageMap['startTimeAfterEndTimeErrMsg'] ?? _english['startTimeAfterEndTimeErrMsg'];
  String get addTaskFailedErrMsg => _currentLanguageMap['addTaskFailedErrMsg'] ?? _english['addTaskFailedErrMsg'];
  String get unknownCompleteTaskStatusErrMsg =>
      _currentLanguageMap['unknownCompleteTaskStatusErrMsg'] ?? _english['unknownCompleteTaskStatusErrMsg'];

  // =================================================================
  // ===========================  Dialogs  ===========================
  // =================================================================
  get notificationFromGroupTitle => 'Notification from group';

  get addMemberNotificationErrMsg => 'has been added to the group but due to a connection error, a notification was not sent';
  get emailAddressesAreCaseSensitive => '** Email addresses are case sensitive **';
  get addedToGroupMsg => 'You have been added to this group';
  get addMemberTitle => 'add Member';

  get scoreboard => 'scoreboard';

  get confirm => 'Confirm';

  String get oops => 'Oops...';

  String get ok => 'Ok';

  String get submit => 'Submit';

  String get cancel => 'Cancel';

  get groupNotificationTitle => 'Notification from group';

  get sendNotificationTitle => 'Send notification';

  get notificationMessageLable => 'notification message';

  get hasBeenAddedToThisGroup => 'has been added to this group';

  get notifyMembersLabel => 'notify members';

  get newTaskLabel => 'new task';

  get leaveGroupErrorPrefixMsg => 'Error while trying to leave group, please try again.\nInner exception:';

  get leavingGroup => 'Leaving group...';

  get leave => 'Leave';

  get leaveGroupConfirmMsg => 'Are you sure you would like to leave this group? \nThis cannot be undone';

  get deletingGroup => 'Deleting group...';

  get delete => 'Delete';

  get deleteGroupConfirmMsg => 'Are you sure you would like to delete this group? \nThis cannot be undone';

  String get leaveGroupLabel => 'Leave group';

  String get deleteGroupLabel => 'Delete group';

  String get help => 'Help';

  String get groupInfo => 'Group info';

  String get noCompletedTasks => 'No completed tasks';

  String get selectTimespanPrompt => 'Please select a timespan';

  get week => 'week';

  get month => 'month';

  get allTime => 'all time';

  String get fetchingTasksFromServer => 'Fetching tasks from server...';

  String get noTasksAssignedToOthers => 'There are no tasks assigned to others in this group';

  String get noTasksAssignetToYou => 'There are no tasks assigned to you in this group';

  String get noFutureTasks => 'There are no future tasks in this group';

  String get futureTasks => 'Future tasks';

  get tasksAssignedToOthersTitle => 'Tasks assigned to others';

  get tasksAssignedToMeTitle => 'Tasks assigned to me';

  String get completedTasksTitle => 'Completed tasks';

  get addTaskTitle => 'Add task';

  get dueTime => 'Due time';

  get startTime => 'Start time';

  get description => 'Description';

  get taskValueIntegerValidationMsg => 'Task value must be a positive integer';

  get taskValueLabel => 'Task value';

  get titleLabel => 'Title';

  get loadingPhotoErrMsgPrefix => 'Error while uploading group photo:';

  get updatingGroupPhoto => 'Updating group photo...';

  void setLanguage(String languageCode) {
    switch (languageCode) {
      case "he":
        _currentLanguageMap = _hebrew;
        break;
      default:
        _currentLanguageMap = _english;
    }
  }
}
