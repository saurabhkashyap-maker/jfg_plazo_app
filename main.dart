import 'package:flutter/material.dart';

void main() => runApp(JFGApp());

class JFGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jha Fashion Groups',
      theme: ThemeData(primarySwatch: Colors.pink),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class Product {
  final String name, price, size, description;
  Product(this.name, this.price, this.size, this.description);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> allProducts = [
    Product('Cotton Printed Plazo', '₹150', 'Free Size',
        'Light cotton, daily wear'),
    Product(
        'Lycra Stretch Plazo', '₹180', 'XL', 'Stretchable waist, ankle length'),
    Product(
        'Rayon Designer Plazo', '₹210', 'XXL', 'Soft rayon with side pockets'),
    Product('Floral Summer Plazo', '₹160', 'Free Size',
        'Breathable cotton, floral prints'),
    Product('Plain Office Wear Plazo', '₹190', 'XL, XXL',
        'Professional wrinkle-free look')
  ];
  List<Product> cart = [];
  List<Product> orderHistory = [];
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Product> displayed = allProducts
        .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('JFG Plazo Catalog'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => OrderHistoryScreen(orderHistory)));
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CartScreen(cart, onCheckout)));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search plazos...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: displayed.length,
        itemBuilder: (context, index) {
          final product = displayed[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(product.name),
              subtitle: Text('${product.description}\nSize: ${product.size}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(product.price,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () => setState(() => cart.add(product)),
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void onCheckout() {
    setState(() {
      orderHistory.addAll(cart);
      cart.clear();
    });
  }
}

class CartScreen extends StatelessWidget {
  final List<Product> cart;
  final VoidCallback onCheckout;
  CartScreen(this.cart, this.onCheckout);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: cart.isEmpty
          ? Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(product.price),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      onCheckout();
                      Navigator.pop(context);
                    },
                    child: Text("Checkout"),
                  ),
                )
              ],
            ),
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  final List<Product> history;
  OrderHistoryScreen(this.history);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order History")),
      body: history.isEmpty
          ? Center(child: Text("No past orders"))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final product = history[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.price),
                );
              },
            ),
    );
  }
}
