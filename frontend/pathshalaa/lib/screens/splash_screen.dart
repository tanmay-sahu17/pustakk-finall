import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for 2 seconds for splash effect
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user is already logged in
    final authService = AuthService();
    final isLoggedIn = await authService.isUserLoggedIn();
    
    if (mounted) {
      if (isLoggedIn) {
        // User is logged in, go to dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // User is not logged in, go to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F51B5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.library_books,
                color: Color(0xFF3F51B5),
                size: 60,
              ),
            ),
            const SizedBox(height: 30),
            
            // App Name
            const Text(
              'Pustakalay 2.0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            
            // Tagline
            const Text(
              'Your Digital Library',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 50),
            
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
