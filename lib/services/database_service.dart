import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'appwrite_config.dart';

class DatabaseService {
  late final Databases databases;
  late final String databaseId;
  late final String collectionId;

  DatabaseService() {
    final client = getClient();
    databases = Databases(client);
    databaseId = dotenv.env['APPWRITE_DATABASE_ID'] ?? '';
    collectionId = dotenv.env['APPWRITE_COLLECTION_ID'] ?? '';
  }

  // List all documents from a collection
  Future<DocumentList> listDocuments({List<String>? queries}) async {
    try {
      return await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: queries,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Create a new document
  Future<Document> createDocument({
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing document
  Future<Document> updateDocument({
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Delete a document
  Future<void> deleteDocument({required String documentId}) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: documentId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
