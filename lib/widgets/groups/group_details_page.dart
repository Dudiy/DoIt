import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/dialog.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/groups/scoreboard_widget.dart';
import 'package:flutter/material.dart';

class GroupDetailsPage extends StatefulWidget {
  final GroupInfo groupInfo;
  final ShortUserInfo groupManager;
  final Function onGroupInfoChanged;

  GroupDetailsPage(this.groupInfo, this.groupManager, this.onGroupInfoChanged);

  @override
  GroupDetailsPageState createState() => new GroupDetailsPageState();
}

class GroupDetailsPageState extends State<GroupDetailsPage> {
  final App app = App.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _photoUrlController = new TextEditingController();
  final TextEditingController _groupIDController = new TextEditingController();
  final TextEditingController _managerDisplayNameController = new TextEditingController();

  Map<String, ShortUserInfo> _groupMembers;
  bool editEnabled;
  List<StatelessWidget> _scoreBoardWidget;

  @override
  void initState() {
    editEnabled = app.loggedInUser.userID == widget.groupInfo.managerID;
    _groupIDController.text = widget.groupInfo.groupID;
    _managerDisplayNameController.text = widget.groupManager.displayName;
    _titleController.text = widget.groupInfo.title;
    _descriptionController.text = widget.groupInfo.description;
    _photoUrlController.text = widget.groupInfo.photoUrl;
    _groupMembers = widget.groupInfo.members;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.groupInfo.title} details'),
        actions: drawActions(),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Form(
                key: _formKey,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  DoItTextField(controller: _groupIDController, label: 'Group ID', enabled: false),
                  DoItTextField(controller: _managerDisplayNameController, label: 'Group manager', enabled: false),
                  DoItTextField(
                    controller: _titleController,
                    label: 'Group title',
                    enabled: editEnabled,
                  ),
                  DoItTextField(controller: _descriptionController, label: 'Description', enabled: editEnabled),
                  DoItTextField(controller: _photoUrlController, label: 'Photo URL', enabled: editEnabled),
                ])),
          ),
          Column(
            children: getAllMembers(),
          ),
          /*Column(
            children: _scoreBoardWidget,
          )*/
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                'Score Board',
                style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline),
              )),
            ),
          ),
          ScoreBoard(widget.groupInfo),
        ],
      ),
    );
  }

  List<Widget> drawActions() {
    List<Widget> actions = new List();
    if (editEnabled)
      actions.add(FlatButton(
        child: Icon(Icons.save, color: Colors.white),
        onPressed: () async {
          await app.groupsManager
              .updateGroupInfo(
            groupIdToChange: widget.groupInfo.groupID,
            title: _titleController.text.isNotEmpty ? _titleController.text : null,
            description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
            photoUrl: _photoUrlController.text.isNotEmpty ? _photoUrlController.text : null,
          )
              .then((newGroupInfo) {
            widget.onGroupInfoChanged(newGroupInfo);
          });
          Navigator.pop(context);
        },
      ));
    return actions;
  }

  List<Widget> getAllMembers() {
    List<StatelessWidget> list = new List();
    list.add(Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Center(
                child: Text(
              'Group Members',
              style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline),
            )),
            Positioned(
              right: 10.0,
              top: -11.0,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showAddMemberDialog();
                },
              ),
            ),
          ],
        ),
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

  getScoreBoard() {
    List<StatelessWidget> list = new List();
    list.add(Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          'Score Board',
          style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline),
        )),
      ),
    ));
    if (_scoreBoardWidget == null) {
      list.add(Text('fetchig score board from DB...'));
      _scoreBoardWidget = list;
    }
    app.groupsManager.getGroupScoreboards(groupID: widget.groupInfo.groupID).then((scoreBoard) {
      scoreBoard.forEach((userID, userScoreMap) {
        ShortUserInfo userInfo = userScoreMap['userInfo'];
        list.add(ListTile(
          title: Text(userInfo.displayName),
          subtitle: userScoreMap['score'],
        ));
      });
    }).then((val) {
      setState(() {
        _scoreBoardWidget = list;
      });
    });
  }

  void _showAddMemberDialog() async {
    TextEditingController _emailController = new TextEditingController();

    DoItDialogs.showUserInputDialog(
      context: context,
      inputWidgets: [
        DoItTextField(
          controller: _emailController,
          label: 'Email',
          textInputType: TextInputType.emailAddress,
          isRequired: true,
        ),
      ],
      title: 'Add Member',
      onSubmit: () async {
        await app.groupsManager
            .addMember(groupID: widget.groupInfo.groupID, newMemberEmail: _emailController.text)
            .then((newMember) {
          setState(() {
            _groupMembers.putIfAbsent(newMember.userID, () => newMember);
          });
        });
      },
    );
/*    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Center(child: Text('Add Member')),
            children: <Widget>[
              DoItTextField(
                controller: _emailController,
                label: 'Email',
                textInputType: TextInputType.emailAddress,
                isRequired: true,
              ),
              RaisedButton(
                onPressed: () async {
                  await app.groupsManager
                      .addMember(
                    groupID: widget.groupInfo.groupID,
                    newMemberEmail: _emailController.text,
                  )
                      .then((newMember) {
                    setState(() {
                      _groupMembers.putIfAbsent(newMember.userID, () => newMember);
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              )
            ],
          );
        });*/
  }
}
