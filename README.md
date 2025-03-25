# Shopping App - Hava Havai Hiring Challenge

A Flutter shopping app built for the Hava Havai Hiring Challenge. This app demonstrates shopping cart functionality with discount calculation, product listing with pagination, and clean architecture principles.

## Features

- Product catalogue with pagination
- Shopping cart with add, remove, and quantity update functionality
- Discount calculation for products
- Responsive UI design

## Architecture

The app follows Clean Architecture principles with a clear separation of concerns:

```
lib/
  core/
    constants/
    theme/
    utils/
    widgets/
  features/
    catalogue/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        riverpod/
        pages/
        widgets/
    cart/
      data/
      domain/
      presentation/
      widgets/
  main.dart
```

## Technologies Used

- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Network & API**: Dio and Retrofit
- **Data Handling**: JSON serialization
- **UI Components**: Material 3 Design
- **Architecture**: Clean Architecture

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/shopping_app.git
   ```

2. Navigate to the project directory
   ```bash
   cd shopping_app
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Run code generation (for Retrofit, JSON Serializable, etc.)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Run the app
   ```bash
   flutter run
   ```

## Usage

- Browse the product catalogue
- Click on a product to see details
- Add products to cart
- Update quantities in the cart
- View total price with discounts applied

## API Integration

The app fetches products from [DummyJSON](https://dummyjson.com/products) API, which provides mock product data for testing and development.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

This project was created as part of the Hava Havai Hiring Challenge.
