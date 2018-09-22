import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/imageContainer.dart';
import 'package:do_it/widgets/custom/vertical_divider.dart';
import 'package:do_it/widgets/groups/single_group_page.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final ShortGroupInfo shortGroupInfo;
  final Function onTapped;

  GroupCard({
    @required this.shortGroupInfo,
    this.onTapped,
  }) {
    assert(shortGroupInfo != null);
  }

  @override
  Widget build(BuildContext context) {
    Container managerIcon = App.instance.loggedInUser.userID == shortGroupInfo.managerID
        ? Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.supervisor_account,
                size: 15.0,
                color: App.instance.themeData.primaryColor,
              ),
            ),
          )
        : Container(height: 0.0, width: 0.0);
    return Card(
      color: Colors.transparent,
      elevation: 5.0,
      margin: EdgeInsets.all(8.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        highlightColor: App.instance.themeData.primaryColorLight,
        color: App.instance.themeData.primaryColorLight.withAlpha(200),
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          App.instance.groupsManager.getGroupInfoByID(shortGroupInfo.groupID).then((groupInfo) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SingleGroupPage(groupInfo), settings: RouteSettings(name: '/singleGroupPage')));
          });
        },
        child: Row(
          children: <Widget>[
            //Picture,
            Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ImageContainer(imagePath: shortGroupInfo.photoUrl, size: 80.0)),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text('${shortGroupInfo.title}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold)),
                  Divider(
                    height: 15.0,
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      Text('Members: ${shortGroupInfo.members.length.toString()}'),
                      VerticalDivider(),
                      Text('Tasks: ${shortGroupInfo.tasksPerUser[App.instance.getLoggedInUser().userID].toString()}'),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: <Widget>[
                  managerIcon,
                  IconButton(
                    tooltip: 'Group scoreboard',
                    icon: Image.asset(
                      'assets/icons_and_buttons/podium.png',
                      height: 35.0,
                    ),
                    onPressed: () {
                      DoItDialogs.showGroupScoreboardDialog(context: context, groupInfo: shortGroupInfo);
//                  _showGroupScoreboardDialog(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
