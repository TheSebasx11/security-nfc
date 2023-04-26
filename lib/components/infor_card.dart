import 'package:flutter/material.dart';

class InformationCardWidget extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  const InformationCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.35,
      height: size.height * 0.12,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryColor.withAlpha(155), width: 3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                  child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.04,
                    fontFamily: "EspecialFont"),
              )),
              Icon(
                icon,
                size: size.width * 0.055,
              ),
              const SizedBox(width: 5),
            ],
          ),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.045,
                          fontFamily: "EspecialFont"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
