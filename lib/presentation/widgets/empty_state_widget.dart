import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;
  final VoidCallback? onActionPressed;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 80,
                color: Colors.grey[300],
              ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
            if (action != null || onActionPressed != null) ...[
              const SizedBox(height: 24),
              if (action != null)
                action!
              else if (onActionPressed != null)
                ElevatedButton(
                  onPressed: onActionPressed,
                  child: const Text('Get Started'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onShopNow;

  const EmptyCartWidget({
    super.key,
    this.onShopNow,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.shopping_cart_outlined,
      title: 'Your cart is empty',
      subtitle: 'Looks like you haven\'t added any items yet. Start shopping to fill it up!',
      action: ElevatedButton.icon(
        onPressed: onShopNow,
        icon: const Icon(Icons.shopping_bag),
        label: const Text('Shop Now'),
      ),
    );
  }
}

class EmptyOrdersWidget extends StatelessWidget {
  final VoidCallback? onShopNow;

  const EmptyOrdersWidget({
    super.key,
    this.onShopNow,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.inventory_2_outlined,
      title: 'No orders yet',
      subtitle: 'You haven\'t placed any orders. Start shopping to see your orders here!',
      action: onShopNow != null
          ? ElevatedButton.icon(
              onPressed: onShopNow,
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Start Shopping'),
            )
          : null,
    );
  }
}

class EmptyWishlistWidget extends StatelessWidget {
  final VoidCallback? onExplore;

  const EmptyWishlistWidget({
    super.key,
    this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'Your wishlist is empty',
      subtitle: 'Save items you love by tapping the heart icon on any product.',
      action: ElevatedButton.icon(
        onPressed: onExplore,
        icon: const Icon(Icons.explore),
        label: const Text('Explore Products'),
      ),
    );
  }
}

class EmptySearchWidget extends StatelessWidget {
  final VoidCallback? onClear;

  const EmptySearchWidget({
    super.key,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No results found',
      subtitle: 'Try different keywords or browse our categories',
      action: onClear != null
          ? TextButton(
              onPressed: onClear,
              child: const Text('Clear Search'),
            )
          : null,
    );
  }
}

class EmptyChatWidget extends StatelessWidget {
  final VoidCallback? onBrowseProducts;

  const EmptyChatWidget({
    super.key,
    this.onBrowseProducts,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.chat_bubble_outline,
      title: 'No conversations yet',
      subtitle: 'Start a conversation with sellers by asking questions about their products.',
      action: onBrowseProducts != null
          ? ElevatedButton.icon(
              onPressed: onBrowseProducts,
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Browse Products'),
            )
          : null,
    );
  }
}

class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.notifications_none,
      title: 'No notifications',
      subtitle: 'You\'re all caught up! We\'ll notify you when there\'s something new.',
    );
  }
}

class EmptyReviewsWidget extends StatelessWidget {
  final VoidCallback? onWriteReview;

  const EmptyReviewsWidget({
    super.key,
    this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.rate_review_outlined,
      title: 'No reviews yet',
      subtitle: 'Be the first to review this product. Share your experience with others!',
      action: onWriteReview != null
          ? ElevatedButton.icon(
              onPressed: onWriteReview,
              icon: const Icon(Icons.edit),
              label: const Text('Write a Review'),
            )
          : null,
    );
  }
}

class EmptyProductsWidget extends StatelessWidget {
  final VoidCallback? onAddProduct;

  const EmptyProductsWidget({
    super.key,
    this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.inventory_outlined,
      title: 'No products yet',
      subtitle: 'You haven\'t listed any products. Add your first product to start selling!',
      action: onAddProduct != null
          ? ElevatedButton.icon(
              onPressed: onAddProduct,
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            )
          : null,
    );
  }
}