import 'package:flutter/material.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class LoadingCustom {
  startLoading(BuildContext context) async {
    OverlayLoadingProgress.start(
      context,
      widget: const SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.amber,
            ),
          )),
    );
  }

  stopLoading(){
    OverlayLoadingProgress.stop();
  }
}