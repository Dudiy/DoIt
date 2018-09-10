import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
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
                size: 20.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        : Container(height: 0.0, width: 0.0);
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      margin: EdgeInsets.all(8.0),
      child: RaisedButton(
        highlightColor: Theme.of(context).primaryColorLight,
        color: Colors.white,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      managerIcon,
                      Text('${shortGroupInfo.title}',
                          style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold))
                    ],
                  ),
                  Divider(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
              child: IconButton(
                tooltip: 'Group scoreboard',
                icon: Image.asset(
                  'assets/images/podium.png',
                  height: 35.0,
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
