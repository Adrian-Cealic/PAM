class ApiConfig {
  const ApiConfig({
    this.baseUrl = defaultBaseUrl,
    this.version = defaultVersion,
    this.timeout = const Duration(seconds: 60),
  });

  static const defaultBaseUrl = 'https://test-api-jlbn.onrender.com/lab2026';
  static const defaultVersion = 'v4';

  final String baseUrl;
  final String version;
  final Duration timeout;

  Uri endpoint(String path) => Uri.parse('$baseUrl/$version/$path');
}
