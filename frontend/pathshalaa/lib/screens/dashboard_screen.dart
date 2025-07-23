import 'package:flutter/material.dart';
import '../services/donation_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final DonationService _donationService = DonationService();
  List<Map<String, dynamic>> _donations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    setState(() {
      _isLoading = true;
    });

    // Test API connection first
    await _donationService.testApiConnection();
    
    // Load donations from API
    final donations = await _donationService.getDonationsAsync();
    
    if (mounted) {
      setState(() {
        _donations = donations;
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to donate book screen and refresh when returning
      Navigator.pushNamed(context, '/donate').then((_) {
        // Refresh the data when returning from donation screen
        _loadDonations();
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        title: const Text(
          'My Donations',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _isLoading 
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.auto_stories,
                    value: '${_donations.length}',
                    label: 'कुल\nपुस्तकें',
                    iconColor: const Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle,
                    value: '${_donations.where((d) => d['status'] == 'स्वीकृत').length}',
                    label: 'स्वीकृत\nपुस्तकें',
                    iconColor: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.access_time,
                    value: '${_donations.where((d) => d['status'] == 'समीक्षा में').length}',
                    label: 'लंबित\nपुस्तकें',
                    iconColor: const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.group,
                    value: '${_donations.map((d) => d['donor']).toSet().length}',
                    label: 'कुल दाता',
                    iconColor: const Color(0xFF9C27B0),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Donation List
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'दान सूची',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      if (_donations.length > 3)
                        TextButton(
                          onPressed: () {
                            _showAllDonations();
                          },
                          child: const Text(
                            'सभी देखें',
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Donation Items (show only first 3 if more than 3 exist)
                  if (_donations.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.auto_stories_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'अभी तक कोई दान नहीं मिला',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'पहली पुस्तक दान करने के लिए "Donate Book" पर क्लिक करें',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // Show donations
                    ...(_donations.length > 3
                            ? _donations.take(3)
                            : _donations)
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> donation = entry.value;
                          return Column(
                            children: [
                              _buildDonationItem(
                                index: index,
                                bookName: donation['bookName'],
                                author: donation['author'],
                                donor: donation['donor'],
                                date: donation['date'],
                                category: donation['category'],
                                status: donation['status'],
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'My Donations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Donate Book',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, iconColor.withValues(alpha: 0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withValues(alpha: 0.1),
                  iconColor.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationItem({
    required int index,
    required String bookName,
    required String author,
    required String donor,
    required String date,
    required String category,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E5E9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Title and Status
          Row(
            children: [
              Expanded(
                child: Text(
                  'पुस्तक: $bookName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Author
          Text(
            'लेखक: $author',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),

          const SizedBox(height: 12),

          // Info Section with Icons
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'दाता: $donor',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'दान तिथि: $date',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Icon(Icons.category, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'श्रेणी: $category',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation(index, bookName);
                  },
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('हटाएं'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF44336),
                    side: const BorderSide(color: Color(0xFFF44336)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int index, String bookName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('पुस्तक हटाएं'),
          content: Text('क्या आप "$bookName" को हटाना चाहते हैं?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('रद्द करें'),
            ),
            TextButton(
              onPressed: () {
                _donationService.removeDonation(index);
                Navigator.of(context).pop();
                _loadDonations(); // Refresh the data
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('$bookName हटा दी गई')));
              },
              child: const Text('हटाएं', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAllDonations() {
    // Use current donations list
    final allDonations = _donations;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            title: const Text(
              'सभी दान सूची',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...allDonations.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> donation = entry.value;
                  return Column(
                    children: [
                      _buildDonationItem(
                        index: index,
                        bookName: donation['bookName'],
                        author: donation['author'],
                        donor: donation['donor'],
                        date: donation['date'],
                        category: donation['category'],
                        status: donation['status'],
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      // Refresh the main screen when coming back
      _loadDonations();
    });
  }
}
