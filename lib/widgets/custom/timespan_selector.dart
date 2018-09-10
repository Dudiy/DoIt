import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeSpanSelector extends StatelessWidget {
  final Function onTimeSelectionChanged;
  final Map<String, int> timeSpans;
  TimeSpanSelector({
    this.onTimeSelectionChanged,
    this.timeSpans,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _createTimeSpanSelectors(),
    );
  }

  Widget _timeSpanSelector(String label, int numDays) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 6.0),
        child: RaisedButton(
          child: Text(label),
          onPressed: () {
            onTimeSelectionChanged(numDays);
          },
        ),
      ),
    );
  }

  List<Widget> _createTimeSpanSelectors() {
    List<Widget> list = new List();
    timeSpans.forEach((label, numDays){
      list.add(_timeSpanSelector(label, numDays));
    });
    return list;
  }
}
