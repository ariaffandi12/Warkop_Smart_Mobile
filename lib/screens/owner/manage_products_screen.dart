import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/constants.dart';
import 'add_product_screen.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
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
      appBar: AppBar(title: const Text('Kelola Produk')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddProductScreen()),
        ),
        backgroundColor: const Color(0xFF6B4226),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading)
            return const Center(child: CircularProgressIndicator());

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: product.imageUrl != null
                        ? NetworkImage(
                                AppConstants.productImagesUrl +
                                    product.imageUrl!,
                              )
                              as ImageProvider
                        : null,
                    child: product.imageUrl == null
                        ? const Icon(Icons.coffee)
                        : null,
                  ),
                  title: Text(product.name),
                  subtitle: Text(
                    'Rp ${product.price} | Stok: ${product.stock}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _showUpdateStockDialog(
                        context,
                        product.id,
                        product.stock,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUpdateStockDialog(BuildContext context, int id, int currentStock) {
    final controller = TextEditingController(text: currentStock.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Stok'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Jumlah Stok Baru'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await Provider.of<ProductProvider>(
                context,
                listen: false,
              ).updateStock(id, int.parse(controller.text));
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Stok diperbarui' : 'Gagal update stok',
                    ),
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
