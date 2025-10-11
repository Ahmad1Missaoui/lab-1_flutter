import 'package:flutter/material.dart';
import '../models/note.dart';
import 'package:uuid/uuid.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note; 

  const AddNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void saveNote() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final noteToReturn = widget.note != null
        ? Note(id: widget.note!.id, content: text, createdAt: widget.note!.createdAt)
        : Note(id: const Uuid().v4(), content: text, createdAt: DateTime.now());

    Navigator.pop(context, noteToReturn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Type your note here...',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
