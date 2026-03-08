import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class SellerDashboardScreen extends ConsumerWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider);
    final orderState = ref.watch(orderProvider);

    // Calculate seller-specific stats (mock)
    final totalProducts = productState.products.length;
    final totalOrders = orderState.orders.length;
    final totalRevenue = orderState.orders.fold(0.0, (sum, order) => sum + order.total);
    final pendingOrders = orderState.pendingOrders.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(productProvider.notifier).loadProducts();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Card(
                color: AppTheme.primaryGreen,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ethiopian Coffee House',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.store, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Verified Seller',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Stats Grid
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildStatCard(
                    context,
                    icon: Icons.inventory_2_outlined,
                    title: 'Products',
                    value: totalProducts.toString(),
                    color: AppTheme.primaryGreen,
                  ),
                  _buildStatCard(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'Orders',
                    value: totalOrders.toString(),
                    color: AppTheme.primaryYellow,
                  ),
                  _buildStatCard(
                    context,
                    icon: Icons.attach_money,
                    title: 'Revenue',
                    value: '${AppConstants.currencySymbol} ${(totalRevenue / 1000).toStringAsFixed(1)}k',
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    icon: Icons.pending_outlined,
                    title: 'Pending',
                    value: pendingOrders.toString(),
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildQuickAction(
                context,
                icon: Icons.add_circle_outline,
                title: 'Add New Product',
                subtitle: 'List a new product for sale',
                onTap: () => context.push('/seller/products/create'),
              ),
              _buildQuickAction(
                context,
                icon: Icons.inventory,
                title: 'Manage Products',
                subtitle: 'View and edit your products',
                onTap: () => context.push('/seller/products'),
              ),
              _buildQuickAction(
                context,
                icon: Icons.list_alt,
                title: 'View Orders',
                subtitle: 'Manage customer orders',
                onTap: () => context.push('/seller/orders'),
              ),
              _buildQuickAction(
                context,
                icon: Icons.analytics_outlined,
                title: 'Analytics',
                subtitle: 'View sales and performance',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Analytics coming soon')),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Recent Orders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Orders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/orders'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (orderState.orders.isEmpty)
                _buildEmptyState(context, 'No orders yet')
              else
                ...orderState.orders.take(3).map((order) => _buildOrderCard(context, order)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/seller/products/create'),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
          child: Icon(icon, color: AppTheme.primaryGreen),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, dynamic order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.shopping_bag_outlined),
        ),
        title: Text('Order #${order.id.toString().split('_').last}'),
        subtitle: Text('${order.items.length} items • ${AppConstants.currencySymbol} ${order.total.toStringAsFixed(2)}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(order.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _getStatusText(order.status),
            style: TextStyle(
              color: _getStatusColor(order.status),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () => context.push('/orders/${order.id}'),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}