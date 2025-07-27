# Server URL Configuration

## How to Change Server URL

The server URL is centralized in the `lib/config/app_config.dart` file. To change the server URL for different environments:

### For Android Emulator:
```dart
static const String serverUrl = 'http://165.22.208.62:5010';
```

### For Real Android Device (on same network):
```dart
static const String serverUrl = 'http://192.168.29.44:9000';
```

### For Web/Desktop Development:
```dart
static const String serverUrl = 'http://165.22.208.62:5010';
```

### For Production:
```dart
static const String serverUrl = 'https://your-production-server.com';
```

## Usage

Just uncomment the line you need and comment out the others. The app will automatically use the configured URL for all API calls.

## Benefits

- ✅ Single place to change server URL
- ✅ Easy switching between development/production
- ✅ All services automatically use the same configuration
- ✅ Clear documentation of all endpoints

## API Endpoints Available

- Login: `{serverUrl}/api/auth/login`
- Donations: `{serverUrl}/api/donations`
- Test: `{serverUrl}/api/test`

All endpoints are automatically generated from the base server URL.
