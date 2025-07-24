import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import 'auth_service.dart';

class BookService {
  static final BookService _instance = BookService._internal();
  factory BookService() => _instance;
  BookService._internal();

  static const String baseUrl = 'http://10.0.2.2:9006/api';
  final AuthService _authService = AuthService();

  Future<List<Book>> getAllBooks({
    String? title,
    String? author,
    String? genre,
    bool? available,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (title != null && title.isNotEmpty) queryParams['title'] = title;
      if (author != null && author.isNotEmpty) queryParams['author'] = author;
      if (genre != null && genre.isNotEmpty) queryParams['genre'] = genre;
      if (available != null) queryParams['available'] = available.toString();

      final uri = Uri.parse('$baseUrl/books').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: _authService.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> booksJson = data['books'] ?? data;
        
        return booksJson.map((bookJson) => _bookFromJson(bookJson)).toList();
      } else {
        print('Failed to load books: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting all books: $e');
      return [];
    }
  }

  Future<List<Book>> getBooksByCategory(String category) async {
    if (category == 'All') {
      return getAllBooks();
    }
    return getAllBooks(genre: category);
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      return getAllBooks(title: query);
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  Future<Book?> getBookById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/$id'),
        headers: _authService.authHeaders,
      );

      if (response.statusCode == 200) {
        final bookJson = json.decode(response.body);
        return _bookFromJson(bookJson);
      }
      return null;
    } catch (e) {
      print('Error getting book by ID: $e');
      return null;
    }
  }

  Future<bool> donateBook({
    required String title,
    required String author,
    String? description,
    String? genre,
    String? isbn,
    String? condition,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations'),
        headers: _authService.authHeaders,
        body: json.encode({
          'title': title,
          'author': author,
          'description': description,
          'genre': genre,
          'isbn': isbn,
          'condition': condition,
          'userId': _authService.currentUser?.id,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error donating book: $e');
      return false;
    }
  }

  Future<bool> borrowBook(String bookId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions/borrow'),
        headers: _authService.authHeaders,
        body: json.encode({
          'bookId': bookId,
          'userId': _authService.currentUser?.id,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error borrowing book: $e');
      return false;
    }
  }

  Future<bool> returnBook(String bookId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions/return'),
        headers: _authService.authHeaders,
        body: json.encode({
          'bookId': bookId,
          'userId': _authService.currentUser?.id,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error returning book: $e');
      return false;
    }
  }

  Future<List<Book>> getUserBorrowedBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions/user/${_authService.currentUser?.id}/borrowed'),
        headers: _authService.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> booksJson = data['books'] ?? [];
        
        return booksJson.map((bookJson) => _bookFromJson(bookJson)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting borrowed books: $e');
      return [];
    }
  }

  Future<Map<String, int>> getBookStatistics() async {
    try {
      final books = await getAllBooks();
      final total = books.length;
      final available = books.where((book) => book.isAvailable).length;
      final borrowed = total - available;

      return {'total': total, 'available': available, 'borrowed': borrowed};
    } catch (e) {
      print('Error getting book statistics: $e');
      return {'total': 0, 'available': 0, 'borrowed': 0};
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/categories'),
        headers: _authService.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['categories'] ?? []);
      }
      return ['Fiction', 'Technology', 'History', 'Science', 'Biography'];
    } catch (e) {
      print('Error getting categories: $e');
      return ['Fiction', 'Technology', 'History', 'Science', 'Biography'];
    }
  }

  // Helper method to convert JSON to Book object
  Book _bookFromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      category: json['genre'] ?? json['category'] ?? 'General',
      description: json['description'] ?? '',
      publishedDate: json['publishedDate'] != null 
          ? DateTime.tryParse(json['publishedDate']) ?? DateTime.now()
          : DateTime.now(),
      isAvailable: json['available'] == true || (json['availableCopies'] ?? 0) > 0,
      borrowedBy: json['borrowedBy'],
      borrowedDate: json['borrowedDate'] != null 
          ? DateTime.tryParse(json['borrowedDate'])
          : null,
      dueDate: json['dueDate'] != null 
          ? DateTime.tryParse(json['dueDate'])
          : null,
    );
  }
}
