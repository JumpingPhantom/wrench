# Project Structure

lib/
├── app/
│   ├── app.dart                  # Root MaterialApp/CupertinoApp setup
│   ├── router.dart               # GoRouter/AppRouter configuration
│   └── theme.dart                # App-wide themes, colors, typography
│
├── core/                         # Shared utilities, services, & constants
│   ├── constants/                # API endpoints, assets paths, strings
│   ├── errors/                   # Custom failure/exception classes
│   ├── network/
│   │   ├── api_client.dart       # Dio instance configuration (interceptors, base URL)
│   │   └── api_result.dart       # Network response wrapper (Success/Failure)
│   ├── utils/                    # Formatters, extension methods, helpers
│   └── widgets/                  # Generic UI components (custom buttons, loading indicators)
│
├── features/                     # Self-contained modules/domains
│   │
│   ├── auth/                     # Example Feature 1: Authentication
│   │   ├── data/
│   │   │   ├── models/           # User model, Auth tokens (Freezed/json_serializable)
│   │   │   ├── repositories/     # Auth repository implementation
│   │   │   └── sources/          # Remote API calls (using Dio) & Local storage (SharedPreferences)
│   │   ├── presentation/
│   │   │   ├── controllers/      # Riverpod Notifiers/Providers for Auth state
│   │   │   ├── screens/          # LoginScreen, RegisterScreen
│   │   │   └── widgets/          # LoginButton, PasswordInputField
│   │   └── domain/               # Optional: Pure business logic (entities/use cases if using Clean Architecture)
│   │
│   └── products/                 # Example Feature 2: Product Catalog
│       ├── data/
│       │   ├── models/           # ProductModel
│       │   ├── repositories/     # ProductRepository
│       │   └── sources/          # Product remote data source
│       └── presentation/
│           ├── controllers/      # ProductListNotifier, ProductDetailNotifier
│           ├── screens/          # ProductCatalogScreen, ProductDetailScreen
│           └── widgets/          # ProductCard, PriceTag
│
└── main.dart                     # Entry point (wraps app in ProviderScope)
