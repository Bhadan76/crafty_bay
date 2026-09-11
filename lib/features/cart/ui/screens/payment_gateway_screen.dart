import 'package:flutter/material.dart';
import 'package:flutter_bkash/flutter_bkash.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:get/get.dart';

import '../widget/payment_cart_widget.dart';

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key, required this.totalAmount});

  final double totalAmount;
  static const String name = '/payment-gateway';

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  final flutterBkash = FlutterBkash();

  void _placeOrder() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Center(child: Text('Payment Successfully')),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _showFailureUrl() {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Payment Failed'),
          content: Column(
            mainAxisSize: .min,
            children: [Text('Your payment has been failed! Please try again')],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a payment method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            paymentCart(image: 'https://brandlogos.net/wp-content/uploads/2026/01/bkash-logo_brandlogos.net_2qvpe-768x352.png', onTap:_bkashPayment ,),
            SizedBox(height: 15,),
            paymentCart(image: 'https://cdn.brandfetch.io/id3q3A-eCg/w/462/h/100/theme/dark/logo.png?c=1dxbfHSJFAPEGdCLU4o5B', onTap: _sslCommerces ,),
          ],
        ),
      ),
    );
  }

  void _sslCommerces() async {
    try {
      Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          multi_card_name: "visa,master,bkash",
          currency: SSLCurrencyType.BDT,
          product_category: "General",
          sdkType: SSLCSdkType.TESTBOX,
          store_id: "app6aa38792b11be",
          store_passwd: "app6aa38792b11be@ssl",
          total_amount: widget.totalAmount,
          tran_id: "txn_${DateTime.now().millisecondsSinceEpoch}",
        ),
      );

      var result = await sslcommerz.payNow();

      if (mounted) {
        if (result.status == 'VALID' || result.status == 'VALIDATED') {
          _placeOrder();
        } else {
          _showFailureUrl();
        }
      }
    } catch (e) {
      if (mounted) {
        _showFailureUrl();
      }
    }
  }

  void _bkashPayment() async {
    final response = await flutterBkash.pay(
      context: context,
      amount: widget.totalAmount,
      merchantInvoiceNumber: 'merchantInvoiceNumber',
    );
  }
}


