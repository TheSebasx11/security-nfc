import 'package:flutter/material.dart';
import 'package:security_test/screens/doctor_screens/profe_view.dart';
import 'package:security_test/screens/doctor_screens/scan_screen.dart';
import 'package:security_test/screens/new_views/make_notes.dart';

class Student {
  final int id;
  final String fullName;

  Student(
    this.id,
    this.fullName,
  );
}

class ListStudentsScreen extends StatelessWidget {
  const ListStudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Student> names = [
      Student(703772474, "Sebastian Ricardo Cardenas"),
      Student(172377611, "Engolo Regino Mendoza"),
      Student(118249838, "Jammal Feldmark"),
      Student(1053883993, "Lib Ansill"),
      Student(420717616, "Lorie Consterdine"),
      Student(650359816, "Mirabelle Berriman"),
      Student(318540962, "Reagan Wringe"),
      Student(177569858, "Chlo Vedstra"),
      Student(209819355, "Guenna Sholl"),
      Student(1019337974, "Abeu Whistlecraft"),
      Student(1095094656, "Camile Laybourne"),
      Student(233967108, "Rand Awdry"),
      Student(221996672, "Anita Bebbington"),
      Student(64397319, "Felike Oxborough"),
      Student(960524552, "Margeaux Fermoy"),
      Student(955068260, "Florrie Thomasen"),
      Student(920528494, "Jilly Goodby"),
      Student(847677855, "Ruthann Roulston"),
      Student(127279871, "Minerva Roderick"),
      Student(447953373, "Jamie Freshwater"),
      Student(65797633, "Hailee Vaszoly"),
      Student(1040395346, "Crystie Goman"),
      Student(1081274014, "Kelley Sudworth"),
      Student(124327871, "Babs Ruffli"),
      Student(545210947, "Jarrad Marzellano"),
      Student(1011190745, "Delilah Bartelot"),
      Student(1071741202, "Ediva Whatford"),
      Student(688662090, "Alvira Farge"),
      Student(343358071, "Aluino Eudall"),
      Student(722380038, "Roger Ducket"),
      Student(883856183, "Ada Bartrap"),
      Student(77309699, "Inigo Brett"),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ScanNFCScreen()),
            ),
            icon: const Icon(Icons.radio_button_checked),
          )
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: names.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Student student = names[index];
            return StudentItemWidget(
              fullName: student.fullName,
              identifier: "${student.id}",
            );
          },
        ),
      ),
    );
  }
}

class StudentItemWidget extends StatelessWidget {
  final String fullName;
  final String identifier;
  const StudentItemWidget(
      {Key? key, required this.fullName, required this.identifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
        title: Text(fullName),
        subtitle: Text(
          identifier,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
        trailing: SizedBox(
          width: 96,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.calendar_month,
                  color: theme.primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CalendarView(
                              studentName: fullName,
                            )),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: theme.primaryColor,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MakeNoteScreen(student: fullName)),
                ),
              ),
            ],
          ),
        ));
  }
}
