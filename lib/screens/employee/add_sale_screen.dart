import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import 'cart_screen.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({super.key});

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Produk'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              PositionDetector(
                child: Consumer<SalesProvider>(
                  builder: (context, sales, _) => sales.cart.isEmpty
                      ? const SizedBox.shrink()
                      : Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${sales.cart.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productProvider.products.isEmpty) {
            return const Center(child: Text('Tidak ada produk tersedia.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.brown[100],
                      child:
                          product.imageUrl != null &&
                              product.imageUrl!.isNotEmpty
                          ? Image.network(
                              AppConstants.productImagesUrl + product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.coffee),
                            )
                          : const Icon(Icons.coffee, color: Colors.brown),
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Rp ${product.price} | Stok: ${product.stock}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color(0xFF6B4226),
                    ),
                    onPressed: product.stock > 0
                        ? () {
                            Provider.of<SalesProvider>(
                              context,
                              listen: false,
                            ).addToCart(
                              product.id,
                              product.name,
                              product.price,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ditambahkan ke keranjang'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PositionDetector extends StatelessWidget {
  final Widget child;
  const PositionDetector({super.key, required this.child});
  @override
  Widget build(BuildContext context) => child;
}
