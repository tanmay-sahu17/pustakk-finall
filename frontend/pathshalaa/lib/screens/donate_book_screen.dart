import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../services/donation_service.dart';

class DonateBookScreen extends StatefulWidget {
  const DonateBookScreen({super.key});

  @override
  State<DonateBookScreen> createState() => _DonateBookScreenState();
}

class _DonateBookScreenState extends State<DonateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _donorNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _bookNameController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _isbnController = TextEditingController();

  String _selectedCategory = 'Fiction';
  String _selectedCondition = 'New';
  XFile? _selectedImage;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  final List<String> _categories = [
    'Fiction',
    'Non-Fiction',
    'Educational',
    'Religious',
    'Children',
    'Biography',
    'History',
    'Science',
    'Literature',
  ];

  final List<String> _conditions = ['New', 'Like New', 'Good', 'Fair', 'Poor'];

  @override
  void dispose() {
    _donorNameController.dispose();
    _mobileController.dispose();
    _bookNameController.dispose();
    _authorNameController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _submitDonation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        print('🔄 Submitting donation to backend...');
        
        // Add donation to service with proper API call
        final donationService = DonationService();
        final success = await donationService.addDonation(
          bookName: _bookNameController.text.trim(),
          author: _authorNameController.text.trim(),
          donorName: _donorNameController.text.trim(),
          category: _selectedCategory,
          condition: _selectedCondition,
          description: 'Mobile: ${_mobileController.text.trim()}${_isbnController.text.isNotEmpty ? ', ISBN: ${_isbnController.text.trim()}' : ''}',
        );

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ पुस्तक दान सफलतापूर्वक सबमिट हो गई!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );

            // Clear form
            _formKey.currentState!.reset();
            _donorNameController.clear();
            _mobileController.clear();
            _bookNameController.clear();
            _authorNameController.clear();
            _isbnController.clear();
            setState(() {
              _selectedImage = null;
              _imageBytes = null;
              _selectedCategory = 'Fiction';
              _selectedCondition = 'New';
            });

            // Navigate to dashboard with a delay to show success message
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ दान सबमिट करने में त्रुटि हुई। कृपया फिर से कोशिश करें।'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        print('❌ Error submitting donation: $e');
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ नेटवर्क त्रुटि: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
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
          'दान फॉर्म',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card with Logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2196F3),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Stack(
                      children: [
                        // Books representation (same as login screen)
                        Positioned(
                          left: 18,
                          top: 15,
                          child: Column(
                            children: [
                              Container(
                                width: 14,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: 14,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1976D2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 34,
                          top: 10,
                          child: Column(
                            children: [
                              Container(
                                width: 14,
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: 14,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1976D2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 50,
                          top: 15,
                          child: Column(
                            children: [
                              Container(
                                width: 14,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: 14,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1976D2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'दान फॉर्म',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Main Form Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Donor Information Section
                    const Text(
                      'दाता की जानकारी',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Donor Name
                    const Text(
                      'दाता का नाम *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE1E5E9),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _donorNameController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'पूरा नाम दर्ज करें',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'कृपया दाता का नाम दर्ज करें';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Mobile Number
                    const Text(
                      'मोबाइल नंबर *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE1E5E9),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'मोबाइल नंबर दर्ज करें',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'कृपया मोबाइल नंबर दर्ज करें';
                          }
                          if (value.length != 10) {
                            return 'मोबाइल नंबर 10 अंकों का होना चाहिए';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'केवल नंबर दर्ज करें';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Donation Date
                    const Text(
                      'दान की तिथि',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE1E5E9),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Book Information Section
                    const Text(
                      'पुस्तक की जानकारी',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Book Name
                    const Text(
                      'पुस्तक का नाम *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE1E5E9),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _bookNameController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'पुस्तक का नाम दर्ज करें',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'कृपया पुस्तक का नाम दर्ज करें';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Author Name
                    const Text(
                      'लेखक का नाम',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE1E5E9),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _authorNameController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'लेखक का नाम दर्ज करें',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ISBN Number
                    const Text(
                      'ISBN नंबर',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE1E5E9),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _isbnController,
                        keyboardType: TextInputType.number,
                        maxLength: 13,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'ISBN नंबर दर्ज करें (13 अंक)',
                          hintStyle: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (value.length != 13) {
                              return 'ISBN नंबर 13 अंकों का होना चाहिए';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'केवल नंबर दर्ज करें';
                            }
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Category Dropdown
                    const Text(
                      'श्रेणी',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE1E5E9),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                        dropdownColor: Colors.white,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }
                        },
                        items: _categories.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Condition Dropdown
                    const Text(
                      'पुस्तक की स्थिति',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE1E5E9),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedCondition,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                        dropdownColor: Colors.white,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCondition = newValue;
                            });
                          }
                        },
                        items: _conditions.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Book Image Section
                    const Text(
                      'पुस्तक की छवि',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Image Selection Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickImageFromGallery,
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE1E5E9),
                                  width: 1,
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    size: 32,
                                    color: Color(0xFF2196F3),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'गैलरी से चुनें',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2196F3),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickImageFromCamera,
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE1E5E9),
                                  width: 1,
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 32,
                                    color: Color(0xFF2196F3),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'फोटो लें',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2196F3),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Show selected image
                    if (_selectedImage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE1E5E9),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _imageBytes != null 
                            ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                            : const Icon(Icons.image, size: 50),
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitDonation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: const Color(
                            0xFF2196F3,
                          ).withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'दान सबमिट करें',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
