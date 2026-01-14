import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/auth_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final userId = Provider.of<AuthProvider>(context, listen: false).user!.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: salesProvider.cart.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: salesProvider.cart.length,
                    itemBuilder: (context, index) {
                      final item = salesProvider.cart[index];
                      return ListTile(
                        title: Text(item.productName),
                        subtitle: Text('Rp ${item.price} x ${item.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ${item.price * item.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  salesProvider.removeFromCart(item.productId),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Rp ${salesProvider.totalAmount}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B4226),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: salesProvider.isLoading
                              ? null
                              : () async {
                                  final success = await salesProvider
                                      .processSale(userId);
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Transaksi Berhasil!'),
                                      ),
                                    );
                                    Navigator.pop(context); // Back to products
                                    Navigator.pop(context); // Back to dashboard
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B4226),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: salesProvider.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'PROSES TRANSAKSI',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
