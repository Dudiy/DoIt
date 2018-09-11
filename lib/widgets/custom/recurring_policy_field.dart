import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:flutter/material.dart';

class DoItRecurringPolicyField extends StatefulWidget {
  final Function onPolicyUpdated;
  final eRecurringPolicy initPolicy;
  final bool enabled;

  DoItRecurringPolicyField({
    @required this.onPolicyUpdated,
    this.initPolicy,
    this.enabled = true,
  });

  @override
  DoItRecurringPolicyFieldState createState() {
    return new DoItRecurringPolicyFieldState();
  }
}

class DoItRecurringPolicyFieldState extends State<DoItRecurringPolicyField> {
  eRecurringPolicy selectedPolicy = eRecurringPolicy.none;

  @override
  void initState() {
    super.initState();
    if (widget.initPolicy != null) {
      selectedPolicy = widget.initPolicy;
    }
  }

  @override
  Widget build(BuildContext context) {
    var selector = widget.enabled
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButton(
              value: selectedPolicy,
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
                if (widget.enabled) {
                  setState(() {
                    selectedPolicy = selected;
                  });
                  widget.onPolicyUpdated(selected);
                }
              },
            ),
          )
        : DoItTextField(
            label: 'Repeat',
            textAlign: TextAlign.center,
            enabled: false,
            initValue: RecurringPolicyUtils.policyToString(selectedPolicy),
          );
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: <Widget>[
          Text('Repeat: '),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: selector,
          ),
        ],
      ),
    );
  }
}
