import 'package:flutter/material.dart';
import 'package:menopal/screens/PaymentSuccessPage.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const CheckoutPage({Key? key, required this.item}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool payOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(widget.item['image']),
            Text('Item: ${widget.item['name']}'),
            Text('Price: \Rs.${widget.item['price']}'),
            SizedBox(height: 20),
            Text('Select Payment Method:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: true,
                  groupValue: payOnline,
                  onChanged: (value) {
                    setState(() {
                      payOnline = value as bool;
                    });
                  },
                ),
                Text('Pay Online'),
                SizedBox(width: 20),
                Radio(
                  value: false,
                  groupValue: payOnline,
                  onChanged: (value) {
                    setState(() {
                      payOnline = value as bool;
                    });
                  },
                ),
                Text('Cash on Delivery'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement the logic to process the payment
                if (payOnline) {
                  // Online payment logic
                  // Redirect to payment gateway or perform payment processing
                  // After successful payment, navigate to the success page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentSuccessPage(item: widget.item),
                    ),
                  );
                } else {
                  // Cash on delivery logic
                  // Show a confirmation message or perform any necessary actions
                  // After confirmation, navigate to the success page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentSuccessPage(item: widget.item),
                    ),
                  );
                }
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
