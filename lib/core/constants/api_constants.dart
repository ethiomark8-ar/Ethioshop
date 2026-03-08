class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrl = 'https://api.ethioshop.et';
  static const String chapaBaseUrl = 'https://api.chapa.co';

  // API Endpoints
  static const String authPath = '/auth';
  static const String usersPath = '/users';
  static const String productsPath = '/products';
  static const String ordersPath = '/orders';
  static const String cartsPath = '/carts';
  static const String chatsPath = '/chats';
  static const String messagesPath = '/messages';
  static const String reviewsPath = '/reviews';
  static const String notificationsPath = '/notifications';
  static const String wishlistsPath = '/wishlists';
  static const String categoriesPath = '/categories';

  // Auth Endpoints
  static const String loginEndpoint = '$authPath/login';
  static const String registerEndpoint = '$authPath/register';
  static const String logoutEndpoint = '$authPath/logout';
  static const String refreshTokenEndpoint = '$authPath/refresh';
  static const String forgotPasswordEndpoint = '$authPath/forgot-password';
  static const String resetPasswordEndpoint = '$authPath/reset-password';
  static const String verifyEmailEndpoint = '$authPath/verify-email';
  static const String resendVerificationEndpoint = '$authPath/resend-verification';

  // User Endpoints
  static const String profileEndpoint = '$usersPath/profile';
  static const String updateProfileEndpoint = '$usersPath/profile/update';
  static const String changePasswordEndpoint = '$usersPath/change-password';
  static const String uploadAvatarEndpoint = '$usersPath/avatar';
  static const String deleteAccountEndpoint = '$usersPath/account';

  // Product Endpoints
  static const String searchProductsEndpoint = '$productsPath/search';
  static const String featuredProductsEndpoint = '$productsPath/featured';
  static const String trendingProductsEndpoint = '$productsPath/trending';
  static const String productCategoriesEndpoint = '$categoriesPath';
  static const String uploadProductImagesEndpoint = '$productsPath/images';

  // Order Endpoints
  static const String createOrderEndpoint = '$ordersPath/create';
  static const String trackOrderEndpoint = '$ordersPath/track';
  static const String cancelOrderEndpoint = '$ordersPath/cancel';
  static const String returnOrderEndpoint = '$ordersPath/return';

  // Payment Endpoints
  static const String initiatePaymentEndpoint = '/payment/initialize';
  static const String verifyPaymentEndpoint = '/payment/verify';

  // Notification Endpoints
  static const String registerFcmTokenEndpoint = '/notifications/fcm-token';
  static const String markAsReadEndpoint = '$notificationsPath/read';
  static const String markAllAsReadEndpoint = '$notificationsPath/read-all';

  // Chat Endpoints
  static const String initiateChatEndpoint = '$chatsPath/initiate';
  static const String uploadAttachmentEndpoint = '$messagesPath/upload';

  // Timeout Values
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache Keys
  static const String cachedProductsKey = 'cached_products';
  static const String cachedCategoriesKey = 'cached_categories';
  static const String cachedUserProfileKey = 'cached_user_profile';
  static const String offlineCartKey = 'offline_cart';
  static const String offlineWishlistKey = 'offline_wishlist';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File Upload
  static const int maxFileSizeMB = 10;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];

  // Rate Limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
}