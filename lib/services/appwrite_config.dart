import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Client getClient() {
  final client = Client();

  final endpoint = dotenv.env['APPWRITE_ENDPOINT'] ?? '';
  final projectId = dotenv.env['APPWRITE_PROJECT_ID'] ?? '';

  client.setEndpoint(endpoint).setProject(projectId);

  return client;
}
