import 'package:flutter/material.dart';
import 'index.dart';

class CitaWidget extends StatelessWidget {
  final String desc, reason, doctor, date;

  const CitaWidget(
      {Key? key,
      required this.desc,
      required this.reason,
      required this.doctor,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListWidget(
      firstChild: Text(date),
      midChild: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              desc,
              style: const TextStyle(fontSize: 17, fontFamily: "EspecialFont"),
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              reason,
              //style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 5),
            Text(
              doctor,
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
