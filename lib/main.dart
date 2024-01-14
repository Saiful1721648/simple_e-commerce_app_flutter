import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final String color;
  int quantity = 0;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.color,
  });
}
class ProductCard extends StatelessWidget {
  final Product product;
  final ValueChanged<int> onQuantityChanged;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: Image.network(product.imageUrl),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Color: ${product.color}'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (product.quantity > 0) {
                                onQuantityChanged(product.quantity - 1);
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${product.quantity}'),
                          IconButton(
                            onPressed: () {
                              onQuantityChanged(product.quantity + 1);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      Text('\$${product.price.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> products = [
    Product(
      id: 1,
      name: 'T-Shirt1',
      imageUrl: 'https://example.com/tshirt.jpg',
      price: 25.99,
      color: 'Blue',
    ),
    Product(
      id: 2,
      name: 'T-Shirt2',
      imageUrl: 'https://example.com/tshirt.jpg',
      price: 25.99,
      color: 'Blue',
    ),
    Product(
      id: 3,
      name: 'T-Shirt3',
      imageUrl: 'https://example.com/tshirt.jpg',
      price: 25.99,
      color: 'Blue',
    ),
    // ...other products
  ];

  double totalPrice = 0; // Changed to double

  void updateTotalPrice() {
    totalPrice = 0;
    for (var product in products) {
      totalPrice += product.quantity * product.price;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            onQuantityChanged: (newQuantity) {
              setState(() {
                products[index].quantity = newQuantity;
                updateTotalPrice();
                if (newQuantity == 5) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AlertDialog(
                          title: Text('Item Added'),
                          content: Text(
                              'You have added 5 ${products[index]
                                  .name} on your bag!'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                  );
                }
              });
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, -2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: \\\$${totalPrice.toStringAsFixed(2)}', // Escaped $
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(

              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Congratulations on your purchase!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  child: const Text(
                    'CHECK OUT',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
