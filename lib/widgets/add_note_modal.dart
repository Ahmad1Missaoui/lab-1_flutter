import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';

class AddNoteModal extends StatefulWidget {
  final Note? note;
  final Function(Note) onNoteSaved;

  const AddNoteModal({Key? key, this.note, required this.onNoteSaved})
    : super(key: key);

  @override
  State<AddNoteModal> createState() => _AddNoteModalState();

  // Static method to show the modal
  static Future<void> show(
    BuildContext context, {
    Note? note,
    required Function(Note) onNoteSaved,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AddNoteModal(note: note, onNoteSaved: onNoteSaved),
    );
  }
}

class _AddNoteModalState extends State<AddNoteModal> {
  late TextEditingController _controller;
  bool _isSaving = false;

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

  Future<void> _saveNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note content cannot be empty')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final noteToReturn = widget.note != null
        ? Note(
            id: widget.note!.id,
            content: text,
            createdAt: widget.note!.createdAt,
          )
        : Note(id: const Uuid().v4(), content: text, createdAt: DateTime.now());

    try {
      widget.onNoteSaved(noteToReturn);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save note: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.note == null ? 'Add Note' : 'Edit Note',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 5,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Type your note here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveNote,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blueAccent,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Save', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
