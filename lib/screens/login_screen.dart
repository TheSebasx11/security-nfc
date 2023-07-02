import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/components/index.dart';
import 'package:security_test/providers/user_service.dart';
import 'package:security_test/screens/register_view.dart';
import 'package:security_test/screens/screens.dart';
import 'package:security_test/shared/role_enum.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<TextEditingController> controllers = [
    for (int i = 0; i < 2; i++) TextEditingController()
  ];

  bool remember = false;
  bool visiblePass = false;

  Widget getView(String key) {
    Map views = const {
      "usuario": MainUserScreen(),
      "doctor": ScanNFCScreen(),
      "nfc": WriteNFCView(),
      "default": LoginScreen(),
    };
    return views[key] ?? views["default"];
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child: SizedBox(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }

  Future<Map> getCredentials(userServices) async {
    return await userServices.getMapFromLocalStorage("credentials");
  }

  @override
  Widget build(BuildContext context) {
    UserServices userServices = Provider.of(context);

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return FutureBuilder<Map>(
      future: getCredentials(userServices),
      builder: (context, snapshot) {
        Future.microtask(() async {
          Map credentials =
              await userServices.getMapFromLocalStorage("credentials");
          log("$credentials");
          // if (credentials.isNotEmpty) {
          //   if (credentials["token"] != "") {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            if (snapshot.data!["token"] != "") {
              //showLoadingDialog(context);
              userServices.token = credentials["token"];
              userServices.userID = credentials["userID"];
              userServices.userRole = Role.values.byName(credentials["rol"]);
              await userServices.getMyData();
              //Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => userServices.userRole == Role.patient
                        ? const MainUserScreen()
                        : const ScanNFCScreen()),
              );
            }
          }
        });
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            return const Scaffold(
              body: SafeArea(
                  child: Center(
                child: CircularProgressIndicator.adaptive(),
              )),
            );
          }
        }

        return Scaffold(
          body: SafeArea(
              child: Center(
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    const Spacer(),
                    Text(
                      'Inicia Sesión',
                      style: theme.textTheme.titleLarge,
                    ),
                    const Spacer(),
                    FormTextFieldWidget(
                      label: "Usuario",
                      controller: controllers[0],
                      keyboardType: TextInputType.emailAddress,
                      isVisible: true,
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        FormTextFieldWidget(
                          label: "Contraseña",
                          controller: controllers[1],
                          isVisible: visiblePass,
                        ),
                        IconButton(
                            onPressed: () {
                              visiblePass = !visiblePass;

                              setState(() {});
                            },
                            icon: Icon(visiblePass
                                ? Icons.visibility_off
                                : Icons.visibility)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      Checkbox(
                          value: remember,
                          onChanged: (value) => setState(() {
                                remember = !remember;
                              }),
                          fillColor:
                              MaterialStatePropertyAll(theme.primaryColor)),
                      const Text('Recuerdame?'),
                    ]),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('Iniciar sesión'),
                      onPressed: () async {
                        if (controllers
                            .any((element) => element.text.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Debes llenar los campos")));
                        } else {
                          showLoadingDialog(context);
                          await userServices.loginUser(controllers[0].text,
                              controllers[1].text, remember);

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => getView(controllers[0].text),
                          //     ));
                          if (userServices.userRole == Role.patient) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainUserScreen()),
                            );
                          } else if (userServices.userRole == Role.doctor) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScanNFCScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(userServices.error)));
                          }
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        "¿No estás registrado? 🐴 Registrate",
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          )),
        );
      },
    );
  }
}
