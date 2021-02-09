import 'package:flutter/material.dart';

/// Text/icon that shows when the user has no cameras.
class NoCamerasMessage extends StatelessWidget {
  const NoCamerasMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This widget is way more complex than it has to be because RefreshIndicators need to be scrollable.
    // https://stackoverflow.com/a/62157637/8532605
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt,
                size: 48,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "No cameras yet! Use the button in the bottom right to add cameras.",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
