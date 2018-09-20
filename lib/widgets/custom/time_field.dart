import 'dart:async';

import 'package:do_it/app.dart';
import 'package:flutter/material.dart';

class DoItTimeField extends StatefulWidget {
  final String label;
  final Function onDateTimeUpdated;
  final DateTime initDateTime;
  final bool enabled;
  final Function validator;
  final String validationMessage;

  static String formatDateTime(DateTime dateTime) {
    return dateTime == null
        ? "Time not set"
        : '${dateTime.day}/${dateTime.month}/${dateTime.year} - '
        '${dateTime.hour > 9 ? dateTime.hour : '0${dateTime.hour}'}:'
        '${dateTime.minute > 9 ? dateTime.minute : '0${dateTime.minute}'}';
  }

  DoItTimeField({
    @required this.onDateTimeUpdated,
    this.initDateTime,
    this.label,
    this.validator,
    this.validationMessage = "value is invalid",
    this.enabled = true,
  });

  @override
  DoItTimeFieldState createState() {
    return new DoItTimeFieldState();
  }
}

class DoItTimeFieldState extends State<DoItTimeField> {
  TextEditingController controller = new TextEditingController();
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initDateTime != null) {
      _selectedDate = widget.initDateTime;
      controller.text = _formatDateTime(_selectedDate);
    }
  }

  Future<DateTime> _setTime(BuildContext context) async {
    await _selectDate(context, widget.initDateTime).then((selectedDate) async {
      _selectedDate = selectedDate;
      await _selectTime(context, widget.initDateTime).then((selectedTime) {
        _selectedDate = _getSelectedDateTime(selectedDate, selectedTime);
        controller.text = _formatDateTime(_selectedDate);
      });
    });
    return _selectedDate;
  }

  Future<DateTime> _selectDate(BuildContext context, DateTime initDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initDate ?? DateTime.now(),
      firstDate: new DateTime(2017, 1),
      lastDate: new DateTime(2050),
    );
    return picked != null && picked != initDate ? picked : initDate;
  }

  Future<TimeOfDay> _selectTime(BuildContext context, DateTime initDate) async {
    TimeOfDay initTime = initDate != null ? TimeOfDay.fromDateTime(initDate) : TimeOfDay.now();
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: initTime);
    return picked != null && picked != initTime ? picked : initTime;
  }

  DateTime _getSelectedDateTime(DateTime selectedDate, TimeOfDay selectedTime) {
    if (selectedDate == null || selectedTime == null) {
      return null;
    } else {
      return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return dateTime == null
        ? "Time not set"
        : '${dateTime.day}/${dateTime.month}/${dateTime.year} - '
        '${dateTime.hour > 9 ? dateTime.hour : '0${dateTime.hour}'}:'
        '${dateTime.minute > 9 ? dateTime.minute : '0${dateTime.minute}'}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: controller,
                        enabled: false,
                        validator: (String ignoredString) {
                          if (widget.validator != null &&
                              !widget.validator(_selectedDate)) {
                            return widget.validationMessage;
                          }
                        },
//                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: widget.label,
                          labelStyle: TextStyle(height: 1.7),
                          filled: true,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        child: ButtonTheme(
                          height: 60.0,
                          minWidth: 20.0,
                          child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(16.0),
                              )),
                              color: widget.enabled
                                  ? App.instance.themeData.primaryColorLight
                                  : Theme.of(context).disabledColor.withAlpha(35),
                              child: Icon(Icons.date_range,
                                color: widget.enabled
                                    ? Colors.black
                                    : Theme.of(context).disabledColor.withAlpha(100)),
                              onPressed: () {
                                if (widget.enabled) {
                                  _setTime(context).then((selectedDateTime) {
                                    widget.onDateTimeUpdated(selectedDateTime);
                                  });
                                }
                              }),
                        ),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
