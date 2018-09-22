import 'package:do_it/app.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:flutter/material.dart';

class UserSelector extends StatefulWidget {
  final Map<String, dynamic> _initialUsersState; // userID, {'userInfo', 'isSelectd'}
  final Function _onSelectionSubmitted;

  UserSelector(this._initialUsersState, this._onSelectionSubmitted);

  @override
  State<StatefulWidget> createState() {
    return UserSelectorState();
  }
}

class UserSelectorState extends State<UserSelector> {
  Map<String, dynamic> _updatedUsersState;

  @override
  void initState() {
    _updatedUsersState = Map.from(widget._initialUsersState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _numSelected = 0;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Select assigned members', style: Theme.of(context).textTheme.title),
        ),
        Divider(color: Colors.black),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: _updatedUsersState.values.map((user) {
              ShortUserInfo userInfo = user['userInfo'];
              bool isSelected = user['isSelected'];
              if (isSelected) {
                _numSelected++;
              }
              return Card(
                child: Row(
                  children: <Widget>[
                    Checkbox(
                        value: isSelected,
                        onChanged: (checked) {
                          if (!checked && _numSelected == 1) {
                            DoItDialogs.showErrorDialog(
                                context: context, message: "At least one user must be selected");
                          } else {
                            checked ? _numSelected++ : _numSelected--;
                            setState(() {
                              _updatedUsersState[userInfo.userID]['isSelected'] = checked;
                            });
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(userInfo.displayName),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Divider(color: Colors.black),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RaisedButton(
            child: Text('Update'),
            color: App.instance.themeData.primaryColor,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            onPressed: () {
              widget._onSelectionSubmitted(_updatedUsersState);
            },
          ),
        ),
      ],
    );
  }
}
