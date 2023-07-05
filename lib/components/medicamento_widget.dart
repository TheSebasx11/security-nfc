import 'package:flutter/material.dart';
import 'package:security_test/components/custom_list_widget.dart';

class MedicamentoWidget extends StatelessWidget {
  final String nombre, desc, dosis, reason;
  const MedicamentoWidget({
    Key? key,
    required this.desc,
    required this.dosis,
    required this.reason,
    required this.nombre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String image =
        "https://static.vecteezy.com/system/resources/previews/022/750/474/non_2x/capsule-pixel-perfect-gradient-linear-ui-icon-oral-medication-pill-prescript-remedy-in-shell-line-color-user-interface-symbol-modern-style-pictogram-isolated-outline-illustration-vector.jpg";
    final size = MediaQuery.of(context).size;
    return CustomListWidget(
      firstChild: Container(
        width: size.width * 0.2,
        height: size.width * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
        ),
        //child: Image.network(image),
      ),
      midChild: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              nombre,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            Text(
              desc,
              style: theme.textTheme.bodyLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              reason,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
      lastChild: Row(
        children: [
          Container(
            width: 1,
            height: double.infinity,
            color: theme.primaryColor.withAlpha(100),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Dosis',
                style: TextStyle(fontSize: 20, color: theme.primaryColor),
              ),
              const SizedBox(height: 5),
              Text("Cada " + dosis),
            ],
          ),
        ],
      ),
    );
  }
}
