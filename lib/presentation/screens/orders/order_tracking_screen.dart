import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/order_entity.dart';
import '../../providers/order_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final order = orderState.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => throw Exception('Order not found'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tracking Number Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tracking Number',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.trackingNumber ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_outlined),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tracking number copied')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Timeline
            _buildTimeline(context, order),
            const SizedBox(height: 24),

            // Map Placeholder
            Card(
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Live tracking coming soon',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Delivery Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.shippingAddress.fullName),
                              Text(
                                order.shippingAddress.specificAddress,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '${order.shippingAddress.subCity}, ${order.shippingAddress.city}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Estimated Delivery',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          order.status == OrderStatus.delivered
                              ? 'Delivered'
                              : _getEstimatedDelivery(order),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Contact Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Call delivery person
                    },
                    icon: const Icon(Icons.phone_outlined),
                    label: const Text('Call'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Chat with support
                    },
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('Chat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, OrderEntity order) {
    final steps = _getTimelineSteps(order);
    final currentStepIndex = steps.indexWhere((step) => !step.isCompleted);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(steps.length, (index) {
              final step = steps[index];
              final isLast = index == steps.length - 1;
              final isCurrent = index == currentStepIndex;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline indicator
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: step.isCompleted
                              ? AppTheme.primaryGreen
                              : isCurrent
                                  ? AppTheme.primaryYellow
                                  : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          step.isCompleted
                              ? Icons.check
                              : isCurrent
                                  ? Icons.circle
                                  : step.icon,
                          size: step.isCompleted || isCurrent ? 18 : 16,
                          color: step.isCompleted || isCurrent
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: step.isCompleted
                              ? AppTheme.primaryGreen
                              : Colors.grey[300],
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Step content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: step.isCompleted || isCurrent
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (step.timestamp != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM dd, yyyy - HH:mm').format(step.timestamp!),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  List<TimelineStep> _getTimelineSteps(OrderEntity order) {
    final now = DateTime.now();
    final orderDate = order.createdAt;

    return [
      TimelineStep(
        title: 'Order Placed',
        subtitle: 'Your order has been placed successfully',
        icon: Icons.shopping_bag_outlined,
        isCompleted: true,
        timestamp: orderDate,
      ),
      TimelineStep(
        title: 'Order Confirmed',
        subtitle: 'Seller has confirmed your order',
        icon: Icons.verified_outlined,
        isCompleted: order.status != OrderStatus.pending,
        timestamp: order.status != OrderStatus.pending
            ? orderDate.add(const Duration(hours: 2))
            : null,
      ),
      TimelineStep(
        title: 'Processing',
        subtitle: 'Your order is being prepared',
        icon: Icons.inventory_2_outlined,
        isCompleted: order.status == OrderStatus.shipped ||
            order.status == OrderStatus.delivered,
        timestamp: order.status == OrderStatus.processing ||
                order.status == OrderStatus.shipped ||
                order.status == OrderStatus.delivered
            ? orderDate.add(const Duration(hours: 6))
            : null,
      ),
      TimelineStep(
        title: 'Shipped',
        subtitle: 'Your order is on the way',
        icon: Icons.local_shipping_outlined,
        isCompleted: order.status == OrderStatus.delivered,
        timestamp: order.status == OrderStatus.shipped ||
                order.status == OrderStatus.delivered
            ? orderDate.add(const Duration(days: 1))
            : null,
      ),
      TimelineStep(
        title: 'Delivered',
        subtitle: 'Package has been delivered',
        icon: Icons.check_circle_outline,
        isCompleted: order.status == OrderStatus.delivered,
        timestamp: order.status == OrderStatus.delivered
            ? order.updatedAt
            : null,
      ),
    ];
  }

  String _getEstimatedDelivery(OrderEntity order) {
    final estimatedDate = order.createdAt.add(const Duration(days: 3));
    final dateFormat = DateFormat('EEE, MMM dd');
    return dateFormat.format(estimatedDate);
  }
}

class TimelineStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;
  final DateTime? timestamp;

  const TimelineStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isCompleted,
    this.timestamp,
  });
}