import 'package:appwrite/appwrite.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import 'database_service.dart';

class NoteService {
  final DatabaseService _databaseService = DatabaseService();

  // Get all notes with optional filtering and sorting
  Future<List<Note>> getNotes({List<String>? queries}) async {
    try {
      final response = await _databaseService.listDocuments(
        queries: queries ?? [Query.orderDesc('\$createdAt')],
      );

      return response.documents.map((doc) {
        return Note(
          id: doc.$id,
          content: doc.data['content'] ?? '',
          createdAt: DateTime.parse(
            doc.data['createdAt'] ?? DateTime.now().toIso8601String(),
          ),
        );
      }).toList();
    } catch (e) {
      print('Error fetching notes: $e');
      if (e.toString().contains('project_not_found')) {
        print('\n⚠️  CONFIGURATION ERROR:');
        print('Your .env file has invalid or placeholder values.');
        print('Please update .env with your actual Appwrite credentials.');
        print('See APPWRITE_COLLECTION_SETUP.md for instructions.\n');
      }
      rethrow;
    }
  }

  // Create a new note
  Future<Note> createNote({required String content}) async {
    try {
      final noteId = const Uuid().v4();
      final now = DateTime.now();

      final document = await _databaseService.createDocument(
        documentId: noteId,
        data: {'content': content, 'createdAt': now.toIso8601String()},
      );

      return Note(
        id: document.$id,
        content: document.data['content'] ?? '',
        createdAt: DateTime.parse(
          document.data['createdAt'] ?? now.toIso8601String(),
        ),
      );
    } catch (e) {
      print('Error creating note: $e');
      if (e.toString().contains('project_not_found')) {
        print('\n⚠️  CONFIGURATION ERROR:');
        print('Check your .env file and ensure all IDs are correct.');
        print('See APPWRITE_COLLECTION_SETUP.md for setup instructions.\n');
      }
      rethrow;
    }
  }

  // Update an existing note
  Future<Note> updateNote({
    required String noteId,
    required String content,
  }) async {
    try {
      final document = await _databaseService.updateDocument(
        documentId: noteId,
        data: {'content': content},
      );

      return Note(
        id: document.$id,
        content: document.data['content'] ?? '',
        createdAt: DateTime.parse(
          document.data['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
      );
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }

  // Delete a note
  Future<void> deleteNote({required String noteId}) async {
    try {
      await _databaseService.deleteDocument(documentId: noteId);
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }
}
