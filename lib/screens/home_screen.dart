import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Note> notes;
  final Function(Note) onNoteAdded;
  final Function(Note) onNoteEdited;
  final Function(String) onNoteDeleted;

  const HomeScreen({
    super.key,
    required this.notes,
    required this.onNoteAdded,
    required this.onNoteEdited,
    required this.onNoteDeleted,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateToAddNote([Note? note]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(note: note),
      ),
    );

    if (result != null && result is Note) {
      if (note != null) {
        widget.onNoteEdited(result);
      } else {
        widget.onNoteAdded(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notes = widget.notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Notes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: notes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No notes yet.", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => navigateToAddNote(),
                      child: const Text("Create New Note"),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    elevation: 5,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(note.content, style: const TextStyle(fontSize: 16)),
                      subtitle: Text(
                        "Created: ${note.createdAt.toLocal().toString().substring(0, 16)}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      trailing: SizedBox(
                        width: 90,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () => navigateToAddNote(note),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => widget.onNoteDeleted(note.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddNote(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
