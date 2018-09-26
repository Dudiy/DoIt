import 'package:do_it/app.dart';
import 'package:flutter/material.dart';

class Strings {
  final App app = App.instance;
  Map<String, String> _currentLanguageMap;

  //region language mappings
  final Map<String, String> _english = {
    // =================================================================
    // ===========================  General  ===========================
    // =================================================================
    'email': 'Email',
    'password': 'Password',
    'resetPassword': 'Reset password',
    'name': 'Name',
    'loadingPage': 'Loading page...',
    'invalidValue': 'Invalid value',
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
    'loginWithGoogle': 'Log in with google',
    'loggingInWithGoogle': 'Logging in with google...',
    'loginButtonText': 'LOGIN',

    // =================================================================
    // ========================  Register page  ========================
    // =================================================================
    'registerPageTitle': 'Registration',
    'register': 'Register',
    'passwordLenValidationMsg': 'Password must be at least 6 characters long',
    'registeringNewUserMsg': 'Registering new user...',

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

    // =================================================================
    // ===========================  General  ===========================
    // =================================================================
    // ~~ user ~~~
    'userID': 'User ID',
    // ~~~ group ~~~
    'groupInfo': 'Group info',
    'groupId': 'Group ID',
    'groupTitleLable': 'Group title',
    'groupManager': 'Group manager',
    'groupMembers': 'Group Members',
    'members': 'Members',
    'groupHasNoMembers': 'The group has no members...',
    // ~~~ task ~~~
    'titleLabel': 'Title',
    'tasks': 'Tasks',
    'valueLabel': 'Value',
    'timeNotSet': 'Time not set',
    'repeat': 'Repeat',
    'completedBy': 'Completed by',
    'completedOn': 'Completed on',
    'points': 'points',
    // ~~~ App Settings Page ~~~
    'appSettings': 'App settings',
    'changeTheme': 'Change theme',
    'messageDevs': 'Message the developers',
    'resetPasswordSentTo': 'Reset password email has been sent to',
    'signOut': 'Sign out',
    'deleteAccount': 'Delete account',
    'selectTheme': 'Select Theme',
    'composeMsgToDevsTitle': 'What would you like to tell us?',
    'deleteAccountConfirmMsg': 'are you sure you want to delete this account? this cannot be undone',

    // =================================================================
    // ==================  Dialogs and Notifications ===================
    // =================================================================
    // ~~~ buttons labels and titles ~~~
    'confirm': 'Confirm',
    'submit': 'Submit',
    'ok': 'Ok',
    'oops': 'Oops...',
    'delete': 'Delete',
    'cancel': 'Cancel',
    'leave': 'Leave',
    'help': 'Help',
    'update': 'Update',
    'newGroupTitle': 'New Group',
    'pleaseSelect': 'please select',
    'tapToChange': 'tap to change',
    'descriptionLabel': 'Description',
    'leaveGroupLabel': 'Leave group',
    'deleteGroupLabel': 'Delete group',
    'addMemberTitle': 'add Member',
    'selectAssignedMembersTitle': 'Select assigned members',
    'newTask': 'New task',
    'scoreboard': 'scoreboard',
    'futureTasks': 'Future tasks',
    'week': 'week',
    'month': 'month',
    'allTime': 'all time',
    'dueTime': 'Due time',
    'startTime': 'Start time',
    'notifyMembers': 'notify members',
    'taskNotificationTitle': 'Notification from task',
    'assignedMembers': 'Assigned members',
    'displayName': 'Display name',
    'deleteTask': 'Delete task',
    'writeToNfc': 'Write to NFC',
    'readyToWrite': 'Ready to write',
    'holdPhoneOverNfc': 'Hold phone over NFC tag',
    'today': 'today',
    'thisWeek': 'this week',
    'thisMonth': 'this month',
    'selectLanguageTitle': 'Select Language',
    // ~~~ Notification messages ~~~
    'notificationFromGroupTitle': 'Notification from group',
    'sendNotificationTitle': 'Send notification',
    'notificationMessageLable': 'notification message',
    'addedToGroupMsg': 'You have been added to this group',
    'hasBeenAddedToThisGroup': 'has been added to this group',
    'leaveGroupConfirmMsg': 'Are you sure you would like to leave this group? \nThis cannot be undone',
    'deleteTaskConfirmMsg': 'Are you sure you would like to delete this task? \nThis cannot be undone',
    'hi': 'Hi',
    'oneTaskRemainingMsg': 'You only have one task remaining in all groups, lets get to work...',
    'allTasksRemainingMsg': '- thats all the tasks you have remaining in all groups, lets get to work...',
    'noTasksRemainingMsg': 'Awsome! you have no tasks to do :)',
    'notInAnyGroup': 'You are not in any group yet',
    'noDescription': 'No description entered',

    // ~~~ message bodies ~~~
    'deleteGroupConfirmMsg': 'Are you sure you would like to delete this group? \nThis cannot be undone',
    'selectTimespanPrompt': 'Please select a timespan',
    'noCompletedTasks': 'No completed tasks',
    'msgSentToDevs': 'Your message has been sent to the developers. Thank you :)',

    // ~~~ single group page ~~~
    'tasksAssignedToOthersTitle': 'Tasks assigned to others',
    'tasksAssignedToMeTitle': 'Tasks assigned to me',
    'completedTasksTitle': 'Completed tasks',
    'noTasksAssignedToOthers': 'There are no tasks assigned to others in this group',
    'noTasksAssignetToYou': 'There are no tasks assigned to you in this group',
    'noFutureTasks': 'There are no future tasks in this group',

    // ~~~ remove member ~~~
    'removeMemberLable': 'Remove member',
    'confirmRemove': 'Are you sure you would like to remove',
    'fromTheGroup': 'from the group',

    // ~~~ fetching from DB and loading overlay messages ~~~
    'fetchingAssignedMembers': 'Fetching assigned members...',
    'fetchingTasksFromServer': 'Fetching tasks...',
    'fetchingGroups': 'Fetching groups...',
    'fetchingScoreboard': 'Fetching score board...',
    'removingGroupMember': 'Removing group member...',
    'leavingGroup': 'Leaving group...',
    'deletingGroup': 'Deleting group...',
    'deletingAccount': 'Deleting this account...',
    'deletingTask': "Deleting task...",
    'uploadingImage': "Uploading image...",

    // =================================================================
    // =======================  Error Messages  ========================
    // =================================================================
    'addMemberNotificationErrMsg':
        'has been added to the group but due to a connection error, a notification was not sent',
    'taskValueIntegerValidationMsg': 'Task value must be a positive integer',
    'emailAddressesAreCaseSensitive': '** Email addresses are case sensitive **',
    'leaveGroupErrorPrefixMsg': 'Error while trying to leave group, please try again.\n\nException details:\n',
    'uploadPhotoErrMsg': 'Error while uploading photo, please try again.\n\nException details:\n',
    'sendMsgToDevsErr': 'Error while sending message, please try again.\n\nException details:\n',
    'taskNotUpdatedErrMsg':
        'Could not update task due to the following error, please try again.\n\nException details:\n',
    'getGroupInfoErrMsg': 'Error while trying to get group info, please try again.\n\nException details:\n',
    'parentGroupNotFoundErrMsg': 'Group containig the task was not found',
    'removeMemberFromGroupErrMsg':
        'Error while removing member from group, the member has not been removed, please try again.\n\nException details:\n',
    'editGroupInfoErrMsg':
        'Error while updating group info, the group info will not be updated, please try again.\n\nException details:\n',
    'deleteGroupErrMsg': 'Error while deleting group, please try again.\n\nException details:\n',
    'scoreBoardFetchErrMsg':
        'Error while trying to get the group scoreboard, please try again.\n\nException details:\n',
    'addMemberErrMsgPrefix': 'Error while trying to add new member, please try again.\n\nException details:\n',
    'openTaskDetailsPageErrMsg':
        'Error while trying to open task details page, please try again.\n\nException details:\n',
    'deleteTaskErrMsg': 'Error while trying to delete task, please try again.\n\nException details:\n',
    'signOutErrMsg': 'Error while signing out, please try again.\n\nException details:\n',
    'atLeastOneMustBeSelected': 'At least one user must be selected',
    'sendNotificationsErrMsgPrefix':
        'Error while sending notifications, the following users did not get the notification:\n',
    'invalidEmail': 'Invalid email address',
    'loginErrMsg': 'Error while trying to log in, please try again.\n\nException details:\n',
    'registrationErrMsg': 'Error while trying to register a new user, please try again.\n\nException details:\n',
    'loginWithGoogleErrMsg': 'Error while trying to log in with google, please try again.\n\nInner exception:\n',
    'fieldCannotBeEmpty': 'This field cannot be empty',

    // =================================================================
    // ==========================  Languages  ==========================
    // =================================================================
    'hebrew': 'Hebrew',
    'english': 'English',
    'russian': 'Russian',
    'changeLanguage': 'Change language',
  };

  final Map<String, String> _hebrew = {
    'email': 'דוא\"ל',
    'password': 'סיסמא',
    'resetPassword': 'איפוס סיסמא',
    'name': 'שם משתמש',
    'loadingPage': 'טוען דף...',
    'invalidValue': 'ערך לא תקין',
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
    'loginWithGoogle': 'התברות באמצעות Google',
    'loggingInWithGoogle': 'מתחבר באמצעות Google...',
    'loginButtonText': 'התחבר',
    // =================================================================
    // ========================  Register page  ========================
    // =================================================================
    'registerPageTitle': 'הרשמה',
    'register': 'הירשם',
    'passwordLenValidationMsg': 'על הסיסמא להכיל לפחות 6 תווים',
    'registeringNewUserMsg': 'מבצע הרשמה...',
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

    // =================================================================
    // ===========================  General  ===========================
    // =================================================================
    // ~~ user ~~~
    'userID': 'מזהה משתמש',
    // ~~~ group ~~~
    'groupInfo': 'פרטי קבוצה',
    'groupId': 'מזהה קבוצה',
    'groupTitleLable': 'שם הקבוצה',
    'groupManager': 'מנהל הקבוצה',
    'groupMembers': 'משתתפי הקבוצה',
    'members': 'משתתפים',
    'groupHasNoMembers': 'אין משתתפים בקבוצה...',
    // ~~~ task ~~~
    'titleLabel': 'כותרת',
    'tasks': 'מטלות',
    'valueLabel': 'ניקוד',
    'timeNotSet': 'זמן לא הוגדר',
    'repeat': 'חזרה',
    'completedBy': 'בוצע ע"י',
    'completedOn': 'בוצע ב',
    'points': 'נקודות',
    // ~~~ App Settings Page ~~~
    'appSettings': 'הגדרות',
    'changeTheme': 'שנה ערכת נושא',
    'messageDevs': 'שליחת הודעה למפתחים',
    'resetPasswordSentTo': 'הודעת אתחול סיסמא נשלחה אל',
    'signOut': 'התנתק',
    'deleteAccount': 'מחיקת משתמש',
    'selectTheme': 'בחר ערכת נושא',
    'composeMsgToDevsTitle': 'מה תרצו לומר לנו?',
    'deleteAccountConfirmMsg': 'האם למחוק חשבון זה? פעולה זו אינה ניתנת לביטול',

    // =================================================================
    // ==================  Dialogs and Notifications ===================
    // =================================================================
    // ~~~ buttons labels and titles ~~~
    'confirm': 'אשר',
    'submit': 'המשך',
    'ok': 'אוקיי',
    'oops': 'אופס...',
    'delete': 'מחק',
    'cancel': 'ביטול',
    'leave': 'עזוב',
    'help': 'עזרה',
    'update': 'עדכן',
    'newGroupTitle': 'קבוצה חדשה',
    'pleaseSelect': 'אנא בחר',
    'tapToChange': 'לחץ לשינוי',
    'descriptionLabel': 'פירוט',
    'leaveGroupLabel': 'עזיבת קבוצה',
    'deleteGroupLabel': 'מחיקת קבוצה',
    'addMemberTitle': 'הוסף משתמש',
    'selectAssignedMembersTitle': 'בחר משתמשים',
    'newTask': 'מטלה חדשה',
    'scoreboard': 'לוח תוצאות',
    'futureTasks': 'משימות עתידיות',
    'week': 'שבוע',
    'month': 'חודש',
    'allTime': 'כל הזמנים',
    'dueTime': 'זמן יעד',
    'startTime': 'זמן התחלה',
    'notifyMembers': 'הודעה למשתמשים',
    'taskNotificationTitle': 'עדכון בנוגע למטלה',
    'assignedMembers': 'משתמשים מוקצים',
    'displayName': 'שם תצוגה',
    'deleteTask': 'מחק מטלה',
    'writeToNfc': 'כתוב ל NFC',
    'readyToWrite': 'מוכן לכתיבה',
    'holdPhoneOverNfc': 'החזק/י את המכשיר בקרבת תגית NFC',
    'today': 'היום',
    'thisWeek': 'השבוע',
    'thisMonth': 'החודש',
    'selectLanguageTitle': 'בחר/י שפה',

    // ~~~ Notification messages ~~~
    'notificationFromGroupTitle': 'עדכון מקבוצה',
    'sendNotificationTitle': 'שלח עדכון',
    'notificationMessageLable': 'תוכן ההודעה',
    'addedToGroupMsg': 'התווספת לקבוצה זו',
    'hasBeenAddedToThisGroup': 'התווסף/ה לקבוצה זו',
    'leaveGroupConfirmMsg': 'האם את/ה בטוח/ה שברצונך לעזוב את הקבוצה? \nלא ניתן לבטל פעולה זו',
    'deleteTaskConfirmMsg': 'האם את/ה בטוח/ה שברצונך למחוק מטלה זו? \nלא ניתן לבטל פעולה זו',
    'hi': 'אהלן',
    'oneTaskRemainingMsg': 'נותרה לך מטלה אחת בלבד בכל הקבוצות, קדימה לעבודה...',
    'allTasksRemainingMsg': '- זהו סך המטלות שנותרו לך בכל הקבוצות, קדימה לעבודה...',
    'noTasksRemainingMsg': 'מדהים! לא נותרו לך מטלות לביצוע :)',
    'notInAnyGroup': 'אינך רשום/ה באף קבוצה עדיין',
    'noDescription': 'לא הוזן פירוט',

    // ~~~ message bodies ~~~
    'deleteGroupConfirmMsg': 'האם את/ה בטוח/ה שברצונך למחוק קבוצה זו? \nלא ניתן לבטל פעולה זו',
    'selectTimespanPrompt': 'יש לבחור פרק זמן',
    'noCompletedTasks': 'אין מטלות שבוצעו',
    'msgSentToDevs': 'הודעתך נשלחה למפתחים, תודה :)',

    // ~~~ single group page ~~~
    'tasksAssignedToOthersTitle': 'מטלות שהוקצו לאחרים',
    'tasksAssignedToMeTitle': 'מטלות שהוקצו לי',
    'completedTasksTitle': 'מטלות שבוצעו',
    'noTasksAssignedToOthers': 'אין מטלות שהוקצו לאחרים בקבוצה זו',
    'noTasksAssignetToYou': 'אין מטלות שהוקצו לך בקבוצה זו',
    'noFutureTasks': 'אין מטלות עתידיות בקבוצה זו',

    // ~~~ remove member ~~~
    'removeMemberLable': 'מחק משתמש',
    'confirmRemove': 'האם את/ה בטוח שברצונך להסיר את',
    'fromTheGroup': 'מהקבוצה',

    // ~~~ fetching from DB and loading overlay messages ~~~
    'fetchingAssignedMembers': 'מחפש משתמשים מוקצים...',
    'fetchingTasksFromServer': 'מחפש מטלות...',
    'fetchingGroups': 'מחפש קבוצות...',
    'fetchingScoreboard': 'מחפש את לוח התוצאות...',
    'removingGroupMember': 'מסיר משתמש מהקבוצה...',
    'leavingGroup': 'יוצא מהקבוצה...',
    'deletingGroup': 'מוחק את הקבוצה...',
    'deletingAccount': 'מוחק חשבון זה...',
    'deletingTask': "מוחק מטלה...",
    'uploadingImage': "מעלה את התמונה...",

    // =================================================================
    // =======================  Error Messages  ========================
    // =================================================================
    'addMemberNotificationErrMsg': 'התווסף לקבוצה בהצלחה, אך לאור בעיה, הודעה לא נשלחה למשתמש',
    'taskValueIntegerValidationMsg': 'ערך של מטלה הוא רק מספר חיובי שלם',
    'emailAddressesAreCaseSensitive': '** כתובות דוא"ל רגישות לאותיות קטנות/גדולות **',
    'leaveGroupErrorPrefixMsg': 'שגיאה אירעה בעת יציאה מהקבוצה, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'uploadPhotoErrMsg': 'שגיאה אירעה בעת העלאת תמונה, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'sendMsgToDevsErr': 'שגיאה אירעה בעת שליחת ההודעה, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'taskNotUpdatedErrMsg': 'שגיאה אירעה בעת עדכון פרטי המטלה, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'getGroupInfoErrMsg': 'שגיאה אירעה בעת עדכון פרטי המטלה, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'parentGroupNotFoundErrMsg': 'הקבוצה המכילה את המטלה לא נמצאה',
    'removeMemberFromGroupErrMsg':
        'שגיאה אירעה בעת הסרת המשתמש מהקבוצה, המשתמש לא הוסר מהקבוצה. אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'editGroupInfoErrMsg': 'שגיאה אירעה בעת עדכון פרטי הקבוצה, הפרטים לא עודכנו, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'deleteGroupErrMsg': 'שגיאה אירעה בעת מחיקת הקבוצה, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'scoreBoardFetchErrMsg': 'שגיאה אירעה בעת הבאת לוח התוצאות, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'addMemberErrMsgPrefix': 'שגיאה אירעה בעת הוספת משתמש לקבוצה, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'openTaskDetailsPageErrMsg': 'שגיאה אירעה בעת פתיחת מסך פרטי המטלה, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'deleteTaskErrMsg': 'שגיאה אירעה בעת מחיקת המטלה, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'signOutErrMsg': 'שגיאה אירעה בעת התנתקות מהחשבון, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'atLeastOneMustBeSelected': 'יש לבחור לפחות משתמש אחד',
    'sendNotificationsErrMsgPrefix': 'שגיאה אירעה בעת שליחת הודעה למשתמשים. המשתמשים שלא קיבלו את ההודעה הם:\n',
    'invalidEmail': 'כתובת דוא"ל בלתי חוקית',
    'loginErrMsg': 'שגיאה אירעה בעת ההתחברות, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'registrationErrMsg': 'אירעה שגיאה בעת רישום משתמש חדש, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'loginWithGoogleErrMsg': 'אירעה שגיאה בעת התחברות באמצעות Google, אנא נסה/י שוב.\n\nהודעת שגיאה:\n',
    'fieldCannotBeEmpty': 'שדה זה הוא שדה חובה',

    // =================================================================
    // ==========================  Languages  ==========================
    // =================================================================
    'hebrew': 'עברית',
    'english': 'אנגלית',
    'russian': 'רוסית',
    'changeLanguage': 'שנה שפה',
  };

  //endregion

  Strings([String languageCode]) {
    setLanguage(languageCode);
  }

  //region string Getters
  // =================================================================
  // ===========================  General  ===========================
  // =================================================================
  String get email => _currentLanguageMap['email'] ?? _english['email'];

  String get password => _currentLanguageMap['password'] ?? _english['password'];

  String get resetPassword => _currentLanguageMap['resetPassword'] ?? _english['resetPassword'];

  String get name => _currentLanguageMap['name'] ?? _english['name'];

  String get loadingPage => _currentLanguageMap['loadingPage'] ?? _english['loadingPage'];

  String get invalidValue => _currentLanguageMap['invalidValue'] ?? _english['invalidValue'];

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

  String get loginWithGoogle => _currentLanguageMap['loginWithGoogle'] ?? _english['loginWithGoogle'];

  String get loggingInWithGoogle => _currentLanguageMap['loggingInWithGoogle'] ?? _english['loggingInWithGoogle'];

  String get loginButtonText => _currentLanguageMap['loginButtonText'] ?? _english['loginButtonText'];

  // =================================================================
  // =========================  Register page  =======================
  // =================================================================
  String get registerPageTitle => _currentLanguageMap['registerPageTitle'] ?? _english['registerPageTitle'];

  String get register => _currentLanguageMap['register'] ?? _english['register'];

  String get passwordLenValidationMsg =>
      _currentLanguageMap['passwordLenValidationMsg'] ?? _english['passwordLenValidationMsg'];

  String get registeringNewUserMsg => _currentLanguageMap['registeringNewUserMsg'] ?? _english['registeringNewUserMsg'];

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
  // ===========================  General  ===========================
  // =================================================================
  //_currentLanguageMap[''] ?? _english[''];
  // ~~ user ~~~
  String get userID => _currentLanguageMap['userID'] ?? _english[''];

  // ~~~ group ~~~
  String get groupInfo => _currentLanguageMap['groupInfo'] ?? _english['groupInfo'];

  String get groupId => _currentLanguageMap['groupId'] ?? _english['groupId'];

  String get groupTitleLable => _currentLanguageMap['groupTitleLable'] ?? _english['groupTitleLable'];

  String get groupManager => _currentLanguageMap['groupManager'] ?? _english['groupManager'];

  String get groupMembers => _currentLanguageMap['groupMembers'] ?? _english['groupMembers'];

  String get members => _currentLanguageMap['members'] ?? _english['members'];

  String get groupHasNoMembers => _currentLanguageMap['groupHasNoMembers'] ?? _english['groupHasNoMembers'];

  // ~~~ task ~~~
  String get titleLabel => _currentLanguageMap['titleLabel'] ?? _english['titleLabel'];

  String get tasks => _currentLanguageMap['tasks'] ?? _english['tasks'];

  String get valueLabel => _currentLanguageMap['valueLabel'] ?? _english['valueLabel'];

  String get timeNotSet => _currentLanguageMap['timeNotSet'] ?? _english['timeNotSet'];

  String get repeat => _currentLanguageMap['repeat'] ?? _english['repeat'];

  String get completedBy => _currentLanguageMap['completedBy'] ?? _english['completedBy'];

  String get completedOn => _currentLanguageMap['completedOn'] ?? _english['completedOn'];

  String get points => _currentLanguageMap['points'] ?? _english['points'];

  // ~~~ App Settings Page ~~~
  String get appSettings => _currentLanguageMap['appSettings'] ?? _english['appSettings'];

  String get changeTheme => _currentLanguageMap['changeTheme'] ?? _english['changeTheme'];

  String get messageDevs => _currentLanguageMap['messageDevs'] ?? _english['messageDevs'];

  String get resetPasswordSentTo => _currentLanguageMap['resetPasswordSentTo'] ?? _english['resetPasswordSentTo'];

  String get signOut => _currentLanguageMap['signOut'] ?? _english['signOut'];

  String get deleteAccount => _currentLanguageMap['deleteAccount'] ?? _english['deleteAccount'];

  String get selectTheme => _currentLanguageMap['selectTheme'] ?? _english['selectTheme'];

  String get composeMsgToDevsTitle => _currentLanguageMap['composeMsgToDevsTitle'] ?? _english['composeMsgToDevsTitle'];

  String get deleteAccountConfirmMsg =>
      _currentLanguageMap['deleteAccountConfirmMsg'] ?? _english['deleteAccountConfirmMsg'];

// =================================================================
  // ==================  Dialogs and Notifications ===================
  // =================================================================
  // ~~~ buttons labels and titles ~~~
  String get confirm => _currentLanguageMap['confirm'] ?? _english['confirm'];

  String get submit => _currentLanguageMap['submit'] ?? _english['submit'];

  String get ok => _currentLanguageMap['ok'] ?? _english['ok'];

  String get oops => _currentLanguageMap['oops'] ?? _english['oops'];

  String get delete => _currentLanguageMap['delete'] ?? _english['delete'];

  String get cancel => _currentLanguageMap['cancel'] ?? _english['cancel'];

  String get leave => _currentLanguageMap['leave'] ?? _english['leave'];

  String get help => _currentLanguageMap['help'] ?? _english['help'];

  String get update => _currentLanguageMap['update'] ?? _english['update'];

  String get newGroupTitle => _currentLanguageMap['newGroupTitle'] ?? _english['newGroupTitle'];

  String get pleaseSelect => _currentLanguageMap['pleaseSelect'] ?? _english['pleaseSelect'];

  String get tapToChange => _currentLanguageMap['tapToChange'] ?? _english['tapToChange'];

  String get descriptionLabel => _currentLanguageMap['descriptionLabel'] ?? _english['descriptionLabel'];

  String get leaveGroupLabel => _currentLanguageMap['leaveGroupLabel'] ?? _english['leaveGroupLabel'];

  String get deleteGroupLabel => _currentLanguageMap['deleteGroupLabel'] ?? _english['deleteGroupLabel'];

  String get addMemberTitle => _currentLanguageMap['addMemberTitle'] ?? _english['addMemberTitle'];

  String get selectAssignedMembersTitle =>
      _currentLanguageMap['selectAssignedMembersTitle'] ?? _english['selectAssignedMembersTitle'];

  String get newTask => _currentLanguageMap['newTask'] ?? _english['newTask'];

  String get scoreboard => _currentLanguageMap['scoreboard'] ?? _english['scoreboard'];

  String get futureTasks => _currentLanguageMap['futureTasks'] ?? _english['futureTasks'];

  String get week => _currentLanguageMap['week'] ?? _english['week'];

  String get month => _currentLanguageMap['month'] ?? _english['month'];

  String get allTime => _currentLanguageMap['allTime'] ?? _english['allTime'];

  String get dueTime => _currentLanguageMap['dueTime'] ?? _english['dueTime'];

  String get startTime => _currentLanguageMap['startTime'] ?? _english['startTime'];

  String get notifyMembers => _currentLanguageMap['notifyMembers'] ?? _english['notifyMembers'];

  String get taskNotificationTitle => _currentLanguageMap['taskNotificationTitle'] ?? _english['taskNotificationTitle'];

  String get assignedMembers => _currentLanguageMap['assignedMembers'] ?? _english['assignedMembers'];

  String get displayName => _currentLanguageMap['displayName'] ?? _english['displayName'];

  String get deleteTask => _currentLanguageMap['deleteTask'] ?? _english['deleteTask'];

  String get writeToNfc => _currentLanguageMap['writeToNfc'] ?? _english['writeToNfc'];

  String get readyToWrite => _currentLanguageMap['readyToWrite'] ?? _english['readyToWrite'];

  String get holdPhoneOverNfc => _currentLanguageMap['holdPhoneOverNfc'] ?? _english['holdPhoneOverNfc'];

  String get today => _currentLanguageMap['today'] ?? _english['today'];

  String get thisWeek => _currentLanguageMap['thisWeek'] ?? _english['thisWeek'];

  String get thisMonth => _currentLanguageMap['thisMonth'] ?? _english['thisMonth'];

  String get selectLanguageTitle => _currentLanguageMap['selectLanguageTitle'] ?? _english['selectLanguageTitle'];

  // ~~~ Notification messages ~~~
  String get notificationFromGroupTitle =>
      _currentLanguageMap['notificationFromGroupTitle'] ?? _english['notificationFromGroupTitle'];

  String get sendNotificationTitle => _currentLanguageMap['sendNotificationTitle'] ?? _english['sendNotificationTitle'];

  String get notificationMessageLable =>
      _currentLanguageMap['notificationMessageLable'] ?? _english['notificationMessageLable'];

  String get addedToGroupMsg => _currentLanguageMap['addedToGroupMsg'] ?? _english['addedToGroupMsg'];

  String get hasBeenAddedToThisGroup =>
      _currentLanguageMap['hasBeenAddedToThisGroup'] ?? _english['hasBeenAddedToThisGroup'];

  String get leaveGroupConfirmMsg => _currentLanguageMap['leaveGroupConfirmMsg'] ?? _english['leaveGroupConfirmMsg'];

  String get deleteTaskConfirmMsg => _currentLanguageMap['deleteTaskConfirmMsg'] ?? _english['deleteTaskConfirmMsg'];

  String get hi => _currentLanguageMap['hi'] ?? _english['hi'];

  String get oneTaskRemainingMsg => _currentLanguageMap['oneTaskRemainingMsg'] ?? _english['oneTaskRemainingMsg'];

  String get allTasksRemainingMsg => _currentLanguageMap['allTasksRemainingMsg'] ?? _english['allTasksRemainingMsg'];

  String get noTasksRemainingMsg => _currentLanguageMap['noTasksRemainingMsg'] ?? _english['noTasksRemainingMsg'];

  String get notInAnyGroup => _currentLanguageMap['notInAnyGroup'] ?? _english['notInAnyGroup'];

  String get noDescription => _currentLanguageMap['noDescription'] ?? _english['noDescription'];

  // ~~~ message bodies ~~~
  String get deleteGroupConfirmMsg => _currentLanguageMap['deleteGroupConfirmMsg'] ?? _english['deleteGroupConfirmMsg'];

  String get selectTimespanPrompt => _currentLanguageMap['selectTimespanPrompt'] ?? _english['selectTimespanPrompt'];

  String get noCompletedTasks => _currentLanguageMap['noCompletedTasks'] ?? _english['noCompletedTasks'];

  String get msgSentToDevs => _currentLanguageMap['msgSentToDevs'] ?? _english['msgSentToDevs'];

  // ~~~ single group page ~~~
  String get tasksAssignedToOthersTitle =>
      _currentLanguageMap['tasksAssignedToOthersTitle'] ?? _english['tasksAssignedToOthersTitle'];

  String get tasksAssignedToMeTitle =>
      _currentLanguageMap['tasksAssignedToMeTitle'] ?? _english['tasksAssignedToMeTitle'];

  String get completedTasksTitle => _currentLanguageMap['completedTasksTitle'] ?? _english['completedTasksTitle'];

  String get noTasksAssignedToOthers =>
      _currentLanguageMap['noTasksAssignedToOthers'] ?? _english['noTasksAssignedToOthers'];

  String get noTasksAssignetToYou => _currentLanguageMap['noTasksAssignetToYou'] ?? _english['noTasksAssignetToYou'];

  String get noFutureTasks => _currentLanguageMap['noFutureTasks'] ?? _english['noFutureTasks'];

  // ~~~ remove member ~~~
  String get removeMemberLable => _currentLanguageMap['removeMemberLable'] ?? _english['removeMemberLable'];

  String get confirmRemove => _currentLanguageMap['confirmRemove'] ?? _english['confirmRemove'];

  String get fromTheGroup => _currentLanguageMap['fromTheGroup'] ?? _english['fromTheGroup'];

  // ~~~ fetching from DB and loading overlay messages ~~~
  String get fetchingAssignedMembers =>
      _currentLanguageMap['fetchingAssignedMembers'] ?? _english['fetchingAssignedMembers'];

  String get fetchingTasksFromServer =>
      _currentLanguageMap['fetchingTasksFromServer'] ?? _english['fetchingTasksFromServer'];

  String get fetchingGroups => _currentLanguageMap['fetchingGroups'] ?? _english['fetchingGroups'];

  String get fetchingScoreboard => _currentLanguageMap['fetchingScoreboard'] ?? _english['fetchingScoreboard'];

  String get removingGroupMember => _currentLanguageMap['removingGroupMember'] ?? _english['removingGroupMember'];

  String get leavingGroup => _currentLanguageMap['leavingGroup'] ?? _english['leavingGroup'];

  String get deletingGroup => _currentLanguageMap['deletingGroup'] ?? _english['deletingGroup'];

  String get deletingAccount => _currentLanguageMap['deletingAccount'] ?? _english['deletingAccount'];

  String get deletingTask => _currentLanguageMap['deletingTask'] ?? _english['deletingTask'];

  String get uploadingImage => _currentLanguageMap['uploadingImage'] ?? _english['uploadingImage'];

  // =================================================================
  // =======================  Error Messages  ========================
  // =================================================================
  String get addMemberNotificationErrMsg =>
      _currentLanguageMap['addMemberNotificationErrMsg'] ?? _english['addMemberNotificationErrMsg'];

  String get taskValueIntegerValidationMsg =>
      _currentLanguageMap['taskValueIntegerValidationMsg'] ?? _english['taskValueIntegerValidationMsg'];

  String get emailAddressesAreCaseSensitive =>
      _currentLanguageMap['emailAddressesAreCaseSensitive'] ?? _english['emailAddressesAreCaseSensitive'];

  String get leaveGroupErrorPrefixMsg =>
      _currentLanguageMap['leaveGroupErrorPrefixMsg'] ?? _english['leaveGroupErrorPrefixMsg'];

  String get uploadPhotoErrMsg => _currentLanguageMap['uploadPhotoErrMsg'] ?? _english['uploadPhotoErrMsg'];

  String get sendMsgToDevsErr => _currentLanguageMap['sendMsgToDevsErr'] ?? _english['sendMsgToDevsErr'];

  String get taskNotUpdatedErrMsg => _currentLanguageMap['taskNotUpdatedErrMsg'] ?? _english['taskNotUpdatedErrMsg'];

  String get getGroupInfoErrMsg => _currentLanguageMap['getGroupInfoErrMsg'] ?? _english['getGroupInfoErrMsg'];

  String get parentGroupNotFoundErrMsg =>
      _currentLanguageMap['parentGroupNotFoundErrMsg'] ?? _english['parentGroupNotFoundErrMsg'];

  String get removeMemberFromGroupErrMsg =>
      _currentLanguageMap['removeMemberFromGroupErrMsg'] ?? _english['removeMemberFromGroupErrMsg'];

  String get editGroupInfoErrMsg => _currentLanguageMap['editGroupInfoErrMsg'] ?? _english['editGroupInfoErrMsg'];

  String get deleteGroupErrMsg => _currentLanguageMap['deleteGroupErrMsg'] ?? _english['deleteGroupErrMsg'];

  String get scoreBoardFetchErrMsg => _currentLanguageMap['scoreBoardFetchErrMsg'] ?? _english['scoreBoardFetchErrMsg'];

  String get addMemberErrMsgPrefix => _currentLanguageMap['addMemberErrMsgPrefix'] ?? _english['addMemberErrMsgPrefix'];

  String get openTaskDetailsPageErrMsg =>
      _currentLanguageMap['openTaskDetailsPageErrMsg'] ?? _english['openTaskDetailsPageErrMsg'];

  String get deleteTaskErrMsg => _currentLanguageMap['deleteTaskErrMsg'] ?? _english['deleteTaskErrMsg'];

  String get signOutErrMsg => _currentLanguageMap['signOutErrMsg'] ?? _english['signOutErrMsg'];

  String get atLeastOneMustBeSelected =>
      _currentLanguageMap['atLeastOneMustBeSelected'] ?? _english['atLeastOneMustBeSelected'];

  String get sendNotificationsErrMsgPrefix =>
      _currentLanguageMap['sendNotificationsErrMsgPrefix'] ?? _english['sendNotificationsErrMsgPrefix'];

  String get invalidEmail => _currentLanguageMap['invalidEmail'] ?? _english['invalidEmail'];

  String get loginErrMsg => _currentLanguageMap['loginErrMsg'] ?? _english['loginErrMsg'];

  String get registrationErrMsg => _currentLanguageMap['registrationErrMsg'] ?? _english['registrationErrMsg'];

  String get loginWithGoogleErrMsg => _currentLanguageMap['loginWithGoogleErrMsg'] ?? _english['loginWithGoogleErrMsg'];

  String get loadingPhotoErrMsgPrefix =>
      _currentLanguageMap['loadingPhotoErrMsgPrefix'] ?? _english['loadingPhotoErrMsgPrefix'];

  String get fieldCannotBeEmpty => _currentLanguageMap['fieldCannotBeEmpty'] ?? _english['fieldCannotBeEmpty'];

  // =================================================================
  // ==========================  Languages  ==========================
  // =================================================================
  String get hebrew => _currentLanguageMap['hebrew'] ?? _english['hebrew'];

  String get english => _currentLanguageMap['english'] ?? _english['english'];

  String get russian => _currentLanguageMap['russian'] ?? _english['russian'];

  String get changeLanguage => _currentLanguageMap['changeLanguage'] ?? _english['changeLanguage'];

  //endregion

  List<Locale> getSupportedLanguages() {
    return [
      Locale('en', 'US'),
      Locale('he', 'IL'),
//      Locale('ru', 'RU'),
    ];
  }

  static String localeToLanguageString(Locale locale) {
    switch (locale.languageCode) {
      case 'he':
        return App.instance.strings.hebrew;
      case 'en':
        return App.instance.strings.english;
      case 'ru':
        return App.instance.strings.russian;
      default:
        return locale.languageCode;
    }
  }

  static Locale localeParse(String localeStr) {
    switch (localeStr) {
      case 'he_IL':
        return Locale('he', 'IL');
      case 'ru_RU':
        return Locale('ru', 'RU');
      default:
        return Locale('en', 'US');
    }
  }

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
