/// Application Constants
/// Centralized configuration for EthioShop
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'EthioShop';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.ethio.shop';

  // Ethiopian Currency
  static const String currencyCode = 'ETB';
  static const String currencySymbol = 'Br';
  static const int currencyDecimalDigits = 2;

  // Ethiopian Regions
  static const List<String> ethiopianRegions = [
    'Addis Ababa',
    'Afar',
    'Amhara',
    'Benishangul-Gumuz',
    'Dire Dawa',
    'Gambela',
    'Harari',
    'Oromia',
    'Sidama',
    'Somali',
    'South West Ethiopia',
    'Southern Nations',
    'Tigray',
  ];

  // Major Cities for Delivery
  static const List<String> majorCities = [
    'Addis Ababa',
    'Dire Dawa',
    'Mekelle',
    'Gondar',
    'Bahir Dar',
    'Hawassa',
    'Adama',
    'Jimma',
    'Dessie',
    'Shashamane',
    'Debre Markos',
    'Jigjiga',
    'Sodo',
    'Arba Minch',
    'Harar',
    'Wolaita Sodo',
  ];

  // Product Categories
  static const List<String> productCategories = [
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Beauty & Personal Care',
    'Sports & Outdoors',
    'Toys & Games',
    'Books & Stationery',
    'Food & Beverages',
    'Health & Wellness',
    'Automotive',
    'Handmade & Crafts',
    'Agricultural Products',
    'Industrial Equipment',
    'Services',
  ];

  // Payment Methods
  static const String chapaPaymentUrl = 'https://api.chapa.co/v1/transaction/initialize';
  static const String chapaBaseUrl = 'https://api.chapa.co';
  static const int paymentTimeoutSeconds = 900; // 15 minutes
  static const int escrowReleaseDays = 7;

  // Delivery Fee Structure
  static const double freeDeliveryThreshold = 1000.0; // ETB
  static const double standardDeliveryFee = 50.0; // ETB
  static const double expressDeliveryFee = 100.0; // ETB

  // Order Status
  static const List<String> orderStatuses = [
    'pending',
    'confirmed',
    'processing',
    'shipped',
    'out_for_delivery',
    'delivered',
    'cancelled',
    'returned',
  ];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int productsPerPage = 20;
  static const int ordersPerPage = 10;
  static const int messagesPerPage = 50;
  static const int reviewsPerPage = 10;

  // Image Constraints
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxProductImages = 5;
  static const int maxReviewImages = 3;
  static const int avatarMaxSize = 2 * 1024 * 1024; // 2MB
  static const int maxProductImageSizeKB = 1000;
  static const int maxProfileImageSizeKB = 500;

  // Image Dimensions
  static const int productImageWidth = 800;
  static const int productImageHeight = 800;
  static const int thumbnailWidth = 200;
  static const int thumbnailHeight = 200;
  static const int avatarWidth = 400;
  static const int avatarHeight = 400;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxProductNameLength = 100;
  static const int maxProductDescriptionLength = 2000;
  static const int maxReviewCommentLength = 500;
  static const int maxMessageLength = 1000;

  // Phone Number (Ethiopian format)
  static const String ethiopianPhonePattern = r'^(\+251|0)(9|7)\d{8}$';
  static const String ethiopiaCountryCode = '+251';
  static const int ethiopiaPhoneNumberLength = 9;

  // Cart
  static const int maxCartQuantity = 99;
  static const int maxCartItems = 100;

  // Orders
  static const int orderCancellationTimeoutMinutes = 30;
  static const int orderAutoConfirmHours = 24;

  // Notifications
  static const int notificationRetentionDays = 30;

  // Cache
  static const int cacheExpirationHours = 24;
  static const Duration cacheDuration = Duration(hours: 24);

  // URLs
  static const String privacyPolicyUrl = 'https://ethioshop.com/privacy';
  static const String termsOfServiceUrl = 'https://ethioshop.com/terms';
  static const String supportUrl = 'https://ethioshop.com/support';

  // Storage Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyCartItems = 'cart_items';

  // Hive Box Names
  static const String boxCart = 'cart_box';
  static const String boxPreferences = 'preferences_box';
  static const String boxCache = 'cache_box';
  static const String boxMessages = 'messages_box';

  // Database
  static const int databaseVersion = 1;

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String reviewsCollection = 'reviews';
  static const String notificationsCollection = 'notifications';
  static const String wishlistsCollection = 'wishlists';
  static const String categoriesCollection = 'categories';

  // Timeout Durations
  static const int defaultTimeoutSeconds = 30;
  static const int uploadTimeoutSeconds = 300;
  static const int downloadTimeoutSeconds = 60;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Review Constraints
  static const int minReviewRating = 1;
  static const int maxReviewRating = 5;

  // Message Constraints
  static const int maxMessageImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxMessageImages = 1;

  // Admin
  static const int sellerVerificationTimeoutDays = 7;
  static const int productModerationTimeoutHours = 24;
}

enum ViewMode {
  grid,
  list,
}

enum SortOption {
  newest,
  priceLowToHigh,
  priceHighToLow,
  rating,
}