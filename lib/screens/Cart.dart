import 'package:flutter/material.dart';
import 'package:menopal/screens/CheckoutPage.dart';

import 'item.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = Cart.getItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            child: ClipPath(
              clipper: CustomClipPath(),
              child: Container(
                height: 120,
                width: 1920,
                color: Colors.pink,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
                  child: Text(
                    'My Cart',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: ListTile(
                    leading: Image.network(cartItems[index]['image']),
                    title: Text(
                      cartItems[index]['name'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \Rs.${cartItems[index]['price']}',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              cartItems.removeAt(index);
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Perform buy now action for the item
                            buyNowAction(cartItems[index]);
                          },
                          child: Text('Buy Now'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.pink[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Powered by ',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
            Text(
              'Menopal',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 173, 81, 81),
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.circle, size: 8, color: Colors.white),
            SizedBox(width: 10),
            Text(
              '© 2023 Menopal, Inc. All rights reserved.',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void buyNowAction(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(item: item),
      ),
    );
  }
}

class Cart {
  static List<Map<String, dynamic>> items = [];

  static void addItem(Map<String, dynamic> item) {
    items.add(item);
  }

  static void removeItem(Map<String, dynamic> item, int index) {
    items.removeAt(index);
  }

  static List<Map<String, dynamic>> getItems() {
    return items;
  }
}
