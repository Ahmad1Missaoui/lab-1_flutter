import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';
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
  final NoteService _noteService = NoteService();
  List<Note> _notes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notes = await _noteService.getNotes();
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load notes: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void navigateToAddNote([Note? note]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNoteScreen(note: note)),
    );

    if (result != null && result is Note) {
      if (note != null) {
        // Edit existing note
        try {
          await _noteService.updateNote(
            noteId: result.id,
            content: result.content,
          );
          _loadNotes(); // Reload notes after update
          widget.onNoteEdited(result);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update note: ${e.toString()}')),
          );
        }
      } else {
        // Add new note
        try {
          await _noteService.createNote(content: result.content);
          _loadNotes(); // Reload notes after adding
          widget.onNoteAdded(result);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create note: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _deleteNote(String noteId) async {
    try {
      await _noteService.deleteNote(noteId: noteId);
      _loadNotes(); // Reload notes after deletion
      widget.onNoteDeleted(noteId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete note: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Notes"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadNotes),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _loadNotes,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: _notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "No notes yet.",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => navigateToAddNote(),
                            child: const Text("Create New Note"),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          elevation: 5,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              note.content,
                              style: const TextStyle(fontSize: 16),
                            ),
                            subtitle: Text(
                              "Created: ${note.createdAt.toLocal().toString().substring(0, 16)}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: SizedBox(
                              width: 90,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    onPressed: () => navigateToAddNote(note),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => _deleteNote(note.id),
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
