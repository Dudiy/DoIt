import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/widgets/custom/text_field.dart';
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
  TextEditingController _startTimeController = new TextEditingController();
  TextEditingController _endTimeController = new TextEditingController();
  eRecurringPolicy _selectedPolicy = eRecurringPolicy.none;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: Text('Add Task', style: Theme.of(context).textTheme.title,)),
        ),
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
        DoItTextField(
          controller: _startTimeController,
          label: 'Starting time',
          isRequired: false,
          keyboardType: TextInputType.datetime,
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
        RaisedButton(
          child: const Text('Submit', style: TextStyle(color: Colors.white)),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            TaskInfo taskInfo = new TaskInfo(
              title: _titleController.text,
              description: _descriptionController.text,
              value: int.parse(_valueController.text),
              startTime: _startTimeController.text.isNotEmpty ? DateTime.parse(_startTimeController.text) : null,
              endTime: _endTimeController.text.isNotEmpty ? DateTime.parse(_endTimeController.text) : null,
              assignedUsers: null,
              recurringPolicy: _selectedPolicy, // TODO change to input!
              // these fields are ignored in the callback function
              taskID: "",
              parentGroupID: "",
              parentGroupManagerID: "",
            );
            widget._onSelectionSubmitted(taskInfo);
          },
        )
      ],
    );
  }
}
