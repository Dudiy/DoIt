import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  final App app = App.instance;
  OverlayState overlayState;
  OverlayEntry entry;

  void show({
    @required BuildContext context,
    String message,
  }) {
    overlayState = Overlay.of(context);
    entry = OverlayEntry(builder: (context) {
      return Directionality(
        textDirection: app.textDirection,
        child: Container(
          color: Colors.black87,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(LOADING_ANIMATION, height: 100.0, width: 100.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    message ?? app.strings.loading,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
    overlayState.insert(entry);
  }

  void hide() {
    entry?.remove();
    overlayState = null;
    entry = null;
  }
}
