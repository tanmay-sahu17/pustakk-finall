# Copilot Instructions for Pustakalay Flutter App

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview
This is a Flutter mobile application for library management (Pustakalay 2.0) converted from React Native. The app includes features like:

- User authentication (login/signup)
- Book management (add, view, search books)
- Dashboard with statistics
- User profile management
- Book borrowing and returning system

## Code Guidelines
- Use Flutter's Material Design principles
- Follow Flutter naming conventions (camelCase for variables, PascalCase for classes)
- Use StatefulWidget for interactive components and StatelessWidget for static components
- Implement proper state management using Provider or Riverpod
- Use proper folder structure: lib/screens, lib/widgets, lib/models, lib/services
- Follow Dart language guidelines and best practices
- Use async/await for asynchronous operations
- Implement proper error handling with try-catch blocks
- Use const constructors where possible for performance
- Add proper documentation comments for classes and methods

## Architecture
- Follow MVVM or Clean Architecture patterns
- Separate UI, business logic, and data layers
- Use services for API calls and data management
- Implement proper routing using named routes
- Use themes for consistent styling across the app

## Dependencies
- Use pubspec.yaml for dependency management
- Prefer official Flutter packages when available
- Keep dependencies up to date
- Use dev_dependencies for testing and development tools
