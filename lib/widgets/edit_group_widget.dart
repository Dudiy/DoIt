import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_managers/groups_manager.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:flutter/material.dart';

class EditGroupPage extends StatefulWidget {
  final GroupInfo groupInfo;
  final ShortUserInfo groupManager;
  final Function onGroupInfoChanged;
  EditGroupPage(this.groupInfo, this.groupManager, this.onGroupInfoChanged);

  @override
  EditGroupPageState createState() => new EditGroupPageState();
}

class EditGroupPageState extends State<EditGroupPage> {
  final App app = App.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _photoUrlController = new TextEditingController();
  final TextEditingController _groupIDController = new TextEditingController();
  final TextEditingController _managerDisplayNameController = new TextEditingController();

  @override
  void initState() {
    _groupIDController.text = widget.groupInfo.groupID;
    _managerDisplayNameController.text = widget.groupManager.displayName;
    _titleController.text = widget.groupInfo.title;
    _descriptionController.text = widget.groupInfo.description;
    _photoUrlController.text = widget.groupInfo.photoUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.groupInfo.title} (update)'),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.save, color: Colors.white),
            onPressed: () async {
              await app.groupsManager.updateGroupInfo(
                groupIDToChange: widget.groupInfo.groupID,
                title: _titleController.text.isNotEmpty ? _titleController.text : null,
                description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                photoUrl: _photoUrlController.text.isNotEmpty ? _photoUrlController.text : null,
              ).then((newGroupInfo){
                widget.onGroupInfoChanged(newGroupInfo);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Form(
                key: _formKey,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  DoItTextField(controller: _groupIDController, label: 'Group ID', enabled: false),
                  DoItTextField(controller: _managerDisplayNameController, label: 'Group manager', enabled: false),
                  DoItTextField(controller: _titleController, label: 'Group title'),
                  DoItTextField(controller: _descriptionController, label: 'Description'),
                  DoItTextField(controller: _photoUrlController, label: 'Photo URL'),
                ])),
          ),
          Column(
            children: getAllMembers(),
          ),
        ],
      ),
    );
  }

  List<Widget> getAllMembers() {
    List<StatelessWidget> list = new List();
    list.add(Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          'Group Members',
          style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline),
        )),
      ),
    ));
    list.addAll(widget.groupInfo.members == null || widget.groupInfo.members.length == 0
        ? [Text('The group has no members...')]
        : widget.groupInfo.members.values.map((shortUserInfo) {
            return ListTile(
              title: Text(shortUserInfo.displayName),
              subtitle: Text(shortUserInfo.userID),
            );
          }).toList());
    return list;
  }

//  void _updateTasksList(DocumentSnapshot documentSnapshotGroupTasks) {
//    ShortUserInfo loggedInUser = App.instance.getLoggedInUser();
//    if (loggedInUser == null) {
//      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
//    }
//    setState(() {
//      _groupTasks = GroupsManager.conventDBGroupTaskToObjectList(documentSnapshotGroupTasks);
//    });
//  }
}
