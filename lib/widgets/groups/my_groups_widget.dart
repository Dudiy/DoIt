import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/group/group_utils.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/dialog.dart';
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
      body: RefreshIndicator(
              child: Container(
                child: Center(
                  child: ListView(
                    // TODO change to widgets, this is just fot testing obviously
                    children: _myGroupsWidget(context),
                  ),
                ),
              ),
              onRefresh: _getMyGroupsFromDB,
      )
          /*GestureDetector(
        onVerticalDragDown: (details) => _getMyGroupsFromDB(),
        child: Container(
          child: Center(
            child: ListView(
              // TODO change to widgets, this is just fot testing obviously
              children: _myGroupsWidget(context),
            ),
          ),
        ),
      )*/
          ,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          _showAddGroupDialog();
        },
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

  Future<Widget> _getAllTasksCount() async {
    List<ShortTaskInfo> allTasks = await App.instance.tasksManager.getAllMyTasks();
    return ListTile(
      title: Text('All Groups'),
      subtitle: Text(allTasks.length.toString()),
      onTap: () {
        // TODO go to all tasks page
        print('not implemented yet - going to all tasks page');
//          widget.app.groupsManager.getGroupInfoByID(k.groupID).then((groupInfo) {
//            Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDetailsPage(groupInfo)));
//          });
      },
    );
  }

  void _updateGroupList(QuerySnapshot groupsQuerySnapshot) {
    ShortUserInfo loggedInUser = App.instance.getLoggedInUser();
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    List<ShortGroupInfo> myGroups = GroupUtils.conventDBGroupsToGroupInfoList(loggedInUser.userID, groupsQuerySnapshot);
    _getMyGroupsFromDB(myGroups);
  }

  List<Widget> _myGroupsWidget(BuildContext context) {
    if (_myGroups == null || _allTasksWidget == null) return [Text('Fetching groups from server...')];

    if (_myGroups.length == 0) return [ListTile(title: Text("you are not in any group yet"))];

    List<Widget> list = new List();
    list.add(_allTasksWidget);
    _myGroups.sort((a, b) =>
        b.tasksPerUser[App.instance.getLoggedInUser().userID] - a.tasksPerUser[App.instance.getLoggedInUser().userID]);
    list.addAll(_myGroups.map((group) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GroupCard(shortGroupInfo: group),
      );
    }).toList());
    return list;
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
}
