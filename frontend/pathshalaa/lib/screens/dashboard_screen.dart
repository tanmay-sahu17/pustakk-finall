import 'package:flutter/material.dart';
import '../services/donation_service.dart';
import '../services/auth_service.dart';

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

    // print('🔍 Dashboard: Starting to load donations...');
    
    try {
      // Initialize donation service first
      await _donationService.initialize();
      
      // Test API connection
      final apiConnected = await _donationService.testApiConnection();
      // print('🔍 Dashboard: API Connection result: $apiConnected');
      
      // Load donations from API
      final donations = await _donationService.getDonationsAsync();
      // print('🔍 Dashboard: Received ${donations.length} donations from service');
      // print('🔍 Dashboard: Donations data: $donations');
      
      if (mounted) {
        setState(() {
          _donations = donations;
          _isLoading = false;
        });
        // print('🔍 Dashboard: State updated with ${_donations.length} donations');
        
        
        // Show connection status only if there are issues
        if (!apiConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ Problem in server'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
        // Note: Login success message should only be shown from login screen, not here
      }
    } catch (e) {
      // print('❌ Dashboard: Error loading donations: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ डेटा लोड करने में त्रुटि: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
        actions: [
          IconButton(
            onPressed: _showLogoutConfirmation,
            icon: const Icon(Icons.logout),
            tooltip: 'लॉगआउट',
          ),
        ],
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
            // Stats Cards - 2x2 Grid
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
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle,
                    value: '${_donations.where((d) => d['status'] == 'स्वीकृत').length}',
                    label: 'स्वीकृत\nपुस्तकें',
                    iconColor: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.access_time,
                    value: '${_donations.where((d) => d['status'] == 'समीक्षा में').length}',
                    label: 'लंबित\nपुस्तकें',
                    iconColor: const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(width: 16),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive sizes based on available width
        double cardWidth = constraints.maxWidth;
        double iconSize = (cardWidth * 0.15).clamp(26.0, 34.0);
        double fontSize = (cardWidth * 0.14).clamp(24.0, 30.0);
        double labelFontSize = (cardWidth * 23).clamp(12.0, 15.0);
        
        return Container(
          height: 140,
          padding: EdgeInsets.symmetric(
            horizontal: (cardWidth * 0.08).clamp(12.0, 20.0),
            vertical: 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, iconColor.withValues(alpha: 0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: iconColor.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all((iconSize * 0.4).clamp(10.0, 16.0)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withValues(alpha: 0.15),
                      iconColor.withValues(alpha: 0.25),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: iconSize),
              ),
              SizedBox(height: (cardWidth * 0.04).clamp(8.0, 12.0)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              SizedBox(height: (cardWidth * 0.02).clamp(2.0, 6.0)),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
              onPressed: () async {
                Navigator.of(context).pop();
                
                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('पुस्तक हटाई जा रही है...')),
                );

                try {
                  final success = await _donationService.removeDonation(index);
                  if (success) {
                    _loadDonations(); // Refresh the data
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$bookName सफलतापूर्वक हटा दी गई')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$bookName हटाने में त्रुटि हुई'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('नेटवर्क त्रुटि: पुस्तक नहीं हटाई जा सकी'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('लॉगआउट'),
          content: const Text('क्या आप वाकई लॉगआउट करना चाहते हैं?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('रद्द करें'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performLogout();
              },
              child: const Text('लॉगआउट', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('लॉगआउट हो रहे हैं...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Clear auth data from storage using AuthService
      final authService = AuthService();
      await authService.clearAuthData();
      
      // Navigate to login and clear all previous routes
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('लॉगआउट में त्रुटि: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
