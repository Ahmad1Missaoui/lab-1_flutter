import 'package:flutter/material.dart';
import '../models/note.dart';

class ExploreScreen extends StatelessWidget {
  final List<Note> notes;

  const ExploreScreen({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final totalNotes = notes.length;
    final todayNotes = notes.where((n) =>
        n.createdAt.day == DateTime.now().day &&
        n.createdAt.month == DateTime.now().month &&
        n.createdAt.year == DateTime.now().year).length;
    final lastNote = notes.isNotEmpty ? notes.last.content : "No notes yet";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notes Statistics",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Total Notes Card
            Card(
              color: Colors.blueAccent.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.note, color: Colors.white, size: 36),
                title: Text(
                  "Total Notes",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                trailing: Text(
                  "$totalNotes",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Today's Notes Card
            Card(
              color: Colors.greenAccent.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.today, color: Colors.white, size: 36),
                title: Text(
                  "Notes Added Today",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                trailing: Text(
                  "$todayNotes",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Last Note Card
            Card(
              color: Colors.orangeAccent.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.note_alt, color: Colors.white, size: 36),
                title: Text(
                  "Last Note",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: Text(
                  lastNote,
                  style: const TextStyle(color: Colors.white70),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Tips Section
            const Text(
              "Quick Tips 💡",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(12)),
              child: const Text(
                "💾 Tap '+' in Home to add a new note.\n"
                "✏️ Tap 'Edit' in Home to modify a note.\n"
                "🗑️ Tap 'Delete' to remove unwanted notes.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
