import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = AuthService();
        bool success = await authService.login(
          _loginController.text.trim(),
          _passwordController.text.trim(),
        );

        if (success && mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('लॉगिन में त्रुटि: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    final isTablet = screenWidth > 600;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? constraints.maxWidth * 0.2 : 20.0,
                vertical: isSmallScreen ? 10 : 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (isSmallScreen ? 20 : 40),
                ),
                child: Column(
                  children: [
                    SizedBox(height: isSmallScreen ? 40 : 60),

                    // Logo Container
                    Container(
                      width: isSmallScreen ? 100 : (isTablet ? 140 : 120),
                      height: isSmallScreen ? 100 : (isTablet ? 140 : 120),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FD),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: isSmallScreen ? 60 : (isTablet ? 80 : 70),
                          height: isSmallScreen ? 60 : (isTablet ? 80 : 70),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2196F3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Books representation - responsive positioning
                              Positioned(
                                left: isSmallScreen ? 12 : 16,
                                top: isSmallScreen ? 10 : 13,
                                child: Column(
                                  children: [
                                    // First book
                                    Container(
                                      width: isSmallScreen ? 10 : 12,
                                      height: isSmallScreen ? 30 : 35,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      width: isSmallScreen ? 10 : 12,
                                      height: isSmallScreen ? 6 : 7,
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
                              // Second book (taller)
                              Positioned(
                                left: isSmallScreen ? 24 : 30,
                                top: isSmallScreen ? 6 : 8,
                                child: Column(
                                  children: [
                                    Container(
                                      width: isSmallScreen ? 10 : 12,
                                      height: isSmallScreen ? 38 : 45,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      width: isSmallScreen ? 10 : 12,
                                      height: isSmallScreen ? 6 : 7,
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
                              // Third book
                              Positioned(
                                left: isSmallScreen ? 36 : 44,
                                top: isSmallScreen ? 10 : 13,
                                child: Column(
                                  children: [
                                    Container(
                                      width: isSmallScreen ? 10 : 12,
                                      height: isSmallScreen ? 30 : 35,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      width: isSmallScreen ? 10 : 12,
                                      height: isSmallScreen ? 6 : 7,
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
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 20 : 30),

                    // App Title
                    Text(
                      'स्मृति पुस्तकालय',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 24 : (isTablet ? 32 : 28),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                        letterSpacing: 0.5,
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 20 : 30),

                    // Login Form Card
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: isTablet ? 400 : double.infinity,
                      ),
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              // Login ID Label
                              const Text(
                                'लॉगिन आईडी',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Login ID Field
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
                                  controller: _loginController,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'अपनी लॉगिन आईडी दर्ज करें',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFF6B7280),
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'कृपया अपनी लॉगिन आईडी दर्ज करें';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Password Label
                              const Text(
                                'पासवर्ड',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Password Field
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
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'अपना पासवर्ड दर्ज करें',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 14,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF6B7280),
                                      size: 20,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: const Color(0xFF6B7280),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'कृपया अपना पासवर्ड दर्ज करें';
                                    }
                                    if (value.length < 6) {
                                      return 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'पासवर्ड रीसेट लिंक भेजा गया',
                                        ),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                  ),
                                  child: const Text(
                                    'पासवर्ड भूल गए?',
                                    style: TextStyle(
                                      color: Color(0xFF2196F3),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
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
                                      : const Text(
                                          'लॉगिन करें',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),

                            const SizedBox(height: 16),

                            // Terms Text
                            Text(
                              'लॉगिन करके, आप हमारी शर्तों और गोपनीयता नीति से सहमत होते हैं।',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 11 : 12,
                                color: const Color(0xFF6B7280),
                                fontFamily: 'times new roman',
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 16 : 20),

                            // Powered by Text
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Powered by',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 11 : 12,
                                      color: const Color(0xFF6B7280),
                                      fontFamily: 'times new roman',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'SSIPMT RAIPUR',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 16 : (isTablet ? 20 : 18),
                                      color: const Color.fromARGB(255, 56, 116, 212),
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'gotham',
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Version 1.0.0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 10 : 11,
                                      color: const Color.fromARGB(255, 162, 169, 181),
                                      fontFamily: 'Gotham',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 15 : 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
