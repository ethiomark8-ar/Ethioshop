import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;

  const PaymentScreen({super.key, required this.arguments});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;
  String? _paymentStatus;

  double get _amount => widget.arguments['amount'] as double;
  String get _phone => widget.arguments['phone'] as String;
  String get _address => widget.arguments['address'] as String;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  void _initializePayment() {
    // Generate a unique transaction reference
    final txRef = 'ETHIOSHOP_${DateTime.now().millisecondsSinceEpoch}';

    // Chapa payment URL (this would typically come from your backend)
    final paymentUrl = '${AppConstants.chapaPaymentUrl}?'
        'amount=${_amount.toStringAsFixed(2)}'
        '&currency=ETB'
        '&email=${Uri.encodeComponent('customer@example.com')}'
        '&phone=${Uri.encodeComponent(_phone)}'
        '&tx_ref=$txRef'
        '&callback_url=${Uri.encodeComponent('https://ethioshop.et/callback')}'
        '&return_url=${Uri.encodeComponent('https://ethioshop.et/payment-success')}'
        '&customization[title]=EthioShop'
        '&customization[description]=Payment for order';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Check for callback URLs
            if (request.url.contains('payment-success') ||
                request.url.contains('callback')) {
              _handlePaymentCallback(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _errorMessage = 'Payment failed: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  void _handlePaymentCallback(String url) {
    // Parse the callback URL to determine payment status
    final uri = Uri.parse(url);
    final status = uri.queryParameters['status'];
    final txRef = uri.queryParameters['tx_ref'];

    if (status == 'success' || url.contains('payment-success')) {
      setState(() {
        _paymentStatus = 'success';
      });
      _showPaymentResultDialog(isSuccess: true);
    } else {
      setState(() {
        _paymentStatus = 'failed';
      });
      _showPaymentResultDialog(isSuccess: false);
    }
  }

  void _showPaymentResultDialog({required bool isSuccess}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? AppTheme.success : AppTheme.error,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(isSuccess ? 'Payment Successful!' : 'Payment Failed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSuccess
                  ? 'Your payment has been processed successfully.'
                  : 'There was an issue processing your payment.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (isSuccess) ...[
              Text(
                'Order ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Delivery Address: $_address',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Total Paid: ${AppConstants.currencySymbol}${_amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Continue Shopping'),
          ),
          if (isSuccess)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/orders');
              },
              child: const Text('View Orders'),
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _initializePayment();
              },
              child: const Text('Try Again'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _showCancelPaymentDialog();
          },
        ),
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                        _initializePayment();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          else
            WebViewWidget(controller: _controller),
          if (_isLoading && _errorMessage == null)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading payment...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Payment?'),
        content: const Text(
          'Are you sure you want to cancel the payment? Your order will not be processed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Payment'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}