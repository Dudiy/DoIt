import 'package:do_it/data_classes/user/user_info_short.dart';
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
    return Column(
      children: <Widget>[
        Text('Select assigned users'),
        Expanded(
          child: ListView(
            children: _updatedUsersState.values.map((user) {
              ShortUserInfo userInfo = user['userInfo'];
              bool isSelected = user['isSelected'];
              return ListTile(
                title: Text(userInfo.displayName),
                trailing: Checkbox(
                    value: isSelected,
                    onChanged: (checked) {
                      setState(() {
                        _updatedUsersState[userInfo.userID]['isSelected'] = checked;
                      });
                    }),
              );
            }).toList(),
          ),
        ),
        RaisedButton(
          child: Text('Update'),
          onPressed: () {
            widget._onSelectionSubmitted(_updatedUsersState);
          },
        ),
      ],
    );
  }
}
