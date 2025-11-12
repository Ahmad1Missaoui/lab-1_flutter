import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/note.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'services/appwrite_config_validator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print('✅ .env file loaded successfully');

    // Validate configuration (only in debug mode)
    assert(() {
      AppwriteConfigValidator.validate();
      return true;
    }());
  } catch (e) {
    print('❌ Error loading .env file: $e');
    print('Make sure .env file exists in the project root');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // القايمة الرئيسية للملاحظات
  List<Note> notes = [
    Note(id: '1', content: 'Learn Flutter', createdAt: DateTime.now()),
    Note(id: '2', content: 'Complete tutorial', createdAt: DateTime.now()),
  ];

  // تحديث الملاحظات بعد الإضافة أو التعديل
  void updateNotes(Note? newNote, {bool isEdit = false}) {
    setState(() {
      if (newNote != null) {
        if (isEdit) {
          int index = notes.indexWhere((n) => n.id == newNote.id);
          if (index != -1) notes[index] = newNote;
        } else {
          notes.add(newNote);
        }
      }
    });
  }

  // حذف ملاحظة
  void deleteNote(String id) {
    setState(() {
      notes.removeWhere((note) => note.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(
        notes: notes,
        onNoteAdded: (note) => updateNotes(note),
        onNoteEdited: (note) => updateNotes(note, isEdit: true),
        onNoteDeleted: deleteNote,
      ),
      ExploreScreen(notes: notes),
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        ],
      ),
    );
  }
}
