import 'package:flutter/material.dart';

class CustomListWidget extends StatelessWidget {
  final Widget firstChild, midChild, lastChild;
  const CustomListWidget({
    Key? key,
    required this.firstChild,
    required this.midChild,
    required this.lastChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: size.height * 0.135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.primaryColor.withAlpha(150),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          firstChild,
          Expanded(
            child: midChild,
          ),
          lastChild,
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
