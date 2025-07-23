import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class DonationService {
  static final DonationService _instance = DonationService._internal();
  factory DonationService() => _instance;
  DonationService._internal();

  // Local data as backup (initially empty, populated from API)
  List<Map<String, dynamic>> _localDonations = [];

  bool _apiConnected = false;
  List<Map<String, dynamic>> _apiDonations = [];

  // Test API connection
  Future<bool> testApiConnection() async {
    try {
      print('Testing API connection to: ${ApiConstants.baseUrl}/api/test');
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/test'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Test Success: ${data['message']}');
        _apiConnected = true;
        return true;
      } else {
        print('API Test Failed: Status ${response.statusCode}');
        _apiConnected = false;
        return false;
      }
    } catch (e) {
      print('API Test Error: $e');
      _apiConnected = false;
      return false;
    }
  }

  // Fetch donations from API
  Future<List<Map<String, dynamic>>> fetchDonationsFromAPI() async {
    try {
      if (!_apiConnected) {
        await testApiConnection();
      }

      if (!_apiConnected) {
        print('API not connected, using local data');
        return _localDonations;
      }

      print('Fetching donations from: ${ApiConstants.fullDonationsUrl}');
      final response = await http.get(
        Uri.parse(ApiConstants.fullDonationsUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> donations = data['data'];
          _apiDonations = donations.cast<Map<String, dynamic>>();
          print('Successfully fetched ${_apiDonations.length} donations from API');
          
          // Update local cache with API data
          _localDonations = List.from(_apiDonations);
          
          // Sort by ID (newer IDs = more recent) in descending order
          _localDonations.sort((a, b) {
            final aId = a['id'] ?? 0;
            final bId = b['id'] ?? 0;
            return bId.compareTo(aId); // Descending order (newest first)
          });
          
          return _localDonations;
        } else {
          print('API Error: ${data['message']}');
          return _localDonations;
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        return _localDonations;
      }
    } catch (e) {
      print('Network Error: $e');
      return _localDonations;
    }
  }

  // Get donations (fetch from API and update local cache)
  List<Map<String, dynamic>> getDonations() {
    // Start background API fetch to get latest data
    fetchDonationsFromAPI().then((data) {
      // This will update _localDonations with fresh API data
    });
    
    // Return current local cache (which gets updated by API calls)
    return _localDonations;
  }

  // Get donations asynchronously
  Future<List<Map<String, dynamic>>> getDonationsAsync() async {
    return await fetchDonationsFromAPI();
  }

  // Add new donation
  Future<bool> addDonation({
    required String bookName,
    required String author,
    required String donorName,
    required String category,
    String condition = 'Good',
    String? description,
  }) async {
    // Send to API first
    try {
      if (!_apiConnected) {
        await testApiConnection();
      }

      if (_apiConnected) {
        final response = await http.post(
          Uri.parse(ApiConstants.fullDonationsUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'bookName': bookName,
            'author': author,
            'donorName': donorName,
            'category': category,
            'condition': condition,
            'description': description,
          }),
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 201) {
          print('Successfully synced donation to API');
          // Refresh local data from API
          await fetchDonationsFromAPI();
          return true;
        } else {
          print('Failed to sync donation to API: ${response.statusCode}');
          return false;
        }
      } else {
        print('API not connected, cannot add donation');
        return false;
      }
    } catch (e) {
      print('Error syncing donation to API: $e');
      return false;
    }
  }

  // Remove donation
  bool removeDonation(int index) {
    if (index >= 0 && index < _localDonations.length) {
      _localDonations.removeAt(index);
      return true;
    }
    return false;
  }

  // Statistics methods
  int getTotalDonations() => _localDonations.length;
  
  int getPendingDonations() => 
      _localDonations.where((d) => d['status'] == 'समीक्षा में').length;
  
  int getApprovedDonations() => 
      _localDonations.where((d) => d['status'] == 'स्वीकृत').length;
  
  int getUniqueDonors() => 
      _localDonations.map((d) => d['donor']).toSet().length;

  // Refresh data
  Future<void> refreshData() async {
    await fetchDonationsFromAPI();
  }
}
