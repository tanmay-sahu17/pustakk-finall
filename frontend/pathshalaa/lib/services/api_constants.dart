// API Configuration
import '../config/app_config.dart';

class ApiConstants {
  // Use centralized server URL from AppConfig
  static String get baseUrl {
    return AppConfig.serverUrl;
  }
  
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
