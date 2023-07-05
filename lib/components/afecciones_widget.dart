import 'package:flutter/material.dart';
import 'package:security_test/components/index.dart';

class AfeccionWidget extends StatelessWidget {
  final String name, desc, diagnosis;
  const AfeccionWidget({
    Key? key,
    required this.desc,
    required this.name,
    required this.diagnosis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomListWidget(
      firstChild: Container(
        alignment: Alignment.center,
        width: 60,
        child: const Icon(Icons.emergency, size: 30),
      ),
      midChild: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            Text(
              desc,
              style: theme.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              'Diagnosticada: $diagnosis',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      lastChild: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_right),
            tooltip: "Ver Detalles",
          )
        ],
      ),
    );
  }
}
