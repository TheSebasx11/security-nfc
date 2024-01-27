import 'package:flutter/material.dart';

class ListItem {
  final double nota;
  final String texto;
  final DateTime fecha;

  ListItem(this.nota, this.texto, this.fecha);
}

class MakeNoteScreen extends StatefulWidget {
  final String student;
  const MakeNoteScreen({Key? key, required this.student}) : super(key: key);

  @override
  _MakeNoteScreenState createState() => _MakeNoteScreenState();
}

class _MakeNoteScreenState extends State<MakeNoteScreen> {
  final List<ListItem> items = [
    ListItem(9.0 / 2, 'Buen desempeño', DateTime.parse("2023-10-10")),
    ListItem(7.8 / 2, 'Necesita mejorar', DateTime.parse("2023-11-26"))
  ];
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController textoController = TextEditingController();
  bool isFormActive = false;

  void toggleForm() {
    setState(() {
      isFormActive = !isFormActive;
      // Limpiar los campos cuando el formulario se activa/desactiva
      if (!isFormActive) {
        numeroController.clear();
        textoController.clear();
      }
    });
  }

  void addItem() {
    final double numero = double.parse(numeroController.text);
    final String texto = textoController.text;
    final ListItem newItem = ListItem(numero, texto, DateTime.now());

    setState(() {
      items.add(newItem);
      // Limpiar los campos después de agregar un item
      numeroController.clear();
      textoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas: ${widget.student}'),
        actions: [
          IconButton(onPressed: toggleForm, icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (isFormActive)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * .3,
                        child: TextField(
                          controller: numeroController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'Calificación'),
                        ),
                      ),
                      SizedBox(
                        width: size.width * .3,
                        child: TextField(
                          controller: textoController,
                          decoration: const InputDecoration(
                              labelText: 'Nota (opcional)'),
                        ),
                      ),
                      //const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: addItem,
                        child: const Text('Agregar'),
                      ),
                    ],
                  ),
                ),
              ),
            if (isFormActive)
              ElevatedButton(
                onPressed: toggleForm,
                child: const Text('Cancelar'),
              ),
            const SizedBox(height: 20),
            Expanded(
                child:
                    gradesTable() /* ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Número: ${items[index].numero}'),
                    subtitle: Text('Texto: ${items[index].texto}'),
                  );
                },
              ),
               */
                ),
          ],
        ),
      ),
    );
  }

  Widget gradesTable() {
    return SafeArea(
      child: SizedBox(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Nota')),
              DataColumn(label: Text('Razón')),
              DataColumn(label: Text('Fecha')),
            ],
            rows: items
                .map((e) => DataRow(
                      cells: rowDataWidget(
                          grade: e.nota,
                          anot: e.texto.isEmpty ? "Sin anotaciones" : e.texto,
                          fecha:
                              "${e.fecha.day}/${e.fecha.month}/${e.fecha.year}"),
                    ))
                .toList(), /* <DataRow>[
              DataRow(
                cells: rowDataWidget(
                    grade: 9.0 / 2,
                    anot: 'Buen desempeño',
                    fecha: "10/10/2023"),
              ),
              DataRow(
                cells: rowDataWidget(
                    grade: 8.5 / 2, anot: 'Esforzado', fecha: "10/10/2023"),
              ),
              DataRow(
                cells: rowDataWidget(
                    grade: 7.8 / 2,
                    anot: 'Necesita mejorar',
                    fecha: "10/10/2023"),
              ),
              DataRow(
                cells: rowDataWidget(
                    grade: 9.5 / 2, anot: 'Excelente', fecha: "10/10/2023"),
              ),
              // Agrega más filas según las calificaciones de tu estudiante
            ], */
          ),
        ),
      ),
    );
  }

  List<DataCell> rowDataWidget(
      {required double grade, String anot = "--", required String fecha}) {
    return [
      DataCell(Text('$grade')),
      DataCell(Text(anot)),
      DataCell(Text(fecha)),
    ];
  }
}
