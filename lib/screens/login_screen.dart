import 'package:flutter/material.dart';
import 'package:security_test/components/index.dart';
import 'package:security_test/screens/screens.dart';

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
                    label: "Usuario", controller: controllers[0]),
                const SizedBox(height: 10),
                FormTextFieldWidget(
                    label: "Contraseña", controller: controllers[1]),
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => getView(controllers[0].text),
                        ));
                    // if (controllers[0].text == "usuario") {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const MainUserScreen()),
                    //   );
                    // } else if (controllers[0].text == "doctor") {
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
