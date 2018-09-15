import 'package:flutter/material.dart';

class LoadingOverlay {
  OverlayState overlayState;
  OverlayEntry entry;

  void show({
    @required BuildContext context,
    String message = "Loading...",
  }) {
//    Navigator.of(context).push((MaterialPageRoute(builder: (context) => LoadingPage())))
    overlayState = Overlay.of(context);
    entry = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/doit_logo/loading_animation.gif', height: 100.0, width: 100.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    });
    overlayState.insert(entry);
  }

  void hide() {
    entry.remove();
    overlayState = null;
    entry = null;
  }
}
