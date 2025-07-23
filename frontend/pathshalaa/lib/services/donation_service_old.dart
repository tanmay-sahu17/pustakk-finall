import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'auth_service.dart';

class DonationService {
  static final DonationService _instance = DonationService._internal();
  factory DonationService() => _instance;
  DonationService._internal();

  static const String baseUrl = 'http://localhost:9001/api';
  final AuthService _authService = AuthService();

  // Add the missing _donations list
  final List<Map<String, dynamic>> _donations = [];

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
            print(
              'Book: ${d['bookName']} by ${d['author']} - Status: ${d['status']}',
            );
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
    return _donations;
  }

  // Helper method to format date
  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  // Helper method to get status in Hindi
  String _getStatusInHindi(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return 'समीक्षा में';
      case 'approved':
        return 'स्वीकृत';
      case 'rejected':
        return 'अस्वीकृत';
      default:
        return 'समीक्षा में';
    }
  }

  // Add new donation
  void addDonation({
    required String bookName,
    required String author,
    required String donorName,
    required String category,
    String status = 'समीक्षा में',
  }) {
    final newDonation = {
      'bookName': bookName,
      'author': author,
      'donor': donorName,
      'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
      'category': category,
      'status': status,
    };

    _donations.add(newDonation);
  }

  // Remove donation
  void removeDonation(int index) {
    if (index >= 0 && index < _donations.length) {
      _donations.removeAt(index);
    }
  }

  // Get donation count
  int getTotalDonations() {
    return _donations.length;
  }

  // Get pending donations count
  int getPendingDonations() {
    return _donations.where((d) => d['status'] == 'समीक्षा में').length;
  }

  // Get approved donations count
  int getApprovedDonations() {
    return _donations.where((d) => d['status'] == 'स्वीकृत').length;
  }

  // Get unique donors count
  int getUniqueDonors() {
    return _donations.map((d) => d['donor']).toSet().length;
  }
}
