import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'LoginScreen.dart';

class AdminDashboardUI extends StatelessWidget {
  final bool isAdmin;
  final BuildContext context;

  AdminDashboardUI({required this.isAdmin, required this.context});

  //Text editing controllers for input value
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  void postItem() {
    String itemName = itemNameController.text;
    String description = descriptionController.text;
    String price = priceController.text;
    String imageUrl = imageUrlController.text;

    //Create a new item document
    FirebaseFirestore.instance.collection('items').add({
      'itemName': itemName,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    }).then((value) {
      //Clear the input fields after successful posting
      itemNameController.clear();
      descriptionController.clear();
      priceController.clear();
      imageUrlController.clear();

      //Showing success message to the admin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item posted successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post item. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void deleteItem(String itemId) {
    FirebaseFirestore.instance
        .collection('items')
        .doc(itemId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item deleted successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete item. Please try again'),
          duration: Duration(seconds: 2)));
    });
  }

  void handleDeleteItem(String itemId) {
    deleteItem(itemId);
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logout(context))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post Item',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: itemNameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image',
                  border: OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo_library),
                        onPressed: () async {
                          final pickedImage = await ImagePicker()
                              .getImage(source: ImageSource.gallery);
                          if (pickedImage != null) {
                            // Handle the selected image from gallery
                            // Update the text field with the image URL
                            imageUrlController.text = pickedImage.path;
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                          final pickedImage = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (pickedImage != null) {
                            // Handle the captured image from camera
                            // Update the text field with the image URL
                            imageUrlController.text = pickedImage.path;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: postItem,
                child: Text('Post Item'),
              ),
              SizedBox(height: 24),
              Text(
                'Posted Items',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius value as needed
                  child: Container(
                    color: Colors.grey[300],
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('items')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final items = snapshot.data!.docs;
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final itemData =
                                  items[index].data() as Map<String, dynamic>;
                              final itemId = items[index].id;
                              return ListTile(
                                leading: Image.network(
                                  itemData['imageUrl'],
                                ),
                                title: Text(itemData['itemName'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                subtitle: Text(
                                  itemData['description'],
                                  maxLines: 5,
                                  style: TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    handleDeleteItem(itemId);
                                  },
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
