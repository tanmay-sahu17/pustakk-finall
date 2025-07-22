import 'package:flutter/material.dart';
import '../services/donation_service.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final DonationService _donationService = DonationService();
  
  List<Map<String, dynamic>> _donations = [];
  Map<String, int> _statistics = {'total': 0, 'approved': 0, 'pending': 0};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final donations = await _donationService.getAllDonations();
      final statistics = await _donationService.getDonationStatistics();
      
      setState(() {
        _donations = donations;
        _statistics = statistics;
        _isLoading = false;
      });
    } catch (e) {
      print('Dashboard load error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/donate').then((_) => _loadData());
    } else {
      setState(() => _selectedIndex = index);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.auto_stories,
                    value: '${_statistics['total'] ?? 0}',
                    label: 'कुल\nपुस्तकें',
                    iconColor: const Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle,
                    value: '${_statistics['approved'] ?? 0}',
                    label: 'स्वीकृत\nपुस्तकें',
                    iconColor: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.access_time,
                    value: '${_statistics['pending'] ?? 0}',
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

            // Donation Statistics Card
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
                  const Text(
                    'दान आंकड़े (Donation Statistics)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Statistics Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.card_giftcard,
                          value: '${_donationService.getTotalDonations()}',
                          label: 'कुल दान',
                          iconColor: const Color(0xFF9C27B0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.calculate,
                          value: '${(_donationService.getUniqueDonors() > 0 ? (_donationService.getTotalDonations() / _donationService.getUniqueDonors()).round() : 0)}',
                          label: 'औसत पुस्तकें/\nदाता',
                          iconColor: const Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Bottom Statistics Card
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.calendar_today,
                          value: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          label: 'आज की तारीख',
                          iconColor: const Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                      TextButton.icon(
                        onPressed: () => _showAllDonations(),
                        icon: const Icon(Icons.list, size: 16),
                        label: const Text('सभी देखें'),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF2196F3),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Donation Items
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_donations.isEmpty)
                    const Center(child: Text('कोई दान रिकॉर्ड नहीं मिला'))
                  else
                    ..._donations.take(3).toList().asMap().entries.map(
                      (entry) {
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
                      },
                    ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E5E9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              height: 1.2,
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
                setState(() {}); // Refresh the UI
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
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('सभी दान रिकॉर्ड', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _donations.isEmpty
                        ? const Center(child: Text('कोई दान रिकॉर्ड नहीं मिला'))
                        : ListView.builder(
                            itemCount: _donations.length,
                            itemBuilder: (context, index) {
                              final d = _donations[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(d['bookName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text('लेखक: ${d['author']}'),
                                      Text('दाता: ${d['donor']}'),
                                      Text('श्रेणी: ${d['category']}'),
                                      Text('दिनांक: ${d['date']}'),
                                      Text('स्थिति: ${d['status']}'),
                                      if (d['description']?.isNotEmpty == true) Text('विवरण: ${d['description']}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
