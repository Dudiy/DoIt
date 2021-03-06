import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/group/group_utils.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/groups/group_card.dart';
import 'package:flutter/material.dart';

class MyGroupsPage extends StatefulWidget {
  @override
  MyGroupsPageState createState() {
    return new MyGroupsPageState();
  }
}

class MyGroupsPageState extends State<MyGroupsPage> {
  final App app = App.instance;
  List<ShortGroupInfo> _myGroups;
  Widget _allTasksWidget;

  // for remove groups listener
  StreamSubscription<QuerySnapshot> _groupsStreamSubscription;

  @override
  void initState() {
    // listen for group list update
    super.initState();
    _groupsStreamSubscription = app.firestore.collection(GROUPS).snapshots().listen(_updateGroupList);
    _getMyGroupsFromDB();
  }

  @override
  void dispose() {
    // stop listening for group list updates
    _groupsStreamSubscription.cancel();
    super.dispose();
  }

  /// update the change groups from db
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app.textDirection,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(
            child: _renderMyGroupBody(),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(app.bgImagePath),
              ),
            ),
          ),
          floatingActionButton: _myGroups == null || _allTasksWidget == null
              ? null
              : FloatingActionButton(
                  backgroundColor: app.themeData.primaryColor,
                  child: Icon(Icons.add),
                  onPressed: () => _showAddGroupDialog(),
                ),
        ),
      ),
    );
  }

  ///
  /// get all groups from db
  ///
  Future<void> _getMyGroupsFromDB([List<ShortGroupInfo> myGroups]) async {
    if (app.loggedInUser == null) return;
    await _getAllTasksCount().then((allTasksCount) async {
      if (myGroups == null) {
        myGroups = await app.groupsManager.getMyGroupsFromDB().catchError((e) {
          print("Error while getting groups from server: ${e.message}");
          // if no groups were fetched from the db, return null
          return null;
        });
      }
      if (myGroups != null) {
        setState(() {
          _myGroups = List.from(myGroups);
          _allTasksWidget = allTasksCount;
        });
      }
    });
  }

  /// tasks count message on the top of home screen
  Future<Widget> _getAllTasksCount() async {
    if (app.loggedInUser == null) return null;
    List<ShortTaskInfo> allTasks = await app.tasksManager.getAllMyTasks();
    String tasksRemainingString = allTasks.length > 0
        ? allTasks.length == 1
            ? '${app.strings.hi} ${app.loggedInUser.displayName}! \n${app.strings.oneTaskRemainingMsg}'
            : '${app.strings.hi} ${app.loggedInUser.displayName}! \n${allTasks.length.toString()} ${app.strings.allTasksRemainingMsg}'
        : app.strings.noTasksRemainingMsg;
    if (!mounted) return null;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            tasksRemainingString,
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _updateGroupList(QuerySnapshot groupsQuerySnapshot) {
    ShortUserInfo loggedInUser = app.loggedInUser;
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    List<ShortGroupInfo> myGroups = GroupUtils.conventDBGroupsToGroupInfoList(loggedInUser.userID, groupsQuerySnapshot);
    _getMyGroupsFromDB(myGroups);
  }

  Widget _myGroupsWidget(BuildContext context) {
    bool isRtl = app.textDirection == TextDirection.rtl;
    if (_myGroups == null || _allTasksWidget == null)
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.asset(
            LOADING_ANIMATION,
            width: 50.0,
          ),
          Text(app.strings.fetchingGroups),
        ],
      );

    if (_myGroups.length == 0)
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Expanded(child: Container()),
                Image.asset(MINION_SAD, scale: 1.5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(app.strings.notInAnyGroup,
                      style: Theme.of(context).textTheme.title, textAlign: TextAlign.center),
                ),
                SizedBox(height: 100.0),
                Expanded(child: Container()),
              ],
            ),
          ),
          Positioned(
            bottom: 15.0,
            right: !isRtl ? 90.0 : null,
            left: isRtl ? 90.0 : null,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Transform.rotate(
                    angle: isRtl ? 0.25 : -0.25,
                    origin: Offset(
                      isRtl ? -50.0 : 50.0,
                      -140.0,
                    ),
                    child: Text(app.strings.clickToCreateGroup),
                  ),
                ),
                Image.asset(isRtl ? ARROW_LEFT : ARROW_RIGHT, height: 130.0),
              ],
            ),
          ),
        ],
      );

    List<Widget> list = new List();
    list.add(_allTasksWidget);
    _myGroups.sort((a, b) => b.tasksPerUser[app.getLoggedInUser().userID] - a.tasksPerUser[app.loggedInUser.userID]);
    list.addAll(_myGroups.map((group) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GroupCard(shortGroupInfo: group),
      );
    }).toList());
    list.add(SizedBox(height: 80.0)); // this is so the "add group" button doesn't hide the last card
    return ListView(physics: BouncingScrollPhysics(), children: list);
  }

  Future<void> _showAddGroupDialog() async {
    TextEditingController _groupTitleController = new TextEditingController();
    TextEditingController _groupDescriptionController = new TextEditingController();

    DoItDialogs.showUserInputDialog(
      context: context,
      inputWidgets: [
        DoItTextField(
          controller: _groupTitleController,
          label: app.strings.titleLabel,
          isRequired: true,
          maxLength: 15,
        ),
        DoItTextField(
          controller: _groupDescriptionController,
          label: app.strings.descriptionLabel,
          isRequired: false,
        ),
      ],
      title: app.strings.newGroupTitle,
      onSubmit: () async {
        await app.groupsManager.addNewGroup(
          title: _groupTitleController.text,
          description: _groupDescriptionController.text,
        );
        Navigator.pop(context);
      },
    );
  }

  _renderMyGroupBody() {
    if (_myGroups == null || _allTasksWidget == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            constraints: BoxConstraints.tight(Size.square(50.0)),
            child: Image.asset(LOADING_ANIMATION),
          ),
          SizedBox(height: 20.0),
          Text(app.strings.fetchingGroups, textAlign: TextAlign.center),
        ],
      );
    } else {
      _getMyGroupsFromDB();
      return RefreshIndicator(
        child: _myGroupsWidget(context),
        onRefresh: _getMyGroupsFromDB,
      );
    }
  }
}
