import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/group/group_utils.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/speed_dial.dart';
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
    // stop listen for group list update
    _groupsStreamSubscription.cancel();
    super.dispose();
  }

  /// update the change groups from db
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              backgroundColor: App.instance.themeData.primaryColor,
              child: Icon(Icons.add),
              onPressed: () => _showAddGroupDialog(),
            ),
    );
  }

  ///
  /// get all groups from db
  ///
  Future _getMyGroupsFromDB([List<ShortGroupInfo> myGroups]) async {
    await _getAllTasksCount().then((allTasksCount) async {
      if (myGroups == null) {
        myGroups = await App.instance.groupsManager.getMyGroupsFromDB();
      }
      setState(() {
        _myGroups = List.from(myGroups);
        _allTasksWidget = allTasksCount;
      });
    });
  }

  /// tasks count message on the top of home screen
  Future<Widget> _getAllTasksCount() async {
    List<ShortTaskInfo> allTasks = await App.instance.tasksManager.getAllMyTasks();
    String tasksRemainingString = allTasks.length > 0
        ? 'Hi ${app.loggedInUser.displayName}! \nYou have a total of ${allTasks.length.toString()} tasks remaining in all groups, lets get to work...'
        : "Awsome! you have no tasks to do :)";
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
    ShortUserInfo loggedInUser = App.instance.loggedInUser;
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    List<ShortGroupInfo> myGroups = GroupUtils.conventDBGroupsToGroupInfoList(loggedInUser.userID, groupsQuerySnapshot);
    _getMyGroupsFromDB(myGroups);
  }

  Widget _myGroupsWidget(BuildContext context) {
    if (_myGroups == null || _allTasksWidget == null)
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.asset(
            'assets/doit_logo/loading_animation.gif',
            width: 50.0,
          ),
          Text('Fetching groups from server...'),
        ],
      );

    if (_myGroups.length == 0)
      return Stack(
        fit: StackFit.expand,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
//          Expanded(child: Container()),
          Center(
            child: Column(
              children: <Widget>[
                Expanded(child: Container()),
                Image.asset("assets/images/minion_sad.png", scale: 1.5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("You are not in any group yet",
                      style: Theme.of(context).textTheme.title, textAlign: TextAlign.center),
                ),
                SizedBox(height: 100.0),
                Expanded(child: Container()),
              ],
            ),
          ),
//          Expanded(child: Container()),
          Positioned(
            bottom: 0.0,
            right: 80.0,
            child: Image.asset("assets/images/ClickToCreateGroup.png", height: 170.0),
          ),
        ],
      );

    List<Widget> list = new List();
    list.add(_allTasksWidget);
    _myGroups.sort((a, b) =>
        b.tasksPerUser[App.instance.getLoggedInUser().userID] - a.tasksPerUser[App.instance.loggedInUser.userID]);
    list.addAll(_myGroups.map((group) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GroupCard(shortGroupInfo: group),
      );
    }).toList());
    list.add(SizedBox(height: 80.0)); // this is so the "add group" button doesn't hide the last card
    return ListView(children: list);
  }

  Future<void> _showAddGroupDialog() async {
    TextEditingController _groupTitleController = new TextEditingController();
    TextEditingController _groupDescriptionController = new TextEditingController();

    DoItDialogs.showUserInputDialog(
      context: context,
      inputWidgets: [
        DoItTextField(
          controller: _groupTitleController,
          label: 'Title',
          isRequired: true,
          maxLength: 15,
        ),
        DoItTextField(
          controller: _groupDescriptionController,
          label: 'Description',
          isRequired: false,
        ),
      ],
      title: 'New Group',
      onSubmit: () async {
        await App.instance.groupsManager.addNewGroup(
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
            child: Image.asset('assets/doit_logo/loading_animation.gif'),
          ),
          SizedBox(height: 20.0),
          Text('Fetching groups from server...', textAlign: TextAlign.center),
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
