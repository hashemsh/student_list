import 'package:flutter/material.dart';
import 'package:student_list/data.dart';

void main() {
  getStudents();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: const Color(0xff16E5A7),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Expert'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => _AddStudentForm(),
              ),
            );
            setState(() {});
          },
          label: Row(
            children: const [
              Icon(Icons.add),
              Text('Add Student'),
            ],
          ),
        ),
        body: FutureBuilder<List<StudentData>>(
          future: getStudents(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 84),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _Student(
                      data: snapshot.data![index],
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class _AddStudentForm extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lasttNameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Student'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            final newStudentData = await saveStudent(
              _firstNameController.text,
              _lasttNameController.text,
              _courseController.text,
              int.parse(_scoreController.text),
            );
            Navigator.pop(context, newStudentData);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        label: Row(
          children: const [
            Icon(Icons.check),
            Text('Save'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                label: Text('First Name'),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _lasttNameController,
              decoration: const InputDecoration(
                label: Text('Last Name'),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(
                label: Text('Course'),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Score'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Student extends StatelessWidget {
  final StudentData data;

  const _Student({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Text(
              data.firstName.characters.first,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.firstName + ' ' + data.lastName),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey.shade200),
                  child: Text(
                    data.course,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: Colors.grey.shade400,
              ),
              Text(
                data.score.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}
