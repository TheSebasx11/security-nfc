import 'package:flutter/material.dart';
import 'package:security_test/components/custom_list_widget.dart';

class MedicamentoWidget extends StatelessWidget {
  const MedicamentoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String image =
        "https://estaticos-cdn.elperiodico.com/clip/b6750cc8-4a56-4919-ae70-03379c94fb54_alta-libre-aspect-ratio_default_0.jpg";
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
              'Peyosilina',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            Text(
              'Quita la peyosidad',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 5),
            Text(
              'Peyofrangel',
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
              const Text('Cada 8 horas'),
            ],
          ),
        ],
      ),
    );
  }
}
