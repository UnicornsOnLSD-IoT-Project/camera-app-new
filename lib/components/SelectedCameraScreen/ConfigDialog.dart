import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/CameraServerApiHelper.dart';
import '../../models/CameraServerApiModels.dart';
import '../errorSnackBar.dart';

class ConfigDialog extends StatefulWidget {
  ConfigDialog({Key key, @required this.cameraId}) : super(key: key);

  final String cameraId;

  @override
  _ConfigDialogState createState() => _ConfigDialogState();
}

class _ConfigDialogState extends State<ConfigDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CameraServerApiHelper cameraServerApiHelper =
      GetIt.instance<CameraServerApiHelper>();
  Future<CameraConfig> configDialogFuture;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    configDialogFuture = cameraServerApiHelper.getConfig(widget.cameraId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Config"),
      content: FutureBuilder<CameraConfig>(
        future: configDialogFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _controller.text = snapshot.data.interval.toString();
            return Form(
              key: formKey,
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Interval (in minutes)"),
                textAlign: TextAlign.center,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Required";
                  }

                  if (int.tryParse(value) == null) {
                    return "Invalid input";
                  }

                  if (int.parse(value) > 32767) {
                    return "Max interval is 32767";
                  }
                  return null;
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      actions: [
        TextButton(
          child: Text("CANCEL"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text("UPDATE"),
          onPressed: () async {
            if (formKey.currentState.validate()) {
              try {
                await cameraServerApiHelper.updateConfig(
                    widget.cameraId,
                    CameraConfig(
                      cameraId: widget.cameraId,
                      interval: int.parse(_controller.text),
                    ));
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Config updated")));
              } catch (e) {
                errorSnackBar(e, context);
              }
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}
