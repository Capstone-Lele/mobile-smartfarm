import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const appName = 'Budidaya Lele';

  static final _host = dotenv.env['FLUTTER_HOST'];

  static final baseURL = '$_host/api';

  static final baseImageURL = '$_host';

  // Socket.IO server runs on the same host as the REST API (without /api)
  static final socketURL = '$_host';
}
