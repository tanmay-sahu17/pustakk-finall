class AppConfig {
  // Server URL Configuration
  // static const String serverUrl = 'http://10.0.2.2:9000'; // For emulator
  // static const String serverUrl = 'http://192.168.29.44:9000'; // For real device
  static const String serverUrl = 'http://165.22.208.6:5010'; // Production server
  // static const String serverUrl = 'http://localhost:9000'; // For web/desktop
  
  // API Base URL
  static const String apiBaseUrl = '$serverUrl/api';
  
  // API Endpoints
  static const String authLoginUrl = '$apiBaseUrl/auth/login';
  static const String donationsUrl = '$apiBaseUrl/donations';
  static const String testUrl = '$apiBaseUrl/test';
  
  // App Configuration
  static const String appName = 'Pustakalay 2.0';
  static const String appVersion = '1.0.0';
  
  // Network Timeouts
  static const int connectionTimeout = 10; // seconds
  static const int requestTimeout = 30; // seconds
}
