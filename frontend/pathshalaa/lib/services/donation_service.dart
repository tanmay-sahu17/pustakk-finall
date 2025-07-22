import 'package:intl/intl.dart';

class DonationService {
  static final DonationService _instance = DonationService._internal();
  factory DonationService() => _instance;
  DonationService._internal();

  // Static list to store donations in memory
  static List<Map<String, dynamic>> _donations = [
    {
      'bookName': 'Dune',
      'author': 'Frank Herbert',
      'donor': 'Hazaro Utah',
      'date': '20/7/2025',
      'category': 'Science Fiction',
      'status': 'समीक्षा में',
    },
    {
      'bookName': 'My Neighbour Kiki',
      'author': 'Miyazaki',
      'donor': 'Sobhagya Raj Dev',
      'date': '20/7/2025',
      'category': 'Fiction',
      'status': 'समीक्षा में',
    },
  ];

  // Get all donations
  List<Map<String, dynamic>> getDonations() {
    return List.from(_donations);
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
