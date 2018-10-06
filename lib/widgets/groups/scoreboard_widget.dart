import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/timespan_selector.dart';
import 'package:flutter/material.dart';

class ScoreBoard extends StatefulWidget {
  final ShortGroupInfo groupInfo;

  ScoreBoard(this.groupInfo);

  @override
  ScoreBoardState createState() => new ScoreBoardState();
}

class ScoreBoardState extends State<ScoreBoard> {
  final App app = App.instance;
  int numDaysSelected = -1;
  TimeSpanSelector _timeSpanSelector;
  List<Widget> _scoreBoardBody = [Text(App.instance.strings.fetchingScoreboard)];

  @override
  void initState() {
    super.initState();
    _timeSpanSelector = TimeSpanSelector(
      onTimeSelectionChanged: (value) {
        setState(() {
          numDaysSelected = value;
          getScoreBoard();
        });
      },
      timeSpans: {
        1: app.strings.today,
        7: app.strings.thisWeek,
        31: app.strings.thisMonth,
        0: app.strings.allTime,
      },
    );
    getScoreBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _scoreBoardBody);
  }

  getScoreBoard() {
    int index = 1;
    List<Widget> list = new List();
    list.add(_timeSpanSelector);
    if (numDaysSelected == -1) {
      list.add(Text(app.strings.selectTimeSpanPrompt));
      setState(() => _scoreBoardBody = list);
    } else {
      DateTime fromDate = _calculateFromDate();
      app.groupsManager.getGroupScoreboard(groupID: widget.groupInfo.groupID, fromDate: fromDate).then((scoreBoard) {
        List scoreBoardAsList = List.from(scoreBoard.values);
        scoreBoardAsList.sort((item1, item2) => item2['score'] - item1['score']);
        scoreBoardAsList.forEach((scoreboardItem) {
          list.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Text('${index.toString()})'),
                    Expanded(
                        child: Text(
                      '  ${scoreboardItem['userInfo'].displayName}',
                      overflow: TextOverflow.ellipsis,
                    )),
                    Text(scoreboardItem['score'].toString()),
                  ],
                ),
              ),
            ),
          ));
          index++;
        });
      }).whenComplete(() {
        setState(() => _scoreBoardBody = list);
      }).catchError((error) {
        DoItDialogs.showErrorDialog(
          context: context,
          message: '${app.strings.scoreBoardFetchErrMsg}${error.message}',
        );
      });
    }
  }

  DateTime _calculateFromDate() {
    int thisYear = DateTime.now().year;
    int thisMonth = DateTime.now().month;
    int thisDay = DateTime.now().day;
    int thisStartOfWeek = DateTime.now().day - DateTime.now().weekday;
    switch (numDaysSelected) {
      case 0:
        return null;
      case 1:
        return new DateTime(thisYear, thisMonth, thisDay);
      case 7:
        return new DateTime(thisYear, thisMonth, thisStartOfWeek);
      case 30:
      case 31:
        return new DateTime(thisYear, thisMonth);
      case 365:
        return new DateTime(thisYear);
      default:
        return DateTime.now().add(Duration(days: -numDaysSelected));
    }
  }
}
