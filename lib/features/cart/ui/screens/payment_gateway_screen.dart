import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:get/get.dart';


class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key, required this.totalAmount});

  final double totalAmount;
  static const String name = '/payment-gateway';

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {

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
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Payment Failed'),
          content: Column(
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
      body: Center(
        child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Amount: \$${widget.totalAmount}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: sslCommerces,
                    child: const Text('Pay Now'),
                  ),
                ],
              ),
      ),
    );
  }

  void sslCommerces() async {

    
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
}
