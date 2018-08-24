import 'package:do_it/app.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/groups/scoreboard_widget.dart';
import 'package:flutter/material.dart';

class TaskDetailsPage extends StatefulWidget {
  final TaskInfo taskInfo;
  final Function onGroupInfoChanged;
  TaskDetailsPage(this.taskInfo, this.onGroupInfoChanged);

  @override
  TaskDetailsPageState createState() => new TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  final App app = App.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskIDController = new TextEditingController();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _valueController = new TextEditingController();
  final TextEditingController _startTimeController = new TextEditingController();
  final TextEditingController _endTimeController = new TextEditingController();

  bool editEnabled;
  List<StatelessWidget> _scoreBoardWidget;

  @override
  void initState() {
    editEnabled = app.loggedInUser.userID == widget.taskInfo.parentGroupManagerID;
    _taskIDController.text = widget.taskInfo.taskID;
    _titleController.text = widget.taskInfo.title;
    _descriptionController.text = widget.taskInfo.description;
    _valueController.text = widget.taskInfo.value.toString();
    _startTimeController.text = widget.taskInfo.startTime.toString();
    _endTimeController.text = widget.taskInfo.endTime.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task \"${widget.taskInfo.title}\" details'),
        actions: drawActions(),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Form(
                key: _formKey,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  DoItTextField(label: 'Task ID', enabled: false),
                  DoItTextField(
                    controller: _titleController,
                    label: 'Title',
                    enabled: editEnabled,
                  ),
                  DoItTextField(controller: _descriptionController, label: 'Description', enabled: editEnabled),
                  DoItTextField(
                    controller: _valueController,
                    label: 'Value',
                    enabled: false,
                    textInputType: TextInputType.numberWithOptions(),
                  ),
                  //TODO add date pickers
                  DoItTextField(controller: _startTimeController, label: 'Start time', enabled: editEnabled,),
                  DoItTextField(controller: _endTimeController, label: 'End time', enabled: editEnabled),
                ])),
          ),
          Column(
            children: getAssignedUsers(),
          ),
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
          await app.tasksManager
              .updateTask(
            taskIdToChange: widget.taskInfo.taskID,
            title: _titleController.text.isNotEmpty ? _titleController.text : null,
            description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
            value: _valueController.text.isNotEmpty ? int.parse(_valueController.text) : null,
            startTime: _startTimeController.text.isNotEmpty ? DateTime.parse(_valueController.text) : null,
            endTime: _endTimeController.text.isNotEmpty ? DateTime.parse(_valueController.text) : null,
            // TODO add recurring policy
          )
              .then((newGroupInfo) {
                // TODO check if we need this
//            widget.onTaskInfoChanged(newGroupInfo);
          });
          Navigator.pop(context);
        },
      ));
    return actions;
  }

  List<Widget> getAssignedUsers() {
    List<StatelessWidget> list = new List();
    list.add(Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          'Assigned users',
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
}
