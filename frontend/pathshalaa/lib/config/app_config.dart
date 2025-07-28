class AppConfig {
  // Base Server URL with fallback
  static const String primaryServerUrl = 'http://165.22.208.62:5010';
  static const String fallbackServerUrl = 'http://127.0.0.1:5010';
  static const String localServerUrl = 'http://10.0.2.2:5010'; // For Android emulator
  
  // Current active server URL
  static const String baseServerUrl = primaryServerUrl;
  
  // Derived URLs from base URL
  static const String serverUrl = baseServerUrl; // For backward compatibility
  static const String apiBaseUrl = '$baseServerUrl/api';
  
  // Authentication Endpoints
  static const String authLoginUrl = '$apiBaseUrl/auth/login';    // Back to original
  static const String authRegisterUrl = '$apiBaseUrl/auth/register';
  static const String authLogoutUrl = '$apiBaseUrl/auth/logout';
  static const String adminLoginUrl = '$apiBaseUrl/auth/admin/login';
  static const String adminRegisterUrl = '$apiBaseUrl/auth/admin/register';
  
  // Other API Endpoints
  static const String booksUrl = '$apiBaseUrl/books';
  static const String donationsUrl = '$apiBaseUrl/donations';
  static const String testUrl = '$apiBaseUrl/test';
  static const String employeesUrl = '$apiBaseUrl/employees';
  static const String transactionsUrl = '$apiBaseUrl/transactions';
  static const String certificatesUrl = '$apiBaseUrl/certificates';
  
  // App Configuration
  static const String appName = 'Pustakalay ';
  static const String appVersion = '1.0.0';
  
  // Network Timeouts
  static const int connectionTimeout = 10; // seconds
  static const int requestTimeout = 30; // seconds
}
