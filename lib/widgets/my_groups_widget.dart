import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_managers/groups_manager.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/group_page.dart';
import 'package:do_it/widgets/user_settings_page.dart';
import 'package:flutter/material.dart';

class MyGroupsPage extends StatefulWidget {
  final App app = App.instance;

  @override
  MyGroupsPageState createState() {
    return new MyGroupsPageState();
  }
}

class MyGroupsPageState extends State<MyGroupsPage> {
  List<ShortGroupInfo> _myGroups;
  Widget _allTasksWidget;
  // for remove groups listener
  StreamSubscription<QuerySnapshot> _streamSubscriptionGroups;

  @override
  void initState() {
    // listen for group list update
    super.initState();
    _streamSubscriptionGroups = App.instance.firestore.collection(GROUPS).snapshots().listen(_updateGroupList);
    getMyGroupsFromDB();
  }

  @override
  void dispose() {
    // stop listen for group list update
    _streamSubscriptionGroups.cancel();
    super.dispose();
  }

  ///
  /// get all groups from db
  ///
  void getMyGroupsFromDB() {
    _getAllTasksCount().then((allTasksCount) {
      App.instance.groupsManager.getMyGroupsFromDB().then((myGroups) {
        setState(() {
          _myGroups = List.from(myGroups);
          _allTasksWidget = allTasksCount;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragDown: (details) => getMyGroupsFromDB(),
        child: Container(
          child: Center(
            child: ListView(
              // TODO change to widgets, this is just fot testing obviously
              children: _getAllGroups(context),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          _showAddGroupDialog('test');
        },
      ),
    );
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

  List<Widget> _getAllGroups(BuildContext context) {
    if (_myGroups == null || _allTasksWidget == null) return [Text('Fetching groups from server...')];

    if (_myGroups.length == 0) return [ListTile(title: Text("you are not in any group yet"))];

    List<Widget> list = new List();
    list.add(_allTasksWidget);
    list.addAll(_myGroups.map((group) {
      return ListTile(
        title: Text(group.title),
        subtitle: Text(group.tasksPerUser[App.instance.getLoggedInUser().userID].toString()),
        onTap: () {
          widget.app.groupsManager.getGroupInfoByID(group.groupID).then((groupInfo) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDetailsPage(groupInfo)));
          });
        },
      );
    }).toList());
    return list;
  }

  Future<void> _showAddGroupDialog(String message) async {
    TextEditingController _groupTitleController = new TextEditingController();
    TextEditingController _groupDescriptionController = new TextEditingController();
    TextEditingController _groupPhotoUrlController = new TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Text('Test'),
            children: <Widget>[
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
              DoItTextField(
                controller: _groupPhotoUrlController,
                label: 'Photo Url',
                isRequired: false,
              ),
              RaisedButton(
                onPressed: () async {
                  await App.instance.groupsManager.addNewGroup(
                    title: _groupTitleController.text,
                    description: _groupDescriptionController.text,
                    photoURL: _groupPhotoUrlController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              )
            ],
//              content: Text(message),
//              actions: <Widget>[
//                new SimpleDialogOption(
//                  onPressed: () => Navigator.pop(context),
//                  child: const Text('Ok'),
//                ),
//              ]
          );
        });
  }

  ///
  /// update the change groups from db
  ///
  void _updateGroupList(QuerySnapshot groupsQuerySnapshot) {
    ShortUserInfo loggedInUser = App.instance.getLoggedInUser();
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    setState(() {
      _myGroups = GroupsManager.conventDBGroupsToObjectList(loggedInUser.userID, groupsQuerySnapshot);
    });
  }
}
