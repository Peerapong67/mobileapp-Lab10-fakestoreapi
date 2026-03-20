import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    Future.microtask(() => provider.fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Barrel Store"),
        actions: [
          IconButton(
            icon: Badge(
              label: Text("${context.watch<CartProvider>().uniqueItemCount}"),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            ),
          ),
        ],
      ),
      body: productProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: productProvider.products.length,
              itemBuilder: (ctx, i) {
                final product = productProvider.products[i];
                return Card(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      ctx,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    ),
                    child: Column(children: [
                      Expanded(
                        child: Image.network(product.image, fit: BoxFit.contain),
                      ),
                      Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text("\$${product.price}"),
                      ElevatedButton(
                        onPressed: () => context.read<CartProvider>().addToCart(product),
                        child: Text("Add to Cart"),
                      )
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
