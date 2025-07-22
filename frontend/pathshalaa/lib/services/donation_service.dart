import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class DonationService {
  static final DonationService _instance = DonationService._internal();
  factory DonationService() => _instance;
  DonationService._internal();

  static const String baseUrl = 'http://localhost:9001/api';
  final AuthService _authService = AuthService();

  Future<List<Map<String, dynamic>>> getAllDonations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations'),
        headers: _authService.authHeaders,
      );

      print('=== DONATION API RESPONSE ===');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      print('============================');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> donationsJson = data['data'];
          
          List<Map<String, dynamic>> donations = donationsJson.map((donation) {
            return {
              'id': donation['id']?.toString() ?? '',
              'donationId': donation['donationId'] ?? '',
              'bookName': donation['bookTitle'] ?? '',
              'author': donation['bookAuthor'] ?? '',
              'donor': donation['donor']?['name'] ?? 'Unknown',
              'donorEmail': donation['donor']?['email'] ?? '',
              'date': _formatDate(donation['createdAt']),
              'category': donation['bookGenre'] ?? 'General',
              'status': _getStatusInHindi(donation['status']),
              'condition': donation['bookCondition'] ?? 'Good',
              'isbn': donation['bookIsbn'] ?? '',
              'description': donation['bookDescription'] ?? '',
              'language': donation['bookLanguage'] ?? 'Hindi',
            };
          }).toList();

          print('=== PROCESSED DONATIONS ===');
          print('Count: ${donations.length}');
          for (var d in donations) {
            print('Book: ${d['bookName']} by ${d['author']} - Status: ${d['status']}');
          }
          print('===========================');
          
          return donations;
        }
      }
      
      print('API call failed, returning empty list');
      return [];
    } catch (e) {
      print('Error getting donations: $e');
      return [];
    }
  }

  // Legacy method for compatibility
  List<Map<String, dynamic>> getDonations() {
    return [];
  }

  Future<bool> createDonation({
    required String bookTitle,
    required String bookAuthor,
    required String bookGenre,
    required String bookCondition,
    String? bookIsbn,
    String? bookDescription,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations'),
        headers: _authService.authHeaders,
        body: json.encode({
          'donorId': 1, // Default user ID
          'bookTitle': bookTitle,
          'bookAuthor': bookAuthor,
          'bookGenre': bookGenre,
          'bookCondition': bookCondition,
          'bookIsbn': bookIsbn,
          'bookDescription': bookDescription,
          'bookLanguage': 'Hindi',
        }),
      );

      print('=== CREATE DONATION RESPONSE ===');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      print('===============================');

      return response.statusCode == 201;
    } catch (e) {
      print('Error creating donation: $e');
      return false;
    }
  }

  Future<Map<String, int>> getDonationStatistics() async {
    try {
      final donations = await getAllDonations();
      
      final total = donations.length;
      final approved = donations.where((d) => d['status'] == 'स्वीकृत').length;
      final pending = donations.where((d) => d['status'] == 'लंबित').length;

      return {
        'total': total,
        'approved': approved,
        'pending': pending,
      };
    } catch (e) {
      print('Error getting statistics: $e');
      return {'total': 0, 'approved': 0, 'pending': 0};
    }
  }

  // Legacy methods for compatibility
  void addDonation({required String bookName, required String author, required String donorName, required String category, String status = 'समीक्षा में'}) {}
  void removeDonation(int index) {}
  int getTotalDonations() => 0;
  int getPendingDonations() => 0;
  int getApprovedDonations() => 0;
  int getUniqueDonors() => 0;

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return '';
    }
  }

  String _getStatusInHindi(String? status) {
    const statusMap = {
      'PENDING': 'लंबित',
      'UNDER_REVIEW': 'समीक्षा में',
      'APPROVED': 'स्वीकृत',
      'REJECTED': 'अस्वीकृत',
      'ADDED_TO_LIBRARY': 'पुस्तकालय में जोड़ा गया'
    };
    return statusMap[status] ?? status ?? 'अज्ञात';
  }
}
