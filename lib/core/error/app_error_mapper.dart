class AppErrorMapper {
  static String getErrorMessage(dynamic response) {
    try {
      if (response is Map<String, dynamic>) {
        // Cek error dalam bentuk list di 'stack_trace'
        if (response['stack_trace'] is List &&
            response['stack_trace'].isNotEmpty) {
          final stackTrace = response['stack_trace'] as List;
          final errors = stackTrace.map((error) => error.toString()).toList();
          return errors.join('\n');
        }

        // Cek pesan error di 'message'
        if (response['message'] != null &&
            response['message'].toString().isNotEmpty) {
          return response['message'].toString();
        }

        return response.toString();
      }

      return response.toString();
    } catch (e) {
      return 'Error parsing response: ${e.toString()}';
    }
  }
}
