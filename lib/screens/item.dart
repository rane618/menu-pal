import 'package:flutter/material.dart';
import 'package:menopal/screens/Cart.dart';
import 'data.dart';

class ProductDetail extends StatefulWidget {
  final int index;

  ProductDetail({required this.index});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _quantity = 1;
  late double _price;

  void _updatePrice() {
    setState(() {
      _price = double.tryParse(data[widget.index]['price']) ?? 0.0;
      _price *= _quantity;
    });
  }

  @override
  void initState() {
    super.initState();
    _updatePrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                          data[widget.index]['name'],
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Image.network(
                  data[widget.index]['image'],
                  height: 200,
                  width: 200,
                ),
              ),
              SizedBox(height: 20),
              Text(
                data[widget.index]['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  data[widget.index]['description'],
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: 'Total Price: ',
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                      text: '\Rs. $_price',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        _quantity = _quantity > 1 ? _quantity - 1 : 1;
                        _updatePrice();
                      });
                    },
                  ),
                  Text(
                    '$_quantity',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                        _updatePrice();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Cart.addItem(data[widget.index]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added $_quantity item(s) to cart.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: Text('Add to Cart',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
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
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 2);
    path.cubicTo(size.width / 4, 3 * (size.height / 2), 3 * (size.width / 4),
        size.height / 2, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
