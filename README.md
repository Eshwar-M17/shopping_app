# ShopEase - Modern Flutter Shopping App

![Flutter Version](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart Version](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Null Safety](https://img.shields.io/badge/Null%20Safety-Enabled-brightgreen.svg)

A modern, feature-rich shopping application built with Flutter that demonstrates clean architecture, responsive design, and efficient state management using Riverpod. This app provides a seamless shopping experience with comprehensive error handling, performance optimizations, and a modular codebase.

## 🎥 Demo Video

[<img src="https://img.youtube.com/vi/PLACEHOLDER/0.jpg" width="600">](https://www.youtube.com/watch?v=PLACEHOLDER "ShopEase Demo")

*Coming soon: Click the image above to watch a demo of ShopEase in action*

## 📱 Screenshots

<div style="display: flex; flex-direction: row; flex-wrap: wrap; gap: 10px; justify-content: center;">
  <img src="screenshots/screenshot_1.png" alt="Product Catalogue" width="200"/>
  <img src="screenshots/screenshot_2.png" alt="Product Details" width="200"/>
  <img src="screenshots/screenshot_3.png" alt="Shopping Cart" width="200"/>
  <img src="screenshots/screenshot_4.png" alt="Checkout" width="200"/>
</div>

*Screenshots placeholder - Replace with actual app screenshots*

## ✨ Key Features

- **Product Catalogue** - Browse through a wide range of products with smooth pagination
- **Detailed Product Pages** - View comprehensive product details, specifications, and images
- **Shopping Cart** - Add, remove, and update quantities with real-time price calculations
- **Discount System** - Automatic discount calculations based on product pricing rules
- **Responsive Design** - Optimized for both mobile and tablet layouts
- **Offline Support** - Basic functionality available when offline
- **Advanced Error Handling** - User-friendly error messages and recovery options
- **Null Safety** - Fully null-safe code with proper error handling for API responses

## 🏗️ Architecture

The app follows a Clean Architecture approach with a clear separation of concerns:

```
lib/
  core/              # Core utilities, constants, and reusable components
    constants/       # App-wide constants
    theme/           # Theme configuration
    utils/           # Utility functions and classes
    widgets/         # Reusable UI components
  features/          # Feature modules
    catalogue/       # Product catalogue feature
      data/          # Data layer with API integration
      domain/        # Business logic & entities
      presentation/  # UI components & state management
    cart/            # Shopping cart feature
      data/
      domain/
      presentation/
  main.dart          # Application entry point
```

This architecture provides:
- **Testability** - Independent layers that can be tested in isolation
- **Maintainability** - Clear boundaries between components
- **Scalability** - Easy addition of new features without affecting existing code

## 🚀 Performance Optimizations

The app includes numerous performance optimizations:

- **Widget Composition** - Breaking down complex widgets into smaller, focused components
- **Const Constructors** - Extensive use of const constructors to minimize rebuilds
- **Lazy Loading** - Efficient pagination with lazy loading for product lists
- **Image Caching** - Optimized image loading with proper caching strategies
- **Memoization** - Pre-computing values outside build methods to reduce repeated calculations
- **Efficient UI Updates** - Strategic widget rebuilds only when necessary
- **Optimized Error Handling** - Graceful error handling with minimal UI disruption
- **Custom JSON Serialization** - Robust handling of API responses with null safety
- **Smart Resource Management** - Proper cleanup of resources to prevent memory leaks

## 🛠️ Technologies Used

- **State Management**: [Riverpod](https://riverpod.dev/) for efficient, testable state management
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router) for declarative routing
- **Network & API**: [Dio](https://pub.dev/packages/dio) and [Retrofit](https://pub.dev/packages/retrofit) for type-safe API integration
- **Image Handling**: [CachedNetworkImage](https://pub.dev/packages/cached_network_image) for efficient image loading and caching
- **Data Classes**: [Freezed](https://pub.dev/packages/freezed) for immutable data models
- **Dependency Injection**: Simple service locator pattern for dependency management
- **UI Framework**: Material 3 Design components for a modern look and feel

## 🛡️ Error Handling

The app implements comprehensive error handling strategies:

- **API Error Handling** - Graceful handling of network errors with user-friendly messages
- **Null Safety** - Full implementation of Dart's null safety features
- **Safe Getters** - Custom getters to safely access potentially null data
- **Retry Mechanisms** - User-friendly retry options for failed operations
- **Custom Error Widgets** - Consistent error UI components across the app
- **Typed Failures** - Domain-specific error types for precise error handling
- **Error Reporting** - Structured error reporting for easier debugging
- **Global Error Handler** - Centralized error handling utility for consistent error management

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/shopease.git
   ```

2. Navigate to the project directory
   ```bash
   cd shopease
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Run code generation for API clients and data models
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Run the app
   ```bash
   flutter run
   ```

## 💡 Usage

- **Browse Products**: Scroll through the product catalogue and use the search feature to find specific items
- **View Product Details**: Tap on a product to see detailed information, specifications, and additional images
- **Add to Cart**: Add products to your shopping cart with a single tap
- **Manage Cart**: View your cart, update quantities, or remove items as needed
- **View Discounts**: See applied discounts and final prices in real-time

## 🔌 API Integration

The app integrates with the [DummyJSON](https://dummyjson.com/products) API, which provides:
- Product information and images
- Category data
- Price and discount information

## 🧪 Testing

The application includes:
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for feature workflows

Run tests with:
```bash
flutter test
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) for the amazing cross-platform framework
- [DummyJSON](https://dummyjson.com/) for the API service used in this project
- All the open-source package maintainers whose work made this project possible
