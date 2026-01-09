import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const appName = 'Budidaya Lele';

  static final _host = dotenv.env['FLUTTER_HOST'];

  static final baseURL = '$_host/api';

  static final baseImageURL = '$_host';
}
