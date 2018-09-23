import 'dart:io';

import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/imageContainer.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/custom/text_field.dart';
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
  final TextEditingController _groupIDController = new TextEditingController();
  final TextEditingController _managerDisplayNameController = new TextEditingController();
  LoadingOverlay loadingOverlay = new LoadingOverlay();
  File uploadedImageFile;
  Map<String, ShortUserInfo> _groupMembers;
  bool editEnabled;

  @override
  void initState() {
    editEnabled = app.loggedInUser.userID == widget.groupInfo.managerID;
    _groupIDController.text = widget.groupInfo.groupID;
    _managerDisplayNameController.text = widget.groupManager.displayName;
    _titleController.text = widget.groupInfo.title;
    _descriptionController.text = widget.groupInfo.description;
    _groupMembers = widget.groupInfo.members;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: App.instance.themeData.primaryColor,
        title: Text(
          '${widget.groupInfo.title} details',
          maxLines: 2,
        ),
        titleSpacing: 5.0,
        actions: drawActions(),
      ),
      body: Container(
        decoration: app.getBackgroundImage(),
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Card(
              color: app.themeData.primaryColorLight.withAlpha(200),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: Row(
                children: <Widget>[
                  _groupImage(),
                  _groupManagerAndID(context),
                ],
              ),
            ),
            _editableDetails(),
            _groupMembersDisplay(),
          ],
        ),
      ),
    );
  }

  List<Widget> drawActions() {
    double podiumPadding = editEnabled ? 10.0 : 20.0;
    List<Widget> actions = new List();
    actions.add(GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: podiumPadding, vertical: 10.0),
        child: Image.asset(
          PODIUM_ICON,
          color: Colors.white,
          height: 25.0,
          width: 25.0,
        ),
      ),
      onTap: () {
        DoItDialogs.showGroupScoreboardDialog(context: context, groupInfo: widget.groupInfo.getShortGroupInfo());
      },
    ));
    if (editEnabled)
      actions.add(GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Icon(Icons.save, color: Colors.white),
        ),
        onTap: () async {
          await app.groupsManager
              .updateGroupInfo(
            groupIdToChange: widget.groupInfo.groupID,
            title: _titleController.text.isNotEmpty ? _titleController.text : null,
            description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
            photoUrl: widget.groupInfo.photoUrl,
          )
              .then((newGroupInfo) {
            widget.onGroupInfoChanged(newGroupInfo, uploadedImageFile);
          });
          Navigator.pop(context);
        },
      ));
    return actions;
  }

  List<Widget> getAllMembers() {
    Widget addMemberIcon = widget.groupInfo.managerID == app.loggedInUser.userID
        ? IconButton(
            icon: Icon(Icons.group_add),
            onPressed: () {
              _showAddMemberDialog();
            })
        : Container(width: 0.0, height: 0.0);

    List<Widget> list = new List();
    list.add(Container(
//      color: Theme.of(context).primaryColorLight,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        ),
        color: app.themeData.primaryColorLight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Center(
                child: Text(
              'Group Members',
              style: Theme.of(context).textTheme.subhead.copyWith(decoration: TextDecoration.underline),
            )),
            Positioned(right: 10.0, top: -11.0, child: addMemberIcon),
          ],
        ),
      ),
    ));
    list.addAll(widget.groupInfo.members == null || widget.groupInfo.members.length == 0
        ? [Text('The group has no members...')]
        : widget.groupInfo.members.values.map((shortUserInfo) {
            return _singleMemberDisplay(shortUserInfo);
          }).toList());
    return list;
  }

  void _showAddMemberDialog() async {
    TextEditingController _emailController = new TextEditingController();

    DoItDialogs.showUserInputDialog(
      context: context,
      inputWidgets: [
        DoItTextField(
          controller: _emailController,
          label: 'Email',
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
        ),
      ],
      title: 'Add Member',
      onSubmit: () async {
        bool closeDialog = true;
        await app.groupsManager
            .addMember(groupID: widget.groupInfo.groupID, newMemberEmail: _emailController.text)
            .then((newMember) async {
          app.notifier.sendNotifications(
            title: 'Group \"${widget.groupInfo.title}\"',
            body: 'You have been added to this group by ${widget.groupManager.displayName}',
            destUsersFcmTokens: [await App.instance.usersManager.getFcmToken(newMember.userID)],
          );
          setState(() {
            _groupMembers.putIfAbsent(newMember.userID, () => newMember);
          });
        }).catchError((err) {
          print(err);
          DoItDialogs.showErrorDialog(
              context: context,
              message:
                  'No user is registered with the email: ${_emailController.text} \n\n** email addresses are case sensitive **');
          closeDialog = false;
        });
        if (closeDialog) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _groupImage() {
    const double GROUP_IMAGE_SIZE = 100.0;
    var editImageText = <Widget>[
      Expanded(
        child: Container(),
      ),
      Container(
        width: GROUP_IMAGE_SIZE - 2,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
          color: Colors.black54,
        ),
        child: Text(
          'tap to change',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13.0),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (editEnabled) {
              App.instance.groupsManager
                  .uploadGroupPic(
                      widget.groupInfo, () => loadingOverlay.show(context: context, message: "Updating group photo"))
                  .then((uploadedPhoto) {
                setState(() {
                  uploadedImageFile = uploadedPhoto;
                });
                loadingOverlay.hide();
              }).catchError((e){
                loadingOverlay.hide();
                DoItDialogs.showErrorDialog(
                    context: context, message: "Error while uploading group photo:\n${e.message}");
              });
          }
        },
        child: Stack(
          children: <Widget>[
            ImageContainer(
              size: GROUP_IMAGE_SIZE,
              imagePath: widget.groupInfo.photoUrl,
              imageFile: uploadedImageFile,
            ),
            Container(
              height: GROUP_IMAGE_SIZE,
              width: GROUP_IMAGE_SIZE,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisSize: MainAxisSize.max,
                children: editImageText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupManagerAndID(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _groupManager(context),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Group ID: ',
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  '${widget.groupInfo.groupID}',
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupManager(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          'Group manager:\n ${widget.groupManager.displayName}',
          style: Theme.of(context).textTheme.caption,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _editableDetails() {
    return Container(
      child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            DoItTextField(
              controller: _titleController,
              label: 'Group title',
              enabled: editEnabled,
              maxLength: 15,
            ),
            DoItTextField(
              controller: _descriptionController,
              label: 'Description',
              enabled: editEnabled,
              maxLines: 3,
            ),
          ])),
    );
  }

  Widget _groupMembersDisplay() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white70,
        ),
        child: Column(
          children: getAllMembers(),
        ),
      ),
    );
  }

  Widget _singleMemberDisplay(ShortUserInfo shortUserInfo) {
    var removeIcon = (editEnabled && shortUserInfo.userID != widget.groupManager.userID)
        ? Container(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.red,
                size: 25.0,
              ),
              onTap: () {
                DoItDialogs.showConfirmDialog(
                  context: context,
                  message: "Are you sure you would like to remove ${shortUserInfo.displayName} from the group?",
                  actionButtonText: "Remove user",
                  isWarning: true,
                ).then((userConfirmed) {
                  if (userConfirmed) {
                    app.groupsManager.deleteUserFromGroup(widget.groupInfo.groupID, shortUserInfo.userID);
                    setState(() {
                      _groupMembers.remove(shortUserInfo.userID);
                    });
                  }
                });
              },
            ),
          )
        : Container(width: 0.0, height: 45.0);

    if (editEnabled) {}
    return Container(
      decoration: ShapeDecoration(shape: Border(top: BorderSide(style: BorderStyle.solid, color: Colors.black12))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            SizedBox(width: 15.0),
            Expanded(
              child: Text(
                '-  ${shortUserInfo.displayName}',
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            removeIcon,
          ],
        ),
      ),
    );
  }
}
