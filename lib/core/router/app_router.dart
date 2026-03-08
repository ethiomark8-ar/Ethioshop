import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/product/product_detail_screen.dart';
import '../../presentation/screens/product/search_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/checkout/checkout_screen.dart';
import '../../presentation/screens/orders/order_history_screen.dart';
import '../../presentation/screens/orders/order_detail_screen.dart';
import '../../presentation/screens/orders/order_tracking_screen.dart';
import '../../presentation/screens/chat/chat_list_screen.dart';
import '../../presentation/screens/chat/chat_detail_screen.dart';
import '../../presentation/screens/review/reviews_screen.dart';
import '../../presentation/screens/review/write_review_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/profile/address_book_screen.dart';
import '../../presentation/screens/wishlist/wishlist_screen.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';
import '../../presentation/screens/seller/seller_dashboard_screen.dart';
import '../../presentation/screens/seller/create_product_screen.dart';
import '../../presentation/screens/seller/seller_products_screen.dart';
import '../../presentation/screens/seller/seller_orders_screen.dart';
import '../../presentation/screens/admin/admin_dashboard_screen.dart';
import '../../presentation/screens/admin/admin_products_screen.dart';
import '../../presentation/screens/admin/admin_orders_screen.dart';
import '../../presentation/screens/admin/admin_users_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../providers/auth_provider.dart';

part 'app_router.g.dart';

enum AppRoute {
  onboarding,
  login,
  register,
  forgotPassword,
  home,
  productDetail,
  search,
  cart,
  checkout,
  orderHistory,
  orderDetail,
  orderTracking,
  chatList,
  chatDetail,
  reviews,
  writeReview,
  profile,
  editProfile,
  addressBook,
  wishlist,
  notifications,
  sellerDashboard,
  createProduct,
  sellerProducts,
  sellerOrders,
  adminDashboard,
  adminProducts,
  adminOrders,
  adminUsers,
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      // If onboarding not completed, go to onboarding
      // For now, we skip this check
      // final hasSeenOnboarding = ref.read(hasSeenOnboardingProvider);

      // If not logged in and trying to access protected route
      if (!isLoggedIn && !isAuthRoute && !isOnboarding) {
        return '/login';
      }

      // If logged in and trying to access auth routes
      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Onboarding Route
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRoute.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: AppRoute.forgotPassword.name,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Home Route
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),

      // Product Routes
      GoRoute(
        path: '/product/:id',
        name: AppRoute.productDetail.name,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '/search',
        name: AppRoute.search.name,
        builder: (context, state) {
          final query = state.uri.queryParameters['q'];
          return SearchScreen(initialQuery: query);
        },
      ),

      // Cart Route
      GoRoute(
        path: '/cart',
        name: AppRoute.cart.name,
        builder: (context, state) => const CartScreen(),
      ),

      // Checkout Route
      GoRoute(
        path: '/checkout',
        name: AppRoute.checkout.name,
        builder: (context, state) => const CheckoutScreen(),
      ),

      // Order Routes
      GoRoute(
        path: '/orders',
        name: AppRoute.orderHistory.name,
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/orders/:id',
        name: AppRoute.orderDetail.name,
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/orders/:id/track',
        name: AppRoute.orderTracking.name,
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderTrackingScreen(orderId: orderId);
        },
      ),

      // Chat Routes
      GoRoute(
        path: '/chats',
        name: AppRoute.chatList.name,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/chats/:id',
        name: AppRoute.chatDetail.name,
        builder: (context, state) {
          final chatId = state.pathParameters['id']!;
          final productId = state.uri.queryParameters['productId'];
          return ChatDetailScreen(
            chatId: chatId,
            productId: productId,
          );
        },
      ),

      // Review Routes
      GoRoute(
        path: '/products/:id/reviews',
        name: AppRoute.reviews.name,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ReviewsScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '/products/:id/write-review',
        name: AppRoute.writeReview.name,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return WriteReviewScreen(productId: productId);
        },
      ),

      // Profile Routes
      GoRoute(
        path: '/profile',
        name: AppRoute.profile.name,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: AppRoute.editProfile.name,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/addresses',
        name: AppRoute.addressBook.name,
        builder: (context, state) => const AddressBookScreen(),
      ),

      // Wishlist Route
      GoRoute(
        path: '/wishlist',
        name: AppRoute.wishlist.name,
        builder: (context, state) => const WishlistScreen(),
      ),

      // Notifications Route
      GoRoute(
        path: '/notifications',
        name: AppRoute.notifications.name,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Seller Routes
      GoRoute(
        path: '/seller',
        name: AppRoute.sellerDashboard.name,
        builder: (context, state) => const SellerDashboardScreen(),
      ),
      GoRoute(
        path: '/seller/products/new',
        name: AppRoute.createProduct.name,
        builder: (context, state) => const CreateProductScreen(),
      ),
      GoRoute(
        path: '/seller/products',
        name: AppRoute.sellerProducts.name,
        builder: (context, state) => const SellerProductsScreen(),
      ),
      GoRoute(
        path: '/seller/orders',
        name: AppRoute.sellerOrders.name,
        builder: (context, state) => const SellerOrdersScreen(),
      ),

      // Admin Routes
      GoRoute(
        path: '/admin',
        name: AppRoute.adminDashboard.name,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/products',
        name: AppRoute.adminProducts.name,
        builder: (context, state) => const AdminProductsScreen(),
      ),
      GoRoute(
        path: '/admin/orders',
        name: AppRoute.adminOrders.name,
        builder: (context, state) => const AdminOrdersScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        name: AppRoute.adminUsers.name,
        builder: (context, state) => const AdminUsersScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}

// Navigation helper extensions
extension GoRouterExtension on GoRouter {
  void goNamed(AppRoute route, {Map<String, String> params = const {}, Map<String, dynamic> queryParams = const {}}) {
    goNamed(route.name, pathParameters: params, queryParameters: queryParams);
  }

  void pushNamed(AppRoute route, {Map<String, String> params = const {}, Map<String, dynamic> queryParams = const {}}) {
    pushNamed(route.name, pathParameters: params, queryParameters: queryParams);
  }
}

extension BuildContextNavigation on BuildContext {
  void goNamed(AppRoute route, {Map<String, String> params = const {}, Map<String, dynamic> queryParams = const {}}) {
    goNamed(route.name, pathParameters: params, queryParameters: queryParams);
  }

  void pushNamed(AppRoute route, {Map<String, String> params = const {}, Map<String, dynamic> queryParams = const {}}) {
    pushNamed(route.name, pathParameters: params, queryParameters: queryParams);
  }
}

// Route guards
class RouteGuard {
  static bool isAuthenticated(WidgetRef ref) {
    final authState = ref.read(authProvider);
    return authState.status == AuthStatus.authenticated;
  }

  static bool isSeller(WidgetRef ref) {
    final authState = ref.read(authProvider);
    return authState.user?.role == 'seller' || authState.user?.role == 'admin';
  }

  static bool isAdmin(WidgetRef ref) {
    final authState = ref.read(authProvider);
    return authState.user?.role == 'admin';
  }
}

// App route information
class AppRouteInfo {
  static const List<Map<String, dynamic>> bottomNavRoutes = [
    {'route': AppRoute.home, 'icon': Icons.home, 'label': 'Home'},
    {'route': AppRoute.search, 'icon': Icons.search, 'label': 'Search'},
    {'route': AppRoute.cart, 'icon': Icons.shopping_cart, 'label': 'Cart'},
    {'route': AppRoute.profile, 'icon': Icons.person, 'label': 'Profile'},
  ];

  static const List<Map<String, dynamic>> sellerNavRoutes = [
    {'route': AppRoute.sellerDashboard, 'icon': Icons.dashboard, 'label': 'Dashboard'},
    {'route': AppRoute.sellerProducts, 'icon': Icons.inventory, 'label': 'Products'},
    {'route': AppRoute.sellerOrders, 'icon': Icons.receipt_long, 'label': 'Orders'},
  ];

  static const List<Map<String, dynamic>> adminNavRoutes = [
    {'route': AppRoute.adminDashboard, 'icon': Icons.dashboard, 'label': 'Dashboard'},
    {'route': AppRoute.adminProducts, 'icon': Icons.inventory, 'label': 'Products'},
    {'route': AppRoute.adminOrders, 'icon': Icons.receipt_long, 'label': 'Orders'},
    {'route': AppRoute.adminUsers, 'icon': Icons.people, 'label': 'Users'},
  ];
}