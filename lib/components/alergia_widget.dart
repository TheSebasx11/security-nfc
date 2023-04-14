import 'package:flutter/material.dart';
import 'package:security_test/components/index.dart';

class AlergiaWidget extends StatelessWidget {
  final String title, description, gravedad;
  const AlergiaWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.gravedad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomListWidget(
      firstChild: Container(
        alignment: Alignment.center,
        width: 60,
        child: const Icon(Icons.monitor_heart_outlined, size: 30),
      ),
      midChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title,
              style: theme.textTheme.titleLarge, textAlign: TextAlign.start),
          Text(description,
              style: theme.textTheme.bodyMedium, textAlign: TextAlign.start),
        ],
      ),
      lastChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Gravedad', style: theme.textTheme.bodySmall),
          const SizedBox(height: 10),
          CircleAvatar(
              backgroundColor: gravedad == "Alta"
                  ? Colors.red
                  : (gravedad == "Media" ? Colors.yellow : Colors.green))
        ],
      ),
    );
  }
}
