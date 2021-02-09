import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'NewCameraQr.dart';

class NewCameraScreenBody extends StatefulWidget {
  NewCameraScreenBody({Key key}) : super(key: key);

  @override
  _NewCameraScreenBodyState createState() => _NewCameraScreenBodyState();
}

class _NewCameraScreenBodyState extends State<NewCameraScreenBody> {
  static const animationDuration = Duration(milliseconds: 300);

  bool isFirstPage = true;
  String cameraName;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageTransitionSwitcher(
            duration: animationDuration,
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                SharedAxisTransition(
                  child: child,
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                ),
            reverse: isFirstPage,
            child: isFirstPage ? firstPage() : secondPage()),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ElevatedButton(
              child: isFirstPage ? Text("NEXT") : Text("FINISH"),
              onPressed: () {
                if (isFirstPage) {
                  formKey.currentState.save();
                  setState(() {
                    isFirstPage = !isFirstPage;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget firstPage() => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Camera Name",
                border: OutlineInputBorder(),
              ),
              onSaved: (newValue) => cameraName = newValue,
            ),
          ),
        ),
      );
  Widget secondPage() => NewCameraQr(cameraName: cameraName);
}
