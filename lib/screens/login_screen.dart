import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:security_test/components/index.dart';
import 'package:security_test/providers/user_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    UserServices userServices = Provider.of(context);
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
                Text('Inicia Sesión', style: theme.textTheme.titleLarge),
                const Spacer(),
                FormTextFieldWidget(
                  label: "Usuario",
                  controller: controllers[0],
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
                      fillColor: MaterialStatePropertyAll(theme.primaryColor)),
                  const Text('Recuerdame?'),
                ]),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Iniciar sesión'),
                  onPressed: () async {
                    //await userServices.loginUser(
                    //   controllers[0].text, controllers[1].text);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => getView(controllers[0].text),
                        ));
                    // if (userServices.userRole == Role.patient) {

                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const MainUserScreen()),
                    //   );
                    // } else if (userServices.userRole == Role.doctor) {

                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const ScanNFCScreen()),
                    //   );
                    // }
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
