import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/imageContainer.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/custom/vertical_divider.dart';
import 'package:do_it/widgets/groups/single_group_page.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final ShortGroupInfo shortGroupInfo;
  final Function onTapped;
  final app = App.instance;
  final LoadingOverlay loadingOverlay = new LoadingOverlay();

  GroupCard({
    @required this.shortGroupInfo,
    this.onTapped,
  }) {
    assert(shortGroupInfo != null);
  }

  @override
  Widget build(BuildContext context) {
    bool cardClicked = false;
    Container managerIcon = app.loggedInUser.userID == shortGroupInfo.managerID
        ? Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Icons.supervisor_account,
                size: 15.0,
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
        highlightColor: app.themeData.primaryColorLight,
        color: app.themeData.primaryColorLight.withAlpha(200),
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          if (!cardClicked) {
            cardClicked = true;
            _groupCardClicked(context);
          }
        },
        child: Row(
          children: <Widget>[
            //Picture,
            ImageContainer(imagePath: shortGroupInfo.photoUrl, size: 80.0),
            SizedBox(width: 8.0),
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
                      Text('${app.strings.members}: ${shortGroupInfo.members.length.toString()}'),
                      VerticalDivider(),
                      Text(
                          '${app.strings.tasks}: ${shortGroupInfo.tasksPerUser[app.getLoggedInUser().userID].toString()}'),
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
                    tooltip: app.strings.scoreboard,
                    icon: Image.asset(
                      PODIUM_ICON,
                      height: 35.0,
                    ),
                    onPressed: () {
                      DoItDialogs.showGroupScoreboardDialog(context: context, groupInfo: shortGroupInfo);
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

  void _groupCardClicked(BuildContext context) {
    loadingOverlay.show(context: context, message: app.strings.loadingGroupPage);
    app.groupsManager.getGroupInfoByID(shortGroupInfo.groupID).then((groupInfo) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SingleGroupPage(groupInfo), settings: RouteSettings(name: '/singleGroupPage')));
      loadingOverlay.hide();
    }).catchError((error) {
      DoItDialogs.showErrorDialog(
        context: context,
        message: '${app.strings.getGroupInfoErrMsg}${error.message}',
      );
      loadingOverlay.hide();
      print(error.message);
    });
  }
}
