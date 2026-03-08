import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Mock users data
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 'user_123',
      'fullName': 'Abebe Bikila',
      'email': 'abebe@example.com',
      'phone': '+251911123456',
      'role': 'user',
      'isVerified': true,
      'isSeller': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 30)),
      'totalOrders': 5,
      'totalSpent': 15000.0,
    },
    {
      'id': 'seller_1',
      'fullName': 'Ethiopian Coffee House',
      'email': 'coffee@example.com',
      'phone': '+251922234567',
      'role': 'seller',
      'isVerified': true,
      'isSeller': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 60)),
      'totalOrders': 0,
      'totalProducts': 12,
      'totalSales': 45000.0,
    },
    {
      'id': 'seller_2',
      'fullName': 'Habesha Crafts',
      'email': 'crafts@example.com',
      'phone': '+251933345678',
      'role': 'seller',
      'isVerified': true,
      'isSeller': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 45)),
      'totalOrders': 0,
      'totalProducts': 8,
      'totalSales': 28000.0,
    },
    {
      'id': 'user_456',
      'fullName': 'Tigist Haile',
      'email': 'tigist@example.com',
      'phone': '+251944456789',
      'role': 'user',
      'isVerified': true,
      'isSeller': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 15)),
      'totalOrders': 2,
      'totalSpent': 3500.0,
    },
    {
      'id': 'user_789',
      'fullName': 'Dawit Amare',
      'email': 'dawit@example.com',
      'phone': '+251955567890',
      'role': 'user',
      'isVerified': false,
      'isSeller': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
      'totalOrders': 0,
      'totalSpent': 0.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allUsers = _mockUsers;
    final sellers = _mockUsers.where((u) => u['isSeller'] == true).toList();
    final regularUsers = _mockUsers.where((u) => u['isSeller'] == false).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Users'),
            Tab(text: 'Sellers'),
            Tab(text: 'Users'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users by name, email or phone',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // User List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUsersList(allUsers),
                _buildUsersList(sellers),
                _buildUsersList(regularUsers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List<Map<String, dynamic>> users) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Users Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _showUserDetails(user);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: user['isSeller'] == true
                    ? AppTheme.primaryYellow.withOpacity(0.2)
                    : AppTheme.primaryGreen.withOpacity(0.2),
                child: Icon(
                  user['isSeller'] == true ? Icons.store : Icons.person,
                  color: user['isSeller'] == true
                      ? AppTheme.primaryYellow
                      : AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                user['fullName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (user['isVerified'] == true) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.verified,
                                  size: 16,
                                  color: Colors.blue[700],
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: user['isSeller'] == true
                                ? AppTheme.primaryYellow.withOpacity(0.1)
                                : AppTheme.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user['isSeller'] == true ? 'Seller' : 'User',
                            style: TextStyle(
                              color: user['isSeller'] == true
                                  ? AppTheme.primaryYellow
                                  : AppTheme.primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['phone'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Stats
                    Row(
                      children: [
                        if (user['isSeller'] == true) ...[
                          _buildStatItem(
                            Icons.inventory_2_outlined,
                            '${user['totalProducts']} Products',
                          ),
                          const SizedBox(width: 16),
                          _buildStatItem(
                            Icons.attach_money,
                            '${AppConstants.currencySymbol} ${(user['totalSales'] / 1000).toStringAsFixed(1)}k Sales',
                          ),
                        ] else ...[
                          _buildStatItem(
                            Icons.shopping_bag_outlined,
                            '${user['totalOrders']} Orders',
                          ),
                          const SizedBox(width: 16),
                          _buildStatItem(
                            Icons.attach_money,
                            '${AppConstants.currencySymbol} ${(user['totalSpent'] / 1000).toStringAsFixed(1)}k Spent',
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Joined ${dateFormat.format(user['createdAt'])}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildUserDetailsSheet(user),
    );
  }

  Widget _buildUserDetailsSheet(Map<String, dynamic> user) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Avatar
          CircleAvatar(
            radius: 48,
            backgroundColor: user['isSeller'] == true
                ? AppTheme.primaryYellow.withOpacity(0.2)
                : AppTheme.primaryGreen.withOpacity(0.2),
            child: Icon(
              user['isSeller'] == true ? Icons.store : Icons.person,
              size: 48,
              color: user['isSeller'] == true
                  ? AppTheme.primaryYellow
                  : AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user['fullName'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user['email'],
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Block user
                    Navigator.pop(context);
                    _showBlockDialog(user);
                  },
                  icon: const Icon(Icons.block),
                  label: const Text('Block'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // View full profile
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Delete Account
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showDeleteAccountDialog(user);
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text('Are you sure you want to block ${user['fullName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user['fullName']} has been blocked')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Are you sure you want to delete ${user['fullName']}\'s account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user['fullName']}\'s account has been deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}