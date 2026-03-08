import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cart_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instructionsController = TextEditingController();
  String _selectedCity = 'Addis Ababa';
  String _selectedPaymentMethod = 'chapa';
  bool _isProcessing = false;

  final List<String> _ethiopianCities = [
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
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Delivery Address'),
              const SizedBox(height: 16),
              _buildAddressSection(),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Order Summary'),
              const SizedBox(height: 16),
              _buildOrderSummary(cartState),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Payment Method'),
              const SizedBox(height: 16),
              _buildPaymentMethods(),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Order Total'),
              const SizedBox(height: 16),
              _buildOrderTotal(cartState),
              const SizedBox(height: 32),
              _buildPlaceOrderButton(cartState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: const InputDecoration(
                labelText: 'City',
                prefixIcon: Icon(Icons.location_city),
              ),
              items: _ethiopianCities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Full Address',
                hintText: 'Street address, building, floor, etc.',
                prefixIcon: Icon(Icons.home),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+251 9XX XXX XXX',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                final phonePattern = RegExp(r'^(\+251|0)(9|7)\d{8}$');
                if (!phonePattern.hasMatch(value.replaceAll(' ', ''))) {
                  return 'Please enter a valid Ethiopian phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Delivery Instructions (Optional)',
                hintText: 'Any special instructions for delivery',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartState cartState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...cartState.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 24),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Qty: ${item.quantity}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${AppConstants.currencySymbol}${item.total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPaymentOption(
              'chapa',
              'Chapa',
              'Pay with Chapa (Cards, Mobile Money)',
              Icons.payment,
            ),
            const Divider(),
            _buildPaymentOption(
              'cod',
              'Cash on Delivery',
              'Pay when you receive your order',
              Icons.money,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, String subtitle, IconData icon) {
    return RadioListTile<String>(
      value: value,
      groupValue: _selectedPaymentMethod,
      onChanged: (newValue) {
        setState(() {
          _selectedPaymentMethod = newValue!;
        });
      },
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      secondary: Icon(icon, color: AppTheme.primaryGreen),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildOrderTotal(CartState cartState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriceRow('Subtotal', cartState.subtotal),
            const SizedBox(height: 8),
            _buildPriceRow(
              'Delivery Fee',
              cartState.deliveryFee,
              isFree: cartState.deliveryFee == 0,
            ),
            const SizedBox(height: 8),
            _buildPriceRow('Tax (15%)', cartState.subtotal * 0.15),
            const Divider(height: 24),
            _buildPriceRow(
              'Total',
              cartState.subtotal + cartState.deliveryFee + (cartState.subtotal * 0.15),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false, bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          isFree ? 'Free' : '${AppConstants.currencySymbol}${amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppTheme.primaryGreen : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(CartState cartState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing
            ? null
            : () => _placeOrder(cartState),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Place Order'),
      ),
    );
  }

  Future<void> _placeOrder(CartState cartState) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    if (_selectedPaymentMethod == 'chapa') {
      // Navigate to payment screen
      Navigator.pushNamed(
        context,
        '/payment',
        arguments: {
          'amount': cartState.subtotal + cartState.deliveryFee + (cartState.subtotal * 0.15),
          'phone': _phoneController.text,
          'address': '$_selectedCity, ${_addressController.text}',
        },
      );
    } else {
      // Cash on delivery - create order directly
      _showOrderSuccessDialog();
    }

    setState(() {
      _isProcessing = false;
    });
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.success, size: 32),
            const SizedBox(width: 12),
            const Text('Order Placed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your order has been placed successfully.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Order ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'You will pay cash upon delivery.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Continue Shopping'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
              Navigator.pushNamed(context, '/orders');
            },
            child: const Text('View Orders'),
          ),
        ],
      ),
    );
  }
}