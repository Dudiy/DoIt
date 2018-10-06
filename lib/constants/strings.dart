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
    'invalidValue': 'Invalid value',
    'gotIt': 'Got it',
    'loading': 'Loading...',
    'version': 'Version',

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
    'taskIsInFuture': 'Task start date is in the future',

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
    'appSettings': 'Application settings',
    'changeTheme': 'Change theme',
    'messageDevs': 'Message the developers',
    'resetPasswordSentTo': 'Reset password email has been sent to',
    'signOut': 'Sign out',
    'deleteAccount': 'Delete account',
    'selectTheme': 'Select Theme',
    'composeMsgToDevsTitle': 'What would you like to tell us?',
    'deleteAccountConfirmMsg': 'Are you sure you want to delete this account? this cannot be undone',

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
    'addMemberTitle': 'Add member',
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
    'clickToCreateGroup': 'Click the "+" to\ncreate a new group',

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
    'deletingTask': 'Deleting task...',
    'uploadingImage': 'Uploading image...',
    'loadingGroupPage': 'Loading group page...',
    'loadingTaskDetailsPage': 'Loading task details page...',

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
    'parentGroupNotFoundErrMsg': 'Group containing the task was not found',
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
    'loginWithGoogleErrMsg': 'Error while trying to log in with google, please try again.\n\nException details:\n',
    'fieldCannotBeEmpty': 'This field cannot be empty',

    // =================================================================
    // ==========================  Languages  ==========================
    // =================================================================
    'changeLanguage': 'Change language',

    // =================================================================
    // ==========================  Help Pages ==========================
    // =================================================================
    'singleGroupDetailsHelpTitle': 'Single group details page',
    'singleGroupDetailsHelpIntro': 'This page is where a user can see all the tasks of the selected group.\n\n'
        'The group picture can be changed by any group member by clicking on the group image at the top of the page\n\n'
        'Every task in the group is shown on a task card, clicking on the card will show the task details page\n'
        'This is where the group manager can also update the task\n\n'
        'The group tasks are seperated into the following sections:\n',
    'singleGroupDetailsHelpTasksAssignedToMeSubtitle': '- Tasks assigned to me (the active user):',
    'singleGroupDetailsHelpTasksAssignedToMeBody': 'These tasks are the tasks that the user can complete.\n '
        'When a task is completed it is moved to the completed tasks section.\n'
        'If a task is a recurring task then after it is completed a new task with the updated start\\end date will be generated.\n'
        '* If the new date of a recurring task is after the current time it will show up in the future tasks section *\n',
    'singleGroupDetailsHelpTasksAssignedToOthersSubtitle': '- Tasks assigned to other users:',
    'singleGroupDetailsHelpTasksAssignedToOthersBody':
        'These tasks are assigned to other members of the group but not the active user.\n '
        'These tasks cannot be completed by the active user.\n',
    'singleGroupDetailsHelpFutureTasksSubtitle': '- Future tasks (visible to group manager only):',
    'singleGroupDetailsHelpFutureTasksBody': 'These tasks have a starting date that is later than the current time.\n ',
    'singleGroupDetailsHelpCompletedTasksBody': 'To see completed tasks a time span must be selected.\n '
        'Only the group manager or the member who completed a task can "uncomplete" a task\n',
    'taskDetailsHelpTitle': 'Task details page',
    'taskDetailsHelpIntro': 'This page is where all the details of a selected task are.\n\n'
        'Only the group manager can update the details of a task.\n\n'
        'Task fields:\n',
    'taskDetailsHelpValueBody': 'The amount of points a member will get for completing this task.\n',
    'taskDetailsHelpRepeatBody': 'When should the task reappear after completion.\n',
    'taskDetailsHelpStartTimeBody':
        'The task will be visible to the group members only after the current time is after this value.\n ',
    'taskDetailsHelpDueTimeBody':
        'The due time of the task, after this time the task background will be colored red.\n',
    'taskDetailsHelpAsssignedMembersBody':
        'The group members who are assigned to this task - only they are able to complete it.\n'
        'By default tasks are assigned to all members of the group.\n',
  };

  final Map<String, String> _hebrew = {
    'email': 'דוא\"ל',
    'password': 'סיסמא',
    'resetPassword': 'איפוס סיסמא',
    'name': 'שם משתמש',
    'invalidValue': 'ערך לא תקין',
    'gotIt': 'הבנתי',
    'loading': 'טוען...',
    'version': 'גרסה',
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
    'taskIsInFuture': 'זמן ההתחלה של המטלה הוא בעתיד',

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
    'clickToCreateGroup': 'לחץ על ה"+" בכדי\n ליצור קבוצה חדשה',

    // ~~~ message bodies ~~~
    'deleteGroupConfirmMsg': 'האם את/ה בטוח/ה שברצונך למחוק קבוצה זו? \nלא ניתן לבטל פעולה זו',
    'selectTimespanPrompt': 'יש לבחור פרק זמן',
    'noCompletedTasks': 'אין מטלות שבוצעו',
    'msgSentToDevs': 'הודעתך נשלחה למפתחים, תודה :)',

    // ~~~ single group page ~~~
    'tasksAssignedToOthersTitle': 'מטלות של אחרים',
    'tasksAssignedToMeTitle': 'מטלות שלי',
    'completedTasksTitle': 'מטלות שבוצעו',
    'noTasksAssignedToOthers': 'אין לאחרים מטלות בקבוצה זו',
    'noTasksAssignetToYou': 'אין לך מטלות בקבוצה זו',
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
    'loadingGroupPage': 'טוען את עמוד הקבוצה...',
    'loadingTaskDetailsPage': 'טוען את פרטי המטלה...',

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
    'changeLanguage': 'שנה שפה',

    // =================================================================
    // ==========================  Help Pages ==========================
    // =================================================================
    'singleGroupDetailsHelpTitle': 'עמוד הקבוצה',
    'singleGroupDetailsHelpIntro': 'בעמוד זה ניתן לראות את כל המטלות של הקבוצה.\n\n'
        'את תמונה הקבוצה כל חבר בקבוצה יכול להחליף ע"י לחיצה על תמונת הקבוצה בחלקו העליון של העמוד\n\n'
        'כל מטלה בקבוצה מוצגת בתוך מסגרת, לחיצה בתוך תחומי המסגרת תציג פרטי המטלה בהרחבה\n'
        'עמוד זה הוא גם העמוד בו מנהל הקבוצה יכול לעדכן את פרטי המטלה\n\n'
        'מטלות הקבוצה מחולקות לתתי קבוצות באופן הבא:\n',
    'singleGroupDetailsHelpTasksAssignedToMeSubtitle': '- משימות שלי:',
    'singleGroupDetailsHelpTasksAssignedToMeBody': 'אלו המטלות שהמשתמש הנוכחי יכול לבצע.\n '
        'כאשר המשתמש מסמן מטלה כ"בוצעה" כרטיס המטלה עובר אל "מטלות שבוצעו".\n'
        'אם המטלה היא מטלה חוזרת אז לאחר ביצועה, מטלה חדשה תיווצר עם זמני ההתחלה/יעד המתאימים.\n'
        '* שימו לב! אם זמן ההתחלה החדש של המטלה הוא מאוחר מהזמן הנוכחי, המטלה תופיע תחת "מטלות עתידיות" *\n',
    'singleGroupDetailsHelpTasksAssignedToOthersSubtitle': '- מטלות של אחרים:',
    'singleGroupDetailsHelpTasksAssignedToOthersBody':
        'מטלות אלה הן מטלות אשר נמצאות בקבוצה אך לא מוקצות למשתמש הנוכחי.\n '
        'המשתמש הנוכחי לא יכול לבצע המטלות הללו.\n',
    'singleGroupDetailsHelpFutureTasksSubtitle': '- מטלות עתידיות (רק מנהל הקבוצה יכול לראותן):',
    'singleGroupDetailsHelpFutureTasksBody': 'מטלות אלה הן מטלות שזמן ההתחלה שלהן הוא מאוחר מהזמן הנוכחי.\n ',
    'singleGroupDetailsHelpCompletedTasksBody': 'בכדי לראות מטלות שבוצעו יש לבחור את פרק הזמן הרצוי.\n '
        'רק מנהל הקבוצה או המשתמש אשר ביצע את המטלה יכול לבטל את סימון ה"בוצע" של המטלה\n',
    'taskDetailsHelpTitle': 'עמוד פרטי מטלה',
    'taskDetailsHelpIntro': 'בעמוד זה ניתן למצוא את כל פרטי המטלה שנבחרה.\n\n'
        'רק מנהל הקבוצה יכול לשנו את פקטי המטלה.\n\n'
        'שדות מטלה:\n',
    'taskDetailsHelpValueBody': 'הניקוד אותו ירוויח משתמש אשר יבצע את המטלה.\n',
    'taskDetailsHelpRepeatBody': 'מתי יש להציד שוב את המטלה לאחר שהיא תסומן כ"בוצעה".\n',
    'taskDetailsHelpStartTimeBody': 'המטלה תוצג לכלל משתתפי הקבוצה רק לאחר שהזמן הנוכחי יהיה מאוחר מערך זה.\n ',
    'taskDetailsHelpDueTimeBody': 'זמן היעד לביצוע המטלה, לאחר זמן זה רקע המטלה יהפוך לאדום.\n',
    'taskDetailsHelpAsssignedMembersBody': 'משתתפי הקבוצה המוקצים למטלה זו - רק הם יכולים לבצע אותה.\n'
        'כאשר מטלה נוצרת היא תחילה מוקצת לכל משתתפי הקבוצה.\n',
  };

  final Map<String, String> _russian = {
    // =================================================================
    // ===========================  General  ===========================
    // =================================================================
    'email': 'Эл. адрес',
    // 'Email'
    'password': 'пароль',
    // 'Password'
    'resetPassword': 'Сброс пароля',
    // 'Reset password'
    'name': 'имя',
    // 'Name'
    'invalidValue': 'Неверное значение',
    // 'Invalid value'
    'gotIt': 'понял',
    // 'Got it'
    'loading': 'погрузка...',
    // 'Loading...'
    'version': 'версия',
    //'Version'
    // =================================================================
    // ==========================  Login page  =========================
    // =================================================================
    'newUserButton': 'новый пользователь?  завести аккаунт',
    //'New user?  Create an account'
    'sendingResetPasswordMsg': 'отправка пароля для сброса пароля...',
    // 'sending reset password email...',
    'resetPasswordSentMsg': 'пароль для сброса пароля отправлен',
    //'Reset password email has been sent to',
    'noRegisteredUserWithEmailMsg': 'Нет зарегистрированного пользователя с указанным адресом электронной почты',
    //'There is no registered user with the given Email address',
    'loggingIn': 'Вход в систему...',
    //'Logging in...',
    'loginWithGoogle': 'Войти в Google',
    //'Log in with google',
    'loggingInWithGoogle': 'Вход в систему с помощью Google...',
    //'Logging in with google...',
    'loginButtonText': 'Авторизоваться',
    //'Login'

    // =================================================================
    // ========================  Register page  ========================
    // =================================================================
    'registerPageTitle': 'Постановка на учет',
    //'Registration',
    'register': 'регистр',
    //'Register',
    'passwordLenValidationMsg': 'пароль должен содержать как минимум 6 символов',
    //'Password must be at least 6 characters long',
    'registeringNewUserMsg': 'Регистрация нового пользователя...',
    //'Registering new user...',

    // =================================================================
    // =======================  Recurring Policies  ====================
    // =================================================================
    'recurringPolicyNone': 'Никто',
    //'None',
    'recurringPolicyDaily': 'Ежедневно',
    //'Daily',
    'recurringPolicyWeekly': 'Еженедельно',
    //'Weekly',
    'recurringPolicyMonthly': 'Ежемесячно',
    //'Monthly',
    'recurringPolicyYearly': 'Каждый год',
    //'Yearly',

    // =================================================================
    // =====================  Task Completed results  ==================
    // =================================================================
    'taskCompletedMsg': 'Вы выполнили задачу',
    //'You have completed the task:',
    'loginToCompleteTaskMsg': 'Сначала выполните вход, чтобы выполнить задачу.',
    //'Please log in first in order to complete the task',
    'userCompletedNotInDbErrMsg': 'Пожалуйста, подключитесь к приложению, чтобы выполнить задачу',
    //'Please reconnect to the application in order to complete the task',
    'taskNotFoundErrMsg': 'Задача, связанная с этим тегом, больше не существует',
    //'The task associated with this tag does not exist anymore',
    'userNotAssignedToTaskErrMsg': 'Вы не назначены для задачи, связанной с этим тегом',
    //'You are not assigned to the task associated with this tag',
    'taskDoesNotExistsErrMsg': 'Задача, связанная с этим тегом, больше не существует',
    //'The task associated with this tag does not exist anymore',
    'startTimeAfterEndTimeErrMsg': 'Время начала не может быть позже конечного времени',
    //'Start time cannot be later than end time',
    'addTaskFailedErrMsg': 'Не удалось добавить задачу',
    //'Failed to add task',
    'unknownCompleteTaskStatusErrMsg': 'Неизвестный статус задачи',
    //'Unknown complete task status',
    'taskIsInFuture': 'Дата начала работы в будущем',
    //'Task start date is in the future',

    // =================================================================
    // ===========================  General  ===========================
    // =================================================================
    // ~~ user ~~~
    'userID': 'Идентификатор пользователя',
    //'User ID',
    // ~~~ group ~~~
    'groupInfo': 'Информация о группе',
    //'Group info',
    'groupId': 'Идентификатор группы',
    //'Group ID',
    'groupTitleLable': 'Название группы',
    //'Group title',
    'groupManager': 'Менеджер группы',
    //'Group manager',
    'groupMembers': 'Участники группы',
    //'Group Members',
    'members': 'члены',
    //'Members',
    'groupHasNoMembers': 'В группе нет участников ...',
    //'The group has no members...',
    // ~~~ task ~~~
    'titleLabel': 'Заглавие',
    //'Title',
    'tasks': 'Задания',
    //'Tasks',
    'valueLabel': 'Стоимость',
    // 'Value',
    'timeNotSet': 'Время не установлено',
    //'Time not set',
    'repeat': 'Повторение',
    // 'Repeat',
    'completedBy': 'Завершено',
    //'Completed by',
    'completedOn': 'Завершено',
    //'Completed on',
    'points': 'очков',
    //'points',
    // ~~~ App Settings Page ~~~
    'appSettings': 'Настройки приложения',
    //'Application settings',
    'changeTheme': 'Менять тему',
    //'Change theme',
    'messageDevs': 'Послание разработчиков',
    //'Message the developers',
    'resetPasswordSentTo': 'Сброс пароля отправлено по электронной почте',
    //'Reset password email has been sent to',
    'signOut': 'Выход',
    //'Sign out',
    'deleteAccount': 'Удалить аккаунт',
    //'Delete account',
    'selectTheme': 'Выберите тему',
    //'Select Theme',
    'composeMsgToDevsTitle': 'Что бы вы хотели нам рассказать?',
    //'What would you like to tell us?',
    'deleteAccountConfirmMsg': 'Вы уверены, что хотите удалить эту учетную запись? Это не может быть отменено',
    //'are you sure you want to delete this account? this cannot be undone',

    // =================================================================
    // ==================  Dialogs and Notifications ===================
    // =================================================================
    // ~~~ buttons labels and titles ~~~
    'confirm': 'подтвердить',
    //'Confirm',
    'submit': 'Отправить',
    //'Submit',
    'ok': 'ОК',
    //'Ok',
    'oops': 'ой...',
    //'Oops...',
    'delete': 'Удалить',
    //'Delete',
    'cancel': 'Отмена',
    //'Cancel',
    'leave': 'Оставлять',
    //'Leave',
    'help': 'Помогите',
    //'Help',
    'update': 'Обновить',
    // 'Update',
    'newGroupTitle': 'Новая группа',
    //'New Group',
    'pleaseSelect': 'пожалуйста выберите',
    //'please select',
    'tapToChange': 'коснуться, чтобы изменить',
    //'tap to change',
    'descriptionLabel': 'Описание',
    // 'Description',
    'leaveGroupLabel': 'Покинуть группу',
    //'Leave group',
    'deleteGroupLabel': 'Удалить группу',
    //'Delete group',
    'addMemberTitle': 'Добавить участников',
    //'Add member',
    'selectAssignedMembersTitle': 'Выберите назначенных участников',
    //'Select assigned members',
    'newTask': 'Новое задание',
    //'New task',
    'scoreboard': 'табло',
    // 'scoreboard',
    'futureTasks': 'Будущие задачи',
    //'Future tasks',
    'week': 'неделю',
    // 'week',
    'month': 'месяц',
    // 'month',
    'allTime': 'все время',
    //'all time',
    'dueTime': 'Время выполнения',
    //'Due time',
    'startTime': 'Время начала',
    //'Start time',
    'notifyMembers': 'уведомлять участников',
    //'notify members',
    'taskNotificationTitle': 'Уведомление из задачи',
    //'Notification from task',
    'assignedMembers': 'Назначенные члены',
    //'Assigned members',
    'displayName': 'Отображаемое имя',
    //'Display name',
    'deleteTask': 'Удалить задачу',
    //'Delete task',
    'writeToNfc': 'Написать в NFC',
    //'Write to NFC',
    'readyToWrite': 'Готовы написать',
    //'Ready to write',
    'holdPhoneOverNfc': 'Держите телефон над тегом NFC',
    //'Hold phone over NFC tag',
    'today': 'cегодня',
    // 'today',
    'thisWeek': 'на этой неделе',
    //'this week',
    'thisMonth': 'этот месяц',
    //'this month',
    'selectLanguageTitle': 'Выберите язык',
    //'Select Language',
    // ~~~ Notification messages ~~~
    'notificationFromGroupTitle': 'Уведомление от группы',
    //'Notification from group',
    'sendNotificationTitle': 'Отправить уведомление',
    //'Send notification',
    'notificationMessageLable': 'уведомление',
    //'notification message',
    'addedToGroupMsg': 'Вы были добавлены в эту группу',
    //'You have been added to this group',
    'hasBeenAddedToThisGroup': 'был добавлен в эту группу',
    //'has been added to this group',
    'leaveGroupConfirmMsg': 'Вы уверены, что хотите покинуть эту группу? \nЭто не может быть отменено',
    //'Are you sure you would like to leave this group? \nThis cannot be undone',
    'deleteTaskConfirmMsg': 'Вы уверены, что хотите удалить эту задачу? \nЭто не может быть отменено',
    //'Are you sure you would like to delete this task? \nThis cannot be undone',
    'hi': 'Здравствуй',
    //'Hi',
    'oneTaskRemainingMsg': 'У вас остается только одна задача, оставшаяся во всех группах, позволяющая работать ...',
    //'You only have one task remaining in all groups, lets get to work...',
    'allTasksRemainingMsg': '- вот все задачи, которые у вас остались во всех группах, позволяют работать...',
    // '- thats all the tasks you have remaining in all groups, lets get to work...',
    'noTasksRemainingMsg': 'Потрясающие! у вас нет задач :)',
    //'Awsome! you have no tasks to do :)',
    'notInAnyGroup': 'Вы еще не в группе',
    //'You are not in any group yet',
    'noDescription': 'Введенное описание не указано',
    //'No description entered',
    'clickToCreateGroup': 'Нажмите «+», чтобы\nсоздать новую группу.',
    //'Click the "+" to\ncreate a new group',

    // ~~~ message bodies ~~~
    'deleteGroupConfirmMsg': 'Вы уверены, что хотите удалить эту группу? \nЭто не может быть отменено',
    //'Are you sure you would like to delete this group? \nThis cannot be undone',
    'selectTimespanPrompt': 'Выберите промежуток времени',
    //'Please select a timespan',
    'noCompletedTasks': 'Нет завершенных задач',
    //'No completed tasks',
    'msgSentToDevs': 'Ваше сообщение отправлено разработчикам. Спасибо :)',
    //'Your message has been sent to the developers. Thank you :)',

    // ~~~ single group page ~~~
    'tasksAssignedToOthersTitle': 'Задачи, назначенные другим',
    //'Tasks assigned to others',
    'tasksAssignedToMeTitle': 'Задачи, назначенные мне',
    //'Tasks assigned to me',
    'completedTasksTitle': 'Завершенные задачи',
    //'Completed tasks',
    'noTasksAssignedToOthers': 'В этой группе нет заданий, назначенных другим',
    //'There are no tasks assigned to others in this group',
    'noTasksAssignetToYou': 'В этой группе нет заданий, назначенных вам',
    //'There are no tasks assigned to you in this group',
    'noFutureTasks': 'В этой группе нет будущих задач',
    //'There are no future tasks in this group',

    // ~~~ remove member ~~~
    'removeMemberLable': 'Удалить элемент',
    //'Remove member',
    'confirmRemove': 'Вы уверены, что хотите удалить',
    //'Are you sure you would like to remove',
    'fromTheGroup': 'из группы',
    //'from the group',

    // ~~~ fetching from DB and loading overlay messages ~~~
    'fetchingAssignedMembers': 'Получение назначенных участников...',
    //'Fetching assigned members...',
    'fetchingTasksFromServer': 'Получение заданий...',
    //'Fetching tasks...',
    'fetchingGroups': 'Получение групп...',
    //'Fetching groups...',
    'fetchingScoreboard': 'Захватывающий табло...',
    //'Fetching score board...',
    'removingGroupMember': 'Удаление члена группы...',
    //'Removing group member...',
    'leavingGroup': 'Уходящая группа...',
    //'Leaving group...',
    'deletingGroup': 'Удаление группы...',
    //'Deleting group...',
    'deletingAccount': 'Удаление этой учетной записи...',
    //'Deleting this account...',
    'deletingTask': 'Удаление задачи...',
    //"Deleting task...",
    'uploadingImage': 'Загрузка изображения...',
    //"Uploading image...",
    'loadingGroupPage': 'Загрузка группы групп ...',
    //'Loading group page...',
    'loadingTaskDetailsPage': 'Загрузка страницы сведений о задаче ...',
    //'Loading task details page...',

    // =================================================================
    // =======================  Error Messages  ========================
    // =================================================================
    'addMemberNotificationErrMsg': 'был добавлен в группу, но из-за ошибки подключения уведомление не было отправлено',
    //'has been added to the group but due to a connection error, a notification was not sent',
    'taskValueIntegerValidationMsg': 'Значение задачи должно быть положительным целым числом',
    //'Task value must be a positive integer',
    'emailAddressesAreCaseSensitive': '** Адреса электронной почты чувствительны к регистру **',
    // '** Email addresses are case sensitive **',
    'leaveGroupErrorPrefixMsg': 'Ошибка при попытке покинуть группу, повторите попытку.\n\nСведения об исключении\n',
    //'Error while trying to leave group, please try again.\n\nException details:\n',
    'uploadPhotoErrMsg': 'Ошибка при загрузке фото, повторите попытку.\n\nСведения об исключении\n',
    //'Error while uploading photo, please try again.\n\nException details:\n',
    'sendMsgToDevsErr': 'Ошибка при отправке сообщения, повторите попытку.\n\nСведения об исключении\n',
    //'Error while sending message, please try again.\n\nException details:\n',
    'taskNotUpdatedErrMsg':
        'Не удалось обновить задачу из-за следующей ошибки, повторите попытку.\n\nСведения об исключении\n',
    //'Could not update task due to the following error, please try again.\n\nException details:\n',
    'getGroupInfoErrMsg':
        'Ошибка при попытке получить информацию о группе, повторите попытку.\n\nСведения об исключении\n',
    //'Error while trying to get group info, please try again.\n\nException details:\n',
    'parentGroupNotFoundErrMsg': 'Группа, содержащая задание, не была найдена',
    //'Group containing the task was not found',
    'removeMemberFromGroupErrMsg':
        'Ошибка при удалении члена из группы, элемент не удален, повторите попытку.\n\nСведения об исключении\n',
    // 'Error while removing member from group, the member has not been removed, please try again.\n\nException details:\n',
    'editGroupInfoErrMsg':
        'Ошибка при обновлении информации о группе, информация о группе не будет обновлена, повторите попытку.\n\nСведения об исключении\n',
    //'Error while updating group info, the group info will not be updated, please try again.\n\nException details:\n',
    'deleteGroupErrMsg': 'Ошибка при удалении группы, повторите попытку.\n\nСведения об исключении\n',
    //'Error while deleting group, please try again.\n\nException details:\n',
    'scoreBoardFetchErrMsg':
        'Ошибка при попытке получить групповой табло, попробуйте еще раз.\n\nСведения об исключении\n',
    // 'Error while trying to get the group scoreboard, please try again.\n\nException details:\n',
    'addMemberErrMsgPrefix':
        'Ошибка при попытке добавить нового участника, повторите попытку.\n\nСведения об исключении\n',
    //'Error while trying to add new member, please try again.\n\nException details:\n',
    'openTaskDetailsPageErrMsg':
        '«Ошибка при попытке открыть страницу сведений о задании, повторите попытку.\n\nСведения об исключении\n',
    // 'Error while trying to open task details page, please try again.\n\nException details:\n',
    'deleteTaskErrMsg': 'Ошибка при попытке удалить задачу, повторите попытку.\n\nСведения об исключении\n',
    //'Error while trying to delete task, please try again.\n\nException details:\n',
    'signOutErrMsg': 'Ошибка при выходе из системы, повторите попытку.\n\nСведения об исключении\n',
    //'Error while signing out, please try again.\n\nException details:\n',
    'atLeastOneMustBeSelected': 'Необходимо выбрать хотя бы одного пользователя',
    //'At least one user must be selected',
    'sendNotificationsErrMsgPrefix':
        'Ошибка при отправке уведомлений, следующие пользователи не получили уведомление:\n',
    //'''Error while sending notifications, the following users did not get the notification:\n',
    'invalidEmail': 'Неверный адрес электронной почты',
    //'Invalid email address',
    'loginErrMsg': 'Ошибка при попытке войти в систему, повторите попытку.\n\nСведения об исключении\n',
    //'Error while trying to log in, please try again.\n\nException details:\n',
    'registrationErrMsg':
        'Ошибка при попытке зарегистрировать нового пользователя, повторите попытку.\n\nСведения об исключении\n',
    //'Error while trying to register a new user, please try again.\n\nException details:\n',
    'loginWithGoogleErrMsg':
        'Ошибка при попытке войти в систему с помощью Google, повторите попытку.\n\nСведения об исключении\n',
    //'Error while trying to log in with google, please try again.\n\nException details:\n',
    'fieldCannotBeEmpty': 'Это поле не может быть пустым',
    //'This field cannot be empty',

    // =================================================================
    // ==========================  Languages  ==========================
    // =================================================================
    'changeLanguage': 'изменение языка',
    //'Change language',

    // =================================================================
    // ==========================  Help Pages ==========================
    // =================================================================
    'singleGroupDetailsHelpTitle': 'Страница отдельных групп',
    //'Single group details page',
    'singleGroupDetailsHelpIntro':
        'На этой странице пользователь может видеть все задачи выбранной группы.' //'This page is where a user can see all the tasks of the selected group.\n\n'
        'Групповое изображение может быть изменено любым членом группы, нажав на групповое изображение в верхней части страницы\n\n' //'The group picture can be changed by any group member by clicking on the group image at the top of the page\n\n'
        'Каждая задача в группе отображается на карте задач, при нажатии на карту отображается страница сведений о задаче\n' //'Every task in the group is shown on a task card, clicking on the card will show the task details page\n'
        'Здесь менеджер группы может также обновить задачу\n\n' //'This is where the group manager can also update the task\n\n'
        'Групповые задачи разделяются на следующие разделы:\n',
    //'The group tasks are seperated into the following sections:\n',
    'singleGroupDetailsHelpTasksAssignedToMeSubtitle': 'Заданные мне задачи (активный пользователь)',
    //'- Tasks assigned to me (the active user):',
    'singleGroupDetailsHelpTasksAssignedToMeBody':
        'Эти задачи - это задачи, которые пользователь может выполнить.\n' //'These tasks are the tasks that the user can complete.\n '
        'Когда задача завершена, она перемещается в раздел завершенных задач.\n' //'When a task is completed it is moved to the completed tasks section.\n'
        'Если задача является повторяющейся задачей, то после ее завершения будет создана новая задача с обновленной датой начала\\окончания.\n' //'If a task is a recurring task then after it is completed a new task with the updated start\\end date will be generated.\n'
        '* Если новая дата повторяющейся задачи после текущего времени будет отображаться в разделе будущих задач *\n',
    //'* If the new date of a recurring task is after the current time it will show up in the future tasks section *\n',
    'singleGroupDetailsHelpTasksAssignedToOthersSubtitle': '- Задачи, назначенные другим пользователям:',
    //'- Tasks assigned to other users:',
    'singleGroupDetailsHelpTasksAssignedToOthersBody':
        'Эти задачи назначаются другим членам группы, но не активным пользователем.\n ' //'These tasks are assigned to other members of the group but not the active user.\n '
        'Активные пользователи не могут выполнить эти задачи.\n',
    //'These tasks cannot be completed by the active user\n',
    'singleGroupDetailsHelpFutureTasksSubtitle': '- Будущие задачи (видимы только для менеджера группы):',
    // '- Future tasks (visible to group manager only):',
    'singleGroupDetailsHelpFutureTasksBody': 'Эти задачи имеют начальную дату, которая превышает текущее время.\n ',
    //'These tasks have a starting date that is lated than the current time.\n ',
    'singleGroupDetailsHelpCompletedTasksBody':
        'Чтобы просмотреть выполненные задания, необходимо выбрать временной интервал.\n ' //'To see completed tasks a time span must be selected.\n '
        'Только менеджер группы или участник, выполнивший задачу, могут «выполнить незавершенную» задачу\n',
    //'Only the group manager or the member who completed a task can "uncomplete" a task\n',
    'taskDetailsHelpTitle': 'Страница сведений о задаче',
    //'Task details page',
    'taskDetailsHelpIntro':
        'На этой странице указаны все детали выбранной задачи.\n\n' //'This page is where all the details of a selected task are.\n\n'
        'Только менеджер группы может обновлять сведения о задаче.\n\n' //'Only the group manager can update the details of a task.\n\n'
        'Поле задач:\n',
    //'Task fields:\n',
    'taskDetailsHelpValueBody': 'Количество очков, которые получит член для выполнения этой задачи.\n',
    //'The amount of points a member will get for completing this task.\n',
    'taskDetailsHelpRepeatBody': 'Когда задача снова появится после завершения.\n',
    //'When should the task reappear after completion.\n',
    'taskDetailsHelpStartTimeBody':
        'Задача будет видна членам группы только после того, как текущее время будет после этого значения.\n ',
    //'The task will be visible to the group members only after the current time is after this value.\n ',
    'taskDetailsHelpDueTimeBody':
        'Сроки выполнения задачи, после этого времени фона задачи будут окрашены в красный цвет.\n',
    //'The due time of the task, after this time the task background will be colored red.\n',
    'taskDetailsHelpAsssignedMembersBody':
        'Члены группы, которые назначены на эту задачу - только они могут ее завершить.\n' // 'The group members who are assigned to this task - only they are able to complete it.\n'
        'По умолчанию задачи назначаются всем членам группы.\n',
    // 'By default tasks are assigned to allmembers of the group.\n',
  };

  final Map<String, String> _romanian = {
    // =================================================================
    // ===========================  General  ===========================
    // =================================================================
    'email': 'E-mail',
    'password': 'Parola',
    'resetPassword': 'Reseteaza parola',
    'name': 'Nume',
    'invalidValue': 'valoare invalida',
    'gotIt': 'Am înţeles',
    'loading': 'se incarca...',
    'version': 'Versiune',

    // =================================================================
    // ==========================  Login page  =========================
    // =================================================================
    'newUserButton': 'Utilizator nou? Creează un cont',
    'sendingResetPasswordMsg': 'trimiterea unui mesaj de resetare a parolei...',
    'resetPasswordSentMsg': 'Resetați adresa de e-mail pentru parolă',
    'noRegisteredUserWithEmailMsg': 'Nu există niciun utilizator înregistrat cu adresa de e-mail dată',
    'loggingIn': 'Autentificare...',
    'loginWithGoogle': 'Conectați-vă cu Google',
    'loggingInWithGoogle': 'Conectarea la Google...',
    'loginButtonText': 'LOGARE',

    // =================================================================
    // ========================  Register page  ========================
    // =================================================================
    'registerPageTitle': 'Înregistrare',
    'register': 'Inregistreaza-te',
    'passwordLenValidationMsg': 'parola trebuie sa contina minim 6 caractere',
    'registeringNewUserMsg': 'Înregistrarea unui utilizator nou...',

    // =================================================================
    // =======================  Recurring Policies  ====================
    // =================================================================
    'recurringPolicyNone': 'Nici unul',
    'recurringPolicyDaily': 'Zilnic',
    'recurringPolicyWeekly': 'Săptămânal',
    'recurringPolicyMonthly': 'Lunar',
    'recurringPolicyYearly': 'Anual',

    // =================================================================
    // =====================  Task Completed results  ==================
    // =================================================================
    'taskCompletedMsg': 'Ați finalizat sarcina:',
    'loginToCompleteTaskMsg': 'Vă rugăm să vă conectați mai întâi pentru a finaliza sarcina',
    'userCompletedNotInDbErrMsg': 'Vă rugăm să vă reconectați la aplicație pentru a finaliza sarcina',
    'taskNotFoundErrMsg': 'Sarcina asociată cu această etichetă nu mai există',
    'userNotAssignedToTaskErrMsg': 'Nu sunteți alocat sarcinii asociate cu această etichetă',
    'taskDoesNotExistsErrMsg': 'Sarcina asociată cu această etichetă nu mai există',
    'startTimeAfterEndTimeErrMsg': 'Timpul de începere nu poate fi mai târziu decât ora de încheiere',
    'addTaskFailedErrMsg': 'Nu sa reușit adăugarea unei sarcini',
    'unknownCompleteTaskStatusErrMsg': 'Stare completă de sarcină necunoscută',
    'taskIsInFuture': 'Data de începere a activității este în viitor',

    // =================================================================
    // ===========================  General  ===========================
    // =================================================================
    // ~~ user ~~~
    'userID': 'numele de utilizator',
    // ~~~ group ~~~
    'groupInfo': 'Informații despre grup',
    'groupId': 'ID-ul grupului',
    'groupTitleLable': 'Titlul grupului',
    'groupManager': 'Manager de grup',
    'groupMembers': 'Membrii grupului',
    'members': 'Membrii',
    'groupHasNoMembers': 'Grupul nu are membri...',
    // ~~~ task ~~~
    'titleLabel': 'Titlu',
    'tasks': 'Sarcini',
    'valueLabel': 'Valoare',
    'timeNotSet': 'Timpul nu este setat',
    'repeat': 'Repeta',
    'completedBy': 'Completat de',
    'completedOn': 'Completat pe',
    'points': 'puncte',
    // ~~~ App Settings Page ~~~
    'appSettings': 'Setările aplicației',
    'changeTheme': 'Schimbă tema',
    'messageDevs': 'Adresați-i dezvoltatorilor',
    'resetPasswordSentTo': 'Resetați adresa de e-mail pentru parolă',
    'signOut': 'Sign out',
    'deleteAccount': 'Șterge cont',
    'selectTheme': 'Selectează tema',
    'composeMsgToDevsTitle': 'Ce vrei să ne spui?',
    'deleteAccountConfirmMsg': 'Sigur doriți să ștergeți acest cont? Acest lucru nu poate fi anulat',

    // =================================================================
    // ==================  Dialogs and Notifications ===================
    // =================================================================
    // ~~~ buttons labels and titles ~~~
    'confirm': 'A confirma',
    'submit': 'A depune',
    'ok': 'O.K',
    'oops': 'Hopa...',
    'delete': 'Șterge',
    'cancel': 'Anulare',
    'leave': 'Părăsi',
    'help': 'Ajutor',
    'update': 'Actualizați',
    'newGroupTitle': 'Grup nou',
    'pleaseSelect': 'te rog selecteaza',
    'tapToChange': 'atingeți pentru a schimba',
    'descriptionLabel': 'Descriere',
    'leaveGroupLabel': 'Paraseste grupul',
    'deleteGroupLabel': 'Ștergeți grupul',
    'addMemberTitle': 'Adăugați membru',
    'selectAssignedMembersTitle': 'Selectați membrii desemnați',
    'newTask': 'Sarcina noua',
    'scoreboard': 'tablou de bord',
    'futureTasks': 'Sarcinile viitoare',
    'week': 'săptămână',
    'month': 'lună',
    'allTime': 'tot timpul',
    'dueTime': 'Due time',
    'startTime': 'Timpul de începere',
    'notifyMembers': 'notifica membrii',
    'taskNotificationTitle': 'Notificarea de la sarcină',
    'assignedMembers': 'Membrii asociați',
    'displayName': 'Numele afisat',
    'deleteTask': 'Ștergeți sarcina',
    'writeToNfc': 'Scrieți către NFC',
    'readyToWrite': 'Sunteți gata să scrieți',
    'holdPhoneOverNfc': 'Țineți telefonul prin eticheta NFC',
    'today': 'astăzi',
    'thisWeek': 'săptămâna aceasta',
    'thisMonth': 'luna aceasta',
    'selectLanguageTitle': 'Selecteaza limba',
    // ~~~ Notification messages ~~~
    'notificationFromGroupTitle': 'Notificare din grup',
    'sendNotificationTitle': 'Trimiteți o notificare',
    'notificationMessageLable': 'mesaj de notificare',
    'addedToGroupMsg': 'Ați fost adăugați în acest grup',
    'hasBeenAddedToThisGroup': 'a fost adăugat la acest grup',
    'leaveGroupConfirmMsg': 'Sigur doriți să părăsiți acest grup?\nAcest lucru nu poate fi anulat',
    'deleteTaskConfirmMsg': 'Sigur doriți să ștergeți această sarcină?\nAcest lucru nu poate fi anulat',
    'hi': 'Bună',
    'oneTaskRemainingMsg': 'Aveți doar o singură sarcină care rămâne în toate grupurile, permiteți-vă să lucrați...',
    'allTasksRemainingMsg': '- toate sarcinile pe care le-ai rămas în toate grupurile, te lasă să lucrezi...',
    'noTasksRemainingMsg': 'Minunat! nu aveți sarcini de făcut :)',
    'notInAnyGroup': 'Încă nu sunteți în niciun grup',
    'noDescription': 'Nu a fost introdusă nicio descriere',
    'clickToCreateGroup': 'Faceți clic pe "+" în\creați un nou grup',

    // ~~~ message bodies ~~~
    'deleteGroupConfirmMsg': 'Sigur doriți să ștergeți acest grup?\nAcest lucru nu poate fi anulat',
    'selectTimespanPrompt': 'Selectați o perioadă de timp',
    'noCompletedTasks': 'Nu există sarcini completate',
    'msgSentToDevs': 'Mesajul dvs. a fost trimis dezvoltatorilor. Mulțumesc :)',

    // ~~~ single group page ~~~
    'tasksAssignedToOthersTitle': 'Sarcini atribuite altor persoane',
    'tasksAssignedToMeTitle': 'Sarcinile care mi-au fost atribuite',
    'completedTasksTitle': 'Sarcini completate',
    'noTasksAssignedToOthers': 'Nu există sarcini alocate altor persoane din acest grup',
    'noTasksAssignetToYou': 'Nu există sarcini care să vă fie atribuite în acest grup',
    'noFutureTasks': 'Nu există sarcini viitoare în acest grup',

    // ~~~ remove member ~~~
    'removeMemberLable': 'Scoateți membrul',
    'confirmRemove': 'Sigur doriți să eliminați',
    'fromTheGroup': 'din grup',

    // ~~~ fetching from DB and loading overlay messages ~~~
    'fetchingAssignedMembers': 'Obtinerea membrilor desemnați ...',
    'fetchingTasksFromServer': 'Obtinerea sarcinilor ...',
    'fetchingGroups': 'Obtinerea grupuri ...',
    'fetchingScoreboard': 'Obtinerea tablou de bord ...',
    'removingGroupMember': 'Eliminarea membrului grupului...',
    'leavingGroup': 'Lăsând grupul ...',
    'deletingGroup': 'Ștergerea grupului ...',
    'deletingAccount': 'Ștergerea acestui cont ...',
    'deletingTask': 'Ștergerea sarcinii ...',
    'uploadingImage': 'Se încarcă imaginea ...',
    'loadingGroupPage': 'Se încarcă pagina grupului ...',
    'loadingTaskDetailsPage': 'Încărcați pagina cu detalii despre sarcină ...',

    // =================================================================
    // =======================  Error Messages  ========================
    // =================================================================
    'addMemberNotificationErrMsg':
    'a fost adăugat la grup, dar din cauza unei erori de conectare, nu a fost trimisă o notificare',
    'taskValueIntegerValidationMsg': 'Valoarea sarcinii trebuie să fie un număr întreg pozitiv',
    'emailAddressesAreCaseSensitive': '** Adresele de e-mail sunt sensibile la minuscule **',
    'leaveGroupErrorPrefixMsg': 'Eroare la încercarea de a părăsi grupul, încercați din nou.\n\nDetaliile de excepție:\n',
    'uploadPhotoErrMsg': 'Eroare la încărcarea fotografiei, încercați din nou.\n\nDetaliile de excepție:\n',
    'sendMsgToDevsErr': 'Eroare la trimiterea mesajului, încercați din nou.\n\nDetaliile de excepție:\n',
    'taskNotUpdatedErrMsg':
    'Nu s-a putut actualiza sarcina din cauza următoarei erori, încercați din nou.\n\nDetaliile de excepție:\n',
    'getGroupInfoErrMsg': 'Eroare la încercarea de a obține informații despre grup, încercați din nou.\n\nDetaliile de excepție:\n',
    'parentGroupNotFoundErrMsg': 'Grupul care conținea sarcina nu a fost găsit',
    'removeMemberFromGroupErrMsg':
    'Eroare la eliminarea membrilor din grup, membrul nu a fost eliminat, încercați din nou.\n\nDetaliile de excepție:\n',
    'editGroupInfoErrMsg':
    'Eroare la actualizarea informațiilor despre grup, informațiile despre grup nu vor fi actualizate, încercați din nou.\n\nDetaliile de excepție:\n',
    'deleteGroupErrMsg': 'Eroare la ștergerea grupului, încercați din nou.\n\nDetaliile de excepție:\n',
    'scoreBoardFetchErrMsg':
    'Eroare la încercarea de a obține tabloul de bord al grupului, încercați din nou.\n\nDetaliile de excepție:\n',
    'addMemberErrMsgPrefix': 'Eroare la încercarea de a adăuga un nou membru, încercați din nou.\n\nDetaliile de excepție:\n',
    'openTaskDetailsPageErrMsg':
    'Eroare în timp ce încercați să deschideți pagina cu detalii privind sarcina, încercați din nou.\n\nDetaliile de excepție:\n',
    'deleteTaskErrMsg': 'Eroare la încercarea de a șterge sarcina, încercați din nou.\n\nDetaliile de excepție:\n',
    'signOutErrMsg': 'Eroare la deconectare, încercați din nou.\n\nDetaliile de excepție:\n',
    'atLeastOneMustBeSelected': 'Trebuie să fie selectat cel puțin un utilizator',
    'sendNotificationsErrMsgPrefix':
    'Eroare la trimiterea notificărilor, următorii utilizatori nu au primit notificarea:\n',
    'invalidEmail': 'Adresa email invalida',
    'loginErrMsg': 'Eroare la încercarea de conectare, încercați din nou.\n\nDetaliile de excepție:\n',
    'registrationErrMsg': 'Eroare la încercarea de a înregistra un utilizator nou, încercați din nou.\n\nDetaliile de excepție:\n',
    'loginWithGoogleErrMsg': 'Eroare la încercarea de a vă conecta cu Google, încercați din nou.\n\nDetaliile de excepție:\n',
    'fieldCannotBeEmpty': 'Acest câmp nu poate fi gol',

    // =================================================================
    // ==========================  Languages  ==========================
    // =================================================================
    'changeLanguage': 'Schimbați limba',

    // =================================================================
    // ==========================  Help Pages ==========================
    // =================================================================
    'singleGroupDetailsHelpTitle': 'Pagina cu detalii privind grupul unic',
    'singleGroupDetailsHelpIntro': 'Această pagină este locul în care un utilizator poate vedea toate sarcinile grupului selectat.\n\n'
        'Imaginea grupului poate fi modificată de orice membru al grupului făcând clic pe imaginea grupului din partea de sus a paginii\n\n'
        'Fiecare sarcină din grup este afișată pe o carte de sarcini, făcând clic pe carte va afișa pagina cu detaliile sarcinii\n'
        'Aici managerul de grup poate actualiza sarcina\n\n'
        'Sarcinile de grup sunt separate în următoarele secțiuni:\n',
    'singleGroupDetailsHelpTasksAssignedToMeSubtitle': '- Sarcinile care mi-au fost atribuite (utilizatorul activ):',
    'singleGroupDetailsHelpTasksAssignedToMeBody': 'Aceste sarcini sunt sarcinile pe care utilizatorul le poate finaliza.\n '
        'Când o sarcină este finalizată, ea este mutată la secțiunea sarcinilor finalizate.\n'
        'Dacă o sarcină este o sarcină recurentă, după ce este finalizată, va fi generată o nouă sarcină cu data actualizată de început sau de sfârșit.\n'
        '* Dacă noua dată a unei sarcini recurente este după ora curentă, va apărea în secțiunea de sarcini viitoare *\n',
    'singleGroupDetailsHelpTasksAssignedToOthersSubtitle': '- Sarcini atribuite altor utilizatori:',
    'singleGroupDetailsHelpTasksAssignedToOthersBody':
    'Aceste sarcini sunt atribuite altor membri ai grupului, dar nu utilizator activ.\n '
        'Aceste sarcini nu pot fi completate de utilizatorul activ.\n',
    'singleGroupDetailsHelpFutureTasksSubtitle': '- Sarcinile viitoare (vizibile numai pentru managerul de grup):',
    'singleGroupDetailsHelpFutureTasksBody': 'Aceste sarcini au o dată de început care este mai târziu decât ora curentă.\n ',
    'singleGroupDetailsHelpCompletedTasksBody': 'Pentru a vedea sarcinile finalizate, trebuie selectat un interval de timp.\n '
        'Doar managerul de grup sau membrul care a finalizat o sarcină poate "să nu finalizeze" o activitate\n',
    'taskDetailsHelpTitle': 'Detalii despre pagina de activități',
    'taskDetailsHelpIntro': 'Această pagină este în cazul în care toate detaliile unei sarcini selectate sunt.\n\n'
        'Numai managerul de grup poate actualiza detaliile unei sarcini.\n\n'
        'Câmpuri de activități:\n',
    'taskDetailsHelpValueBody': 'Suma de puncte pe care un membru o va obține pentru a îndeplini această sarcină.\n',
    'taskDetailsHelpRepeatBody': 'Când trebuie să reapară sarcina după finalizare.\n',
    'taskDetailsHelpStartTimeBody':
    'Sarcina va fi vizibilă membrilor grupului numai după ce ora curentă este după această valoare.\n ',
    'taskDetailsHelpDueTimeBody':
    'Perioada de timp a sarcinii, după care fundalul sarcinii va fi colorat roșu.\n',
    'taskDetailsHelpAsssignedMembersBody':
    'Membrii grupului care sunt desemnați pentru această sarcină - numai ei pot să o completeze.\n'
        'În mod implicit, sarcinile sunt atribuite tuturor membrilor grupului.\n',
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

  String get invalidValue => _currentLanguageMap['invalidValue'] ?? _english['invalidValue'];

  String get gotIt => _currentLanguageMap['gotIt'] ?? _english['gotIt'];

  String get loading => _currentLanguageMap['loading'] ?? _english['loading'];

  String get version => _currentLanguageMap['version'] ?? _english['version'];

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

  String get taskIsInFuture => _currentLanguageMap['taskIsInFuture'] ?? _english['taskIsInFuture'];

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

  String get notificationMessageLabel =>
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

  String get clickToCreateGroup => _currentLanguageMap['clickToCreateGroup'] ?? _english['clickToCreateGroup'];

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

  String get noTasksAssignedToYou => _currentLanguageMap['noTasksAssignetToYou'] ?? _english['noTasksAssignetToYou'];

  String get noFutureTasks => _currentLanguageMap['noFutureTasks'] ?? _english['noFutureTasks'];

  // ~~~ remove member ~~~
  String get removeMemberLabel => _currentLanguageMap['removeMemberLable'] ?? _english['removeMemberLable'];

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

  String get loadingGroupPage => _currentLanguageMap['loadingGroupPage'] ?? _english['loadingGroupPage'];

  String get loadingTaskDetailsPage =>
      _currentLanguageMap['loadingTaskDetailsPage'] ?? _english['loadingTaskDetailsPage'];

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
  String get changeLanguage => _currentLanguageMap['changeLanguage'] ?? _english['changeLanguage'];

  // =================================================================
  // ==========================  Help Pages ==========================
  // =================================================================
  String get singleGroupDetailsHelpTitle =>
      _currentLanguageMap['singleGroupDetailsHelpTitle'] ?? _english['singleGroupDetailsHelpTitle'];

  String get singleGroupDetailsHelpIntro =>
      _currentLanguageMap['singleGroupDetailsHelpIntro'] ?? _english['singleGroupDetailsHelpIntro'];

  String get singleGroupDetailsHelpTasksAssignedToMeSubtitle =>
      _currentLanguageMap['singleGroupDetailsHelpTasksAssignedToMeSubtitle'] ??
      _english['singleGroupDetailsHelpTasksAssignedToMeSubtitle'];

  String get singleGroupDetailsHelpTasksAssignedToMeBody =>
      _currentLanguageMap['singleGroupDetailsHelpTasksAssignedToMeBody'] ??
      _english['singleGroupDetailsHelpTasksAssignedToMeBody'];

  String get singleGroupDetailsHelpTasksAssignedToOthersSubtitle =>
      _currentLanguageMap['singleGroupDetailsHelpTasksAssignedToOthersSubtitle'] ??
      _english['singleGroupDetailsHelpTasksAssignedToOthersSubtitle'];

  String get singleGroupDetailsHelpTasksAssignedToOthersBody =>
      _currentLanguageMap['singleGroupDetailsHelpTasksAssignedToOthersBody'] ??
      _english['singleGroupDetailsHelpTasksAssignedToOthersBody'];

  String get singleGroupDetailsHelpFutureTasksSubtitle =>
      _currentLanguageMap['singleGroupDetailsHelpFutureTasksSubtitle'] ??
      _english['singleGroupDetailsHelpFutureTasksSubtitle'];

  String get singleGroupDetailsHelpFutureTasksBody =>
      _currentLanguageMap['singleGroupDetailsHelpFutureTasksBody'] ?? _english['singleGroupDetailsHelpFutureTasksBody'];

  String get singleGroupDetailsHelpCompletedTasksBody =>
      _currentLanguageMap['singleGroupDetailsHelpCompletedTasksBody'] ??
      _english['singleGroupDetailsHelpCompletedTasksBody'];

  String get taskDetailsHelpTitle => _currentLanguageMap['taskDetailsHelpTitle'] ?? _english['taskDetailsHelpTitle'];

  String get taskDetailsHelpIntro => _currentLanguageMap['taskDetailsHelpIntro'] ?? _english['taskDetailsHelpIntro'];

  String get taskDetailsHelpValueBody =>
      _currentLanguageMap['taskDetailsHelpValueBody'] ?? _english['taskDetailsHelpValueBody'];

  String get taskDetailsHelpRepeatBody =>
      _currentLanguageMap['taskDetailsHelpRepeatBody'] ?? _english['taskDetailsHelpRepeatBody'];

  String get taskDetailsHelpStartTimeBody =>
      _currentLanguageMap['taskDetailsHelpStartTimeBody'] ?? _english['taskDetailsHelpStartTimeBody'];

  String get taskDetailsHelpDueTimeBody =>
      _currentLanguageMap['taskDetailsHelpDueTimeBody'] ?? _english['taskDetailsHelpDueTimeBody'];

  String get taskDetailsHelpAsssignedMembersBody =>
      _currentLanguageMap['taskDetailsHelpAsssignedMembersBody'] ?? _english['taskDetailsHelpAsssignedMembersBody'];
  //endregion

  List<Locale> getSupportedLanguages() {
    return [
      Locale('en', 'US'),
      Locale('he', 'IL'),
      Locale('ru', 'RU'),
      Locale('ro', 'RO'),
    ];
  }

  static String localeToLanguageString(Locale locale) {
    switch (locale.languageCode) {
      case 'he':
        return 'עברית';
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'ro':
        return 'Română';
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
      case 'ro_RO':
        return Locale('ro', 'RO');
      case 'en_US':
      default:
        return Locale('en', 'US');
    }
  }

  void setLanguage(String languageCode) {
    switch (languageCode) {
      case "he":
        _currentLanguageMap = _hebrew;
        break;
      case "ru":
        _currentLanguageMap = _russian;
        break;
      case "ro":
        _currentLanguageMap = _romanian;
        break;
      default:
        _currentLanguageMap = _english;
    }
  }
}
