import 'package:flutter/material.dart';
import 'index.dart';

class CitaWidget extends StatelessWidget {
  const CitaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListWidget(
      firstChild: const Text("12/04/2023"),
      midChild: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Descripcion',
              //style: theme.textTheme.titleLarge,
              style: TextStyle(fontSize: 17, fontFamily: "EspecialFont"),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 5),
            Text(
              'Reason',
              //style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 5),
            Text(
              'Doctor',
              //style: theme.textTheme.bodyMedium
            ),
          ],
        ),
      ),
      lastChild: IconButton(
          onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
    );
  }
}
