
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../config/app_config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Auto-detect device type and use appropriate IP
  static String get baseUrl {
    return AppConfig.apiBaseUrl;
  }
  
  User? _currentUser;
  bool _isLoggedIn = false;
  String? _token;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  // Initialize auth state from stored token
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      
      if (_token != null) {
        // Verify token and get user info
        await _getCurrentUser();
      }
    } catch (e) {
      print('Error initializing auth: $e');
    }
  }

  Future<bool> login(String userId, String password) async {
    try {
      print('Attempting login with userId: $userId');
      print('API URL: ${AppConfig.authLoginUrl}');
      
      final response = await http.post(
        Uri.parse(AppConfig.authLoginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': userId,   // Send as username to match backend expectation
          'id': userId,         // Also send as id for database id field compatibility
          'password': password,
        }),
      ).timeout(
        Duration(seconds: 30), // Increased timeout
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Backend sends token directly in response
        _token = data['token'];
        final userData = data['user'];
        
        if (_token != null && userData != null) {
          // Save token and user data to local storage
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', _token!);
          await prefs.setString('current_user', json.encode(userData));
          
          // Create user object from response
          _currentUser = User(
            id: userData['id']?.toString() ?? userData['userId']?.toString() ?? '',
            name: userData['username'] ?? userData['name'] ?? 'User',
            email: userData['email'] ?? '',
            phone: userData['phone'] ?? '',
            role: UserRole.member,
            createdAt: DateTime.now(),
            borrowedBookIds: userData['borrowedBooks'] ?? [],
          );
          
          _isLoggedIn = true;
          print('API login successful - Token saved persistently');
          return true;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        final error = json.decode(response.body);
        print('Login failed: ${error['message']}');
        throw Exception(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Error during login');
    }
  }

  Future<bool> register(
    String userId,
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Auto-login after successful registration
        return await login(userId, password);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        );
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      // Clear local state regardless of API call result
      _currentUser = null;
      _isLoggedIn = false;
      _token = null;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      // Note: This endpoint might not be implemented in backend yet
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  Future<bool> updateProfile(User updatedUser) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'username': updatedUser.name,
          'email': updatedUser.email,
          'phone': updatedUser.phone,
        }),
      );

      if (response.statusCode == 200) {
        _currentUser = updatedUser;
        return true;
      }
      return false;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }

  Future<void> _getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        _currentUser = User(
          id: userData['_id'] ?? userData['id'],
          name: userData['username'] ?? userData['name'],
          email: userData['email'],
          phone: userData['phone'] ?? '',
          role: UserRole.member,
          createdAt: DateTime.now(),
          borrowedBookIds: userData['borrowedBooks'] ?? [],
        );
        _isLoggedIn = true;
      } else {
        // Token is invalid, clear it
        await logout();
      }
    } catch (e) {
      print('Get current user error: $e');
      await logout();
    }
  }

  Map<String, String> get authHeaders {
    if (_token != null && _token!.isNotEmpty) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }

  // Clear auth data from persistent storage (for logout)
  Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('current_user');
      _token = null;
      _currentUser = null;
      _isLoggedIn = false;
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  // Check if user is logged in from stored data
  Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Get current user data from storage
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('current_user');
      
      if (userDataString != null) {
        return json.decode(userDataString);
      }
      return null;
    } catch (e) {
      print('Error getting current user data: $e');
      return null;
    }
  }

  // Get current user ID/username
  Future<String?> getCurrentUserId() async {
    final userData = await getCurrentUserData();
    return userData?['userId'] ?? userData?['username'] ?? userData?['id']?.toString();
  }
}
