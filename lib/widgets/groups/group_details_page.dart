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
    return Directionality(
      textDirection: app.textDirection,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: app.themeData.primaryColor,
            title: Text(
              '${widget.groupInfo.title}',
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
            Navigator.pop(context);
          }).catchError((error) {
            DoItDialogs.showErrorDialog(
              context: context,
              message: '${app.strings.editGroupInfoErrMsg}${error.message}',
            );
          });
        },
      ));
    return actions;
  }

  List<Widget> getAllMembers() {
    Widget addMemberIcon = widget.groupInfo.managerID == app.loggedInUser.userID
        ? IconButton(
            icon: Icon(Icons.group_add),
            onPressed: () {
              DoItDialogs.showAddMemberDialog(
                  context: context,
                  groupInfo: widget.groupInfo,
                  onDialogSubmitted: (newMember) {
                    setState(() {
                      _groupMembers.putIfAbsent(newMember.userID, () => newMember);
                    });
                  });
            })
        : Container(width: 0.0, height: 0.0);

    bool isRtl = app.textDirection == TextDirection.rtl;
    List<Widget> list = new List();
    list.add(Container(
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
              app.strings.groupMembers,
              style: Theme.of(context).textTheme.subhead.copyWith(decoration: TextDecoration.underline),
            )),
            Positioned(
              right: !isRtl ? 10.0 : null,
              left: isRtl ? 10.0 : null,
              top: -11.0,
              child: addMemberIcon,
            ),
          ],
        ),
      ),
    ));
    list.addAll(widget.groupInfo.members == null || widget.groupInfo.members.length == 0
        ? [Text(app.strings.groupHasNoMembers)]
        : widget.groupInfo.members.values.map((shortUserInfo) {
            return _singleMemberDisplay(shortUserInfo);
          }).toList());
    return list;
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
          app.strings.tapToChange,
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
            app.groupsManager
                .uploadGroupPic(widget.groupInfo,
                    () => loadingOverlay.show(context: context, message: app.strings.uploadingImage))
                .then((uploadedPhoto) {
              setState(() {
                uploadedImageFile = uploadedPhoto;
              });
              loadingOverlay.hide();
            }).catchError((e) {
              loadingOverlay.hide();
              DoItDialogs.showErrorDialog(
                  context: context, message: '${app.strings.uploadPhotoErrMsg}${e.message}');
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
                  '${app.strings.groupId}: ',
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
          '${app.strings.groupManager}:\n ${widget.groupManager.displayName}',
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
              label: app.strings.groupTitleLabel,
              enabled: editEnabled,
              maxLength: 15,
            ),
            DoItTextField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              label: app.strings.descriptionLabel,
              enabled: editEnabled,
              maxLength: 512,
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
                  message: '${app.strings.confirmRemove} ${shortUserInfo.displayName} ${app.strings.fromTheGroup}?',
                  actionButtonText: app.strings.removeMemberLabel,
                  isWarning: true,
                ).then((userConfirmed) {
                  if (userConfirmed) {
                    loadingOverlay.show(context: context, message: app.strings.removingGroupMember);
                    app.groupsManager.deleteUserFromGroup(widget.groupInfo.groupID, shortUserInfo.userID).then((v) {
                      loadingOverlay.hide();
                      setState(() {
                        _groupMembers.remove(shortUserInfo.userID);
                      });
                    }).catchError((error) {
                      loadingOverlay.hide();
                      DoItDialogs.showErrorDialog(
                        context: context,
                        message: '${app.strings.removeMemberFromGroupErrMsg}${error.message}',
                      );
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
