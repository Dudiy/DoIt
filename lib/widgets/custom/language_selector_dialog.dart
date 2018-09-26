import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:do_it/constants/strings.dart';
import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final App app = App.instance;
  final VoidCallback onSelected;

  LanguageSelector([this.onSelected]);

  static Future<void> showAsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return LanguageSelector();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        app.strings.selectLanguageTitle,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
      children: app.strings.getSupportedLanguages().map((locale) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: app.themeData.dividerColor),
              bottom: BorderSide(color: app.themeData.dividerColor),
            ),
            color: Colors.white,
          ),
          child: ListTile(
            title: Text(Strings.localeToLanguageString(locale)),
            leading: Image.asset(
              FLAGS[locale.languageCode],
              width: 30.0,
            ),
            onTap: () {
              app.locale = locale;
              Navigator.pop(context);
              if (app.loggedInUser != null) {
                app.usersManager.updateLocale(locale.toString());
              }
              if (onSelected != null) {
                onSelected();
              }
            },
          ),
        );
      }).toList(),
    );
    /*Dialog(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                app.strings.selectLanguageTitle,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
            ),
            Expanded(
              child: ListView(
                children: app.strings.getSupportedLanguages().map((locale) {
                  return ListTile(
                    title: Text(Strings.localeToLanguageString(locale)),
                    leading: Image.asset(FLAGS[locale.languageCode], width: 30.0,),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );*/
  }
}
