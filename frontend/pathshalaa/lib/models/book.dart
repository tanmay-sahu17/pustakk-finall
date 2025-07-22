class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final String description;
  final DateTime publishedDate;
  final bool isAvailable;
  final String? borrowedBy;
  final DateTime? borrowedDate;
  final DateTime? dueDate;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
    required this.description,
    required this.publishedDate,
    this.isAvailable = true,
    this.borrowedBy,
    this.borrowedDate,
    this.dueDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      isbn: json['isbn'],
      category: json['category'],
      description: json['description'],
      publishedDate: DateTime.parse(json['publishedDate']),
      isAvailable: json['isAvailable'] ?? true,
      borrowedBy: json['borrowedBy'],
      borrowedDate: json['borrowedDate'] != null
          ? DateTime.parse(json['borrowedDate'])
          : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'category': category,
      'description': description,
      'publishedDate': publishedDate.toIso8601String(),
      'isAvailable': isAvailable,
      'borrowedBy': borrowedBy,
      'borrowedDate': borrowedDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? isbn,
    String? category,
    String? description,
    DateTime? publishedDate,
    bool? isAvailable,
    String? borrowedBy,
    DateTime? borrowedDate,
    DateTime? dueDate,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      category: category ?? this.category,
      description: description ?? this.description,
      publishedDate: publishedDate ?? this.publishedDate,
      isAvailable: isAvailable ?? this.isAvailable,
      borrowedBy: borrowedBy ?? this.borrowedBy,
      borrowedDate: borrowedDate ?? this.borrowedDate,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
