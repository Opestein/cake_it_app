import 'package:http/http.dart' as http;

class CakeApiClient {
  CakeApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const String _cakeListUrl =
      'https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460'
      '/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json';

  Future<String> fetchCakesJson() async {
    try {
      final uri = Uri.parse(_cakeListUrl);
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw CakeApiException(
          'Server returned status ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw CakeApiException(
        'No internet connection. Please check your network and try again.',
        cause: e,
      );
    } on FormatException catch (e) {
      throw CakeApiException(
        'Invalid response from server.',
        cause: e,
      );
    }
  }

  /// Closes the underlying HTTP client.
  void dispose() {
    _httpClient.close();
  }
}

class CakeApiException implements Exception {
  const CakeApiException(this.message, {this.statusCode, this.cause});

  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() => 'CakeApiException: $message';
}
