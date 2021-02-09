import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/CameraServerApiHelper.dart';
import '../components/errorSnackBar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CameraServerApiHelper cameraServerApiHelper =
      GetIt.instance<CameraServerApiHelper>();

  String baseUrl;
  String username;
  String password;

  bool shouldCreateNewUser = false;

  bool isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: "Base URL",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Base URL cannot be empty";
                    }
                    if (!value.startsWith("http://") &&
                        !value.startsWith("https://")) {
                      return "URL must start with http:// or https://";
                    }
                    if (value.endsWith("/")) {
                      return "URL must not include a trailing slash";
                    }
                    return null;
                  },
                  onSaved: (newValue) => baseUrl = newValue,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username"),
                        onSaved: (newValue) => username = newValue,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password"),
                        onSaved: (newValue) => password = newValue,
                      ),
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                value: shouldCreateNewUser,
                onChanged: (value) => setState(() {
                  shouldCreateNewUser = value;
                }),
                title: Text("Create new user"),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text("NEXT"),
              onPressed: isAuthenticating
                  ? null
                  : () async {
                      if (formKey.currentState.validate()) {
                        setState(() {
                          isAuthenticating = true;
                        });
                        formKey.currentState.save();
                        try {
                          await cameraServerApiHelper.login(
                              username, password, baseUrl, shouldCreateNewUser);
                          Navigator.of(context)
                              .pushReplacementNamed("/cameras");
                        } catch (error) {
                          errorSnackBar(error, context);
                        }
                      }
                      setState(() {
                        isAuthenticating = false;
                      });
                    },
            ),
          ),
        )
      ],
    );
  }
}
