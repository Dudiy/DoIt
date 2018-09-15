import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeSpanSelector extends StatefulWidget {
  final Function onTimeSelectionChanged;
  final Map<int, String> timeSpans;

  TimeSpanSelector({
    this.onTimeSelectionChanged,
    this.timeSpans,
  }){
    timeSpans.putIfAbsent(-1, () => 'please select');
  }

  @override
  TimeSpanSelectorState createState() {
    return new TimeSpanSelectorState(timeSpans);
  }
}

class TimeSpanSelectorState extends State<TimeSpanSelector> {
  int numDaysSelected;
  Map<int, String> timeSpans;

  TimeSpanSelectorState(this.timeSpans);

  @override
  void initState() {
    super.initState();
    numDaysSelected = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white70,
        ),
        alignment: Alignment.center,
        child: _createTimeSpanSelectors(),
      ),
    );
  }

  DropdownMenuItem _timeSpanSelector(int numDays) {
    return DropdownMenuItem(
      value: numDays,
      child: Text(
        timeSpans[numDays],
        textAlign: TextAlign.center,
      ),
    );
  }

  DropdownButton _createTimeSpanSelectors() {
    return DropdownButton(
      value: numDaysSelected,
      items: timeSpans.keys.map((numDays) {
        return _timeSpanSelector(numDays);
      }).toList(),
      onChanged: (selected) {
        setState(() {
          timeSpans.remove(-1);
          numDaysSelected = selected;
        });
        widget.onTimeSelectionChanged(numDaysSelected);
      },
    );
  }
}
