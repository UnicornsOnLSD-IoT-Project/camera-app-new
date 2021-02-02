import 'package:flutter/material.dart';

/// SnackBar with error icon for displaying errors
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorSnackBar(
    dynamic error, BuildContext context) {
  return Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text("An error has occurred."),
      action: SnackBarAction(
        label: "MORE",
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(error.toString()),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Close"),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
