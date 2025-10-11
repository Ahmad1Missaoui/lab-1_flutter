import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // قائمة الملاحظات المشتركة بين الصفحات
  List<Note> notes = [
    Note(id: const Uuid().v4(), content: "Learn Flutter", createdAt: DateTime.now()),
    Note(id: const Uuid().v4(), content: "Complete tutorial", createdAt: DateTime.now()),
  ];

  // دوال إدارة الملاحظات
  void addNote(Note note) => setState(() => notes.add(note));

  void editNote(Note note) {
    setState(() {
      int index = notes.indexWhere((n) => n.id == note.id);
      if (index != -1) notes[index] = note;
    });
  }

  void deleteNote(String id) => setState(() => notes.removeWhere((n) => n.id == id));

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(
        notes: notes,
        onNoteAdded: addNote,
        onNoteEdited: editNote,
        onNoteDeleted: deleteNote,
      ),
      ExploreScreen(notes: notes),
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
        ],
      ),
    );
  }
}
