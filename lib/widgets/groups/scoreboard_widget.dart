import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:flutter/material.dart';

class ScoreBoard extends StatefulWidget {
  final ShortGroupInfo groupInfo;

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
    return Column(children: _scoreBoardBody);
  }

  getScoreBoard() {
    int index = 1;
    List<Widget> list = new List();
    app.groupsManager.getGroupScoreboard(groupID: widget.groupInfo.groupID).then((scoreBoard) {
      List test = List.from(scoreBoard.values);
      test.sort((item1, item2) => item2['score'] - item1['score']);
      print(test);
      test.forEach((scoreboardItem){
        list.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListTile(
            title: Row(
              children: <Widget>[
                Text('${index.toString()})'),
                Expanded(
                    child: Text(
                      '  ${scoreboardItem['userInfo'].displayName}',
//                  style: TextStyle(fontWeight: index < 4 ? FontWeight.bold : ""),
                    )),
                Text(scoreboardItem['score'].toString()),
              ],
            ),
//          subtitle: ,
          ),
        ));
        index++;
      });
    }).whenComplete(() {
      setState(() {
        _scoreBoardBody = list;
      });
    });
  }
}
