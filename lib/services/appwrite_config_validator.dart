import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Helper class to validate Appwrite configuration
class AppwriteConfigValidator {
  static bool validate() {
    print('\n=== Appwrite Configuration Validator ===\n');

    final endpoint = dotenv.env['APPWRITE_ENDPOINT'];
    final projectId = dotenv.env['APPWRITE_PROJECT_ID'];
    final databaseId = dotenv.env['APPWRITE_DATABASE_ID'];
    final collectionId = dotenv.env['APPWRITE_COLLECTION_ID'];

    bool isValid = true;

    // Check Endpoint
    if (endpoint == null || endpoint.isEmpty) {
      print('❌ APPWRITE_ENDPOINT is missing');
      isValid = false;
    } else if (endpoint.contains('cloud.appwrite.io')) {
      print('✅ APPWRITE_ENDPOINT: $endpoint');
    } else {
      print('⚠️  APPWRITE_ENDPOINT: $endpoint (Custom endpoint)');
    }

    // Check Project ID
    if (projectId == null || projectId.isEmpty) {
      print('❌ APPWRITE_PROJECT_ID is missing');
      isValid = false;
    } else if (projectId == 'your_project_id_here' ||
        projectId.contains('your_')) {
      print('❌ APPWRITE_PROJECT_ID still has placeholder value: $projectId');
      print('   → Go to Appwrite Console and copy your actual Project ID');
      isValid = false;
    } else {
      print('✅ APPWRITE_PROJECT_ID: ${projectId.substring(0, 8)}...');
    }

    // Check Database ID
    if (databaseId == null || databaseId.isEmpty) {
      print('❌ APPWRITE_DATABASE_ID is missing');
      isValid = false;
    } else if (databaseId == 'your_database_id_here' ||
        databaseId.contains('your_')) {
      print('❌ APPWRITE_DATABASE_ID still has placeholder value: $databaseId');
      print('   → Create a database in Appwrite and copy the Database ID');
      isValid = false;
    } else {
      print('✅ APPWRITE_DATABASE_ID: ${databaseId.substring(0, 8)}...');
    }

    // Check Collection ID
    if (collectionId == null || collectionId.isEmpty) {
      print('❌ APPWRITE_COLLECTION_ID is missing');
      isValid = false;
    } else if (collectionId == 'your_collection_id_here' ||
        collectionId.contains('your_')) {
      print(
        '❌ APPWRITE_COLLECTION_ID still has placeholder value: $collectionId',
      );
      print(
        '   → Create a collection in your database and copy the Collection ID',
      );
      isValid = false;
    } else {
      print('✅ APPWRITE_COLLECTION_ID: ${collectionId.substring(0, 8)}...');
    }

    print('\n========================================\n');

    if (!isValid) {
      print('⚠️  CONFIGURATION INVALID!');
      print('\nTo fix this:');
      print('1. Go to https://cloud.appwrite.io');
      print('2. Create a project (or select existing)');
      print('3. Copy the Project ID');
      print('4. Create a database and copy Database ID');
      print('5. Create a collection with these attributes:');
      print('   - content (String, size: 10000, required)');
      print('   - createdAt (String, size: 50, required)');
      print('6. Copy the Collection ID');
      print('7. Update your .env file with these values');
      print('\nSee APPWRITE_COLLECTION_SETUP.md for detailed steps\n');
    } else {
      print('✅ Configuration looks good!\n');
    }

    return isValid;
  }
}
