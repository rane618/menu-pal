import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const PaymentSuccessPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text('Payment Successful!'),
            Text('Item: ${item['name']}'),
            Text('Price: \Rs.${item['price']}'),
          ],
        ),
      ),
    );
  }
}
