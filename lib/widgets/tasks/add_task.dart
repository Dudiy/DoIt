import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/custom/time_field.dart';
import 'package:flutter/material.dart';

class AddTaskDialogBody extends StatefulWidget {
  final Function _onSelectionSubmitted;

  AddTaskDialogBody(this._onSelectionSubmitted);

  @override
  State<StatefulWidget> createState() {
    return AddTaskDialogBodyState();
  }
}

class AddTaskDialogBodyState extends State<AddTaskDialogBody> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _valueController = new TextEditingController();
  eRecurringPolicy _selectedPolicy = eRecurringPolicy.none;
  DateTime _selectedStartTime, _selectedEndTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Text(
              'Add Task',
              style: Theme.of(context).textTheme.title,
            )),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                DoItTextField(
                  controller: _titleController,
                  label: 'Title',
                  isRequired: true,
                ),
                DoItTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  isRequired: false,
                ),
                DoItTextField(
                  controller: _valueController,
                  isRequired: true,
                  label: 'Task value',
                  keyboardType: TextInputType.numberWithOptions(),
                ),
                DoItTimeField(
                  label: 'Start time',
                  onDateTimeUpdated: (selectedDateTime) {
                    print('dateTime selected: $selectedDateTime}'); // TODO delete print
                    setState(() {
                      _selectedStartTime = selectedDateTime;
                    });
                  },
                ),
                DoItTimeField(
                  label: 'End time',
                  onDateTimeUpdated: (selectedDateTime) {
                    print('dateTime selected: $selectedDateTime}'); // TODO delete print
                    setState(() {
                      _selectedEndTime = selectedDateTime;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    alignment: Alignment.center,
                    child: DropdownButton(
                      value: _selectedPolicy,
                      items: eRecurringPolicy.values.map((policy) {
                        return DropdownMenuItem(
                          value: policy,
                          child: Text(
                            RecurringPolicyUtils.policyToString(policy),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                      onChanged: (selected) {
                        setState(() {
                          _selectedPolicy = selected;
                        });
                      },
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RaisedButton(
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                TaskInfo taskInfo = new TaskInfo(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  value: int.parse(_valueController.text),
                  startTime: _selectedStartTime,
                  endTime: _selectedEndTime,
                  assignedUsers: null,
                  recurringPolicy: _selectedPolicy,
                  // TODO change to input!
                  // these fields are ignored in the callback function
                  taskID: "",
                  parentGroupID: "",
                  parentGroupManagerID: "",
                );
                widget._onSelectionSubmitted(taskInfo);
              },
            ),
          )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
