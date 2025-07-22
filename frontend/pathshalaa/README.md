# Pustakalay 2.0 - Flutter Library Management App

A modern, user-friendly Flutter application for library management. This app has been converted from React Native to Flutter, providing a seamless cross-platform experience for managing books, users, and library operations.

## Features

### 📚 Book Management
- Add, edit, and delete books
- Search and filter books by category
- View book details and availability status
- Track borrowed and returned books

### 👤 User Management
- User authentication (login/signup)
- User profile management
- Role-based access (Admin, Librarian, Member)
- User statistics and borrowing history

### 📊 Dashboard
- Library statistics overview
- Recent activities tracking
- Quick access to all features
- Real-time data updates

### 🔍 Search & Filter
- Advanced search functionality
- Category-based filtering
- Real-time search results
- Sort by various criteria

## Screenshots

*Screenshots will be added here*

## Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/pustakalay-flutter.git
cd pustakalay-flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── book.dart
│   └── user.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── books_screen.dart
│   └── profile_screen.dart
├── services/                 # Business logic
│   ├── auth_service.dart
│   └── book_service.dart
└── widgets/                  # Reusable widgets
    ├── book_card.dart
    └── common_widgets.dart
```

## Dependencies

- **flutter**: Cross-platform UI framework
- **provider**: State management
- **http**: API communication
- **shared_preferences**: Local storage
- **go_router**: Navigation management
- **intl**: Internationalization
- **image_picker**: Image selection
- **cached_network_image**: Image caching

## API Integration

The app is designed to work with a RESTful API. Currently, it uses mock data for demonstration purposes. To integrate with a real backend:

1. Update the service classes in `lib/services/`
2. Replace mock data with actual API calls
3. Handle authentication tokens
4. Implement error handling for network requests

## State Management

The app uses Provider for state management, providing:
- Reactive UI updates
- Centralized state management
- Easy testing and debugging
- Separation of concerns

## Testing

Run tests using:
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@pustakalay.com or create an issue in this repository.

## Changelog

### Version 1.0.0
- Initial Flutter conversion from React Native
- Complete UI redesign with Material Design
- Improved performance and user experience
- Cross-platform compatibility (Android, iOS, Web)

## Future Enhancements

- [ ] Offline mode support
- [ ] Push notifications
- [ ] Barcode scanning for books
- [ ] Advanced reporting features
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Export data functionality

---

**Pustakalay 2.0** - Digitizing libraries, one book at a time. 📚A Flutter library management application converted from React Native

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
