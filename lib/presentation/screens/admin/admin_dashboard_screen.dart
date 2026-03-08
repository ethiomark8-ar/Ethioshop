import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider);
    final orderState = ref.watch(orderProvider);
    final authState = ref.watch(authProvider);

    // Calculate admin stats
    final totalProducts = productState.products.length;
    final totalOrders = orderState.orders.length;
    final totalRevenue = orderState.orders
        .where((o) => o.status == OrderStatus.delivered)
        .fold(0.0, (sum, order) => sum + order.total);
    final totalUsers = 125; // Mock value

    final pendingOrders = orderState.pendingOrders.length;
    final processingOrders = orderState.processingOrders.length;
    const totalSellers = 45; // Mock value

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(productProvider.notifier).loadProducts();
          ref.read(authProvider.notifier).checkAuthStatus();
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
                        'Welcome, Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Here\'s what\'s happening today',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.admin_panel_settings, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Super Admin',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                              ],
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
                'Platform Overview',
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
                    icon: Icons.people_outline,
                    title: 'Total Users',
                    value: totalUsers.toString(),
                    color: AppTheme.primaryGreen,
                  ),
                  _buildStatCard(
                    context,
                    icon: Icons.store_outlined,
                    title: 'Sellers',
                    value: totalSellers.toString(),
                    color: AppTheme.primaryYellow,
                  ),
                  _buildStatCard(
                    context,
                    icon: Icons.inventory_2_outlined,
                    title: 'Products',
                    value: totalProducts.toString(),
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    title: 'Orders',
                    value: totalOrders.toString(),
                    color: Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Revenue and Orders
              Row(
                children: [
                  Expanded(
                    child: _buildRevenueCard(context, totalRevenue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOrdersCard(context, pendingOrders, processingOrders),
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
                icon: Icons.people,
                title: 'Manage Users',
                subtitle: 'View and manage user accounts',
                onTap: () => context.push('/admin/users'),
              ),
              _buildQuickAction(
                context,
                icon: Icons.store,
                title: 'Manage Sellers',
                subtitle: 'Approve sellers and manage accounts',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seller management coming soon')),
                  );
                },
              ),
              _buildQuickAction(
                context,
                icon: Icons.inventory,
                title: 'Manage Products',
                subtitle: 'Review and moderate products',
                onTap: () => context.push('/admin/products'),
              ),
              _buildQuickAction(
                context,
                icon: Icons.list_alt,
                title: 'Manage Orders',
                subtitle: 'View and process all orders',
                onTap: () => context.push('/admin/orders'),
              ),
              _buildQuickAction(
                context,
                icon: Icons.report_problem,
                title: 'Reports & Disputes',
                subtitle: 'Handle user reports and disputes',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reports management coming soon')),
                  );
                },
              ),
              _buildQuickAction(
                context,
                icon: Icons.analytics,
                title: 'Analytics & Reports',
                subtitle: 'View platform analytics',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Analytics coming soon')),
                  );
                },
              ),
              _buildQuickAction(
                context,
                icon: Icons.settings_suggest,
                title: 'Platform Settings',
                subtitle: 'Configure platform settings',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings coming soon')),
                  );
                },
              ),
            ],
          ),
        ),
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

  Widget _buildRevenueCard(BuildContext context, double totalRevenue) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money, color: AppTheme.primaryGreen),
                const SizedBox(width: 8),
                const Text(
                  'Total Revenue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${AppConstants.currencySymbol} ${totalRevenue.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.trending_up, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  '+12% from last month',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersCard(BuildContext context, int pending, int processing) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Orders Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildOrderStatusItem('Pending', pending, Colors.orange),
            const SizedBox(height: 8),
            _buildOrderStatusItem('Processing', processing, Colors.blue),
            const SizedBox(height: 8),
            _buildOrderStatusItem('Completed', (pending + processing) * 2, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusItem(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
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
}