# Adisyon App

A restaurant management system built with Flutter using clean architecture principles.

## Project Structure

```
lib/
├── core/
│   ├── config/         # App configuration and dependency injection
│   ├── constants/      # App-wide constants
│   ├── errors/         # Error handling and failures
│   ├── network/        # Network client and interceptors
│   ├── theme/          # App theme configuration
│   └── utils/          # Utility classes and functions
├── features/
│   ├── auth/          # Authentication feature
│   │   ├── data/      # Data layer (repositories, models, datasources)
│   │   ├── domain/    # Domain layer (entities, repositories, usecases)
│   │   └── presentation/ # UI layer (pages, widgets, controllers)
│   ├── dashboard/     # Dashboard feature
│   ├── menu/          # Menu management feature
│   ├── orders/        # Order management feature
│   └── settings/      # App settings feature
└── shared/
    ├── widgets/       # Shared widgets
    └── services/      # Shared services
```

## Architecture

This project follows Clean Architecture principles with three main layers:

1. **Presentation Layer**
   - Pages
   - Widgets
   - Controllers (using Riverpod)

2. **Domain Layer**
   - Entities
   - Repository Interfaces
   - Use Cases

3. **Data Layer**
   - Models
   - Repository Implementations
   - Data Sources

## State Management

- Uses Riverpod for state management
- Controllers handle business logic
- UI states are managed using freezed

## Dependencies

- **State Management**
  - flutter_riverpod
  - riverpod_annotation

- **Routing**
  - auto_route

- **Dependency Injection**
  - get_it

- **Code Generation**
  - freezed
  - json_annotation

- **Network**
  - dio

- **Local Storage**
  - shared_preferences
  - sqflite

- **Utilities**
  - dartz
  - logger
  - intl

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Development Guidelines

### Code Style

- Follow the official Dart style guide
- Use English for all code and documentation
- Declare types for all variables and functions
- Use meaningful variable and function names
- Keep functions small and focused

### Architecture Guidelines

- Follow SOLID principles
- Use dependency injection
- Keep layers separated
- Use repository pattern for data access
- Handle errors using Either type from dartz

### Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for features
- Follow AAA (Arrange-Act-Assert) pattern

## Contributing

1. Create a feature branch
2. Make your changes
3. Write tests
4. Create a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
