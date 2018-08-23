import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:flutter/material.dart';

class ScoreBoard extends StatefulWidget {
  final GroupInfo groupInfo;
  ScoreBoard(this.groupInfo);

  @override
  ScoreBoardState createState() => new ScoreBoardState();
}

class ScoreBoardState extends State<ScoreBoard> {
  final App app = App.instance;

  List<Widget> _scoreBoardBody = [Text('fetchig score board from DB...')];

  @override
  void initState() {
    super.initState();
    getScoreBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _scoreBoardBody);/*[
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
      ,
    ]);*/
  }

  getScoreBoard() {
    List<StatelessWidget> list = new List();
    app.groupsManager.getGroupScoreboards(groupID: widget.groupInfo.groupID).then((scoreBoard) {
      scoreBoard.forEach((userID, userScoreMap) {
        ShortUserInfo userInfo = userScoreMap['userInfo'];
        list.add(ListTile(
          title: Text(userInfo.displayName),
          subtitle: Text(userScoreMap['score'].toString()),
        ));
      });
    }).then((val) {
      setState(() {
        _scoreBoardBody = list;
      });
    });
  }
}
