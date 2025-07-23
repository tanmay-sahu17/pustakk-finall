// API Configuration
class ApiConstants {
  // Base URL for the backend server
  // Use 10.0.2.2 for Android emulator to access host machine's localhost
  static const String baseUrl = 'http://10.0.2.2:9000';
  
  // API endpoints
  static const String apiPrefix = '/api';
  
  // Donation endpoints
  static const String donations = '$apiPrefix/donations';
  static const String donationStats = '$donations/stats';
  
  // Auth endpoints
  static const String auth = '$apiPrefix/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  
  // Book endpoints
  static const String books = '$apiPrefix/books';
  
  // User endpoints
  static const String users = '$apiPrefix/users';
  
  // Admin endpoints
  static const String admin = '$apiPrefix/admin';
  
  // Transaction endpoints
  static const String transactions = '$apiPrefix/transactions';
  
  // Certificate endpoints
  static const String certificates = '$apiPrefix/certificates';
  
  // Helper methods
  static String getDonationById(int id) => '$donations/$id';
  static String updateDonationStatus(int id) => '$donations/$id/status';
  static String deleteDonation(int id) => '$donations/$id';
  
  static String getBookById(int id) => '$books/$id';
  static String getUserById(int id) => '$users/$id';
  
  // Full URLs
  static String get fullDonationsUrl => '$baseUrl$donations';
  static String get fullDonationStatsUrl => '$baseUrl$donationStats';
  static String get fullLoginUrl => '$baseUrl$login';
  static String get fullRegisterUrl => '$baseUrl$register';
  static String get fullBooksUrl => '$baseUrl$books';
}
