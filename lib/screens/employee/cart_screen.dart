import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sales_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sales = Provider.of<SalesProvider>(context);
    final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Pesanan Anda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: sales.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_basket_outlined,
                    size: 80,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: sales.cart.length,
                    itemBuilder: (context, index) {
                      final item = sales.cart[index];
                      // Get product stock from ProductProvider
                      final products = Provider.of<ProductProvider>(
                        context,
                      ).products;
                      dynamic product;
                      try {
                        product = products.firstWhere(
                          (p) => p.id == item.productId,
                        );
                      } catch (_) {
                        product = null;
                      }
                      final maxStock = product?.stock ?? 999;

                      return Dismissible(
                        key: Key('cart_${item.productId}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                        ),
                        onDismissed: (_) {
                          sales.removeFromCart(item.productId);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.coffee_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${item.price} x ${item.quantity}',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (maxStock < 999)
                                      Text(
                                        'Stok tersedia: $maxStock',
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 10,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // Quantity Controls: - qty +
                              Row(
                                children: [
                                  // Decrement button
                                  GestureDetector(
                                    onTap: () {
                                      sales.decrementQuantity(item.productId);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.remove_rounded,
                                        color: AppColors.error,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  // Quantity display
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  // Increment button
                                  GestureDetector(
                                    onTap: () {
                                      if (item.quantity < maxStock) {
                                        sales.incrementQuantity(
                                          item.productId,
                                          maxStock: maxStock,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '⚠️ Stok maksimal ${item.productName} adalah $maxStock!',
                                            ),
                                            backgroundColor: AppColors.error,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: item.quantity < maxStock
                                            ? AppColors.success.withOpacity(0.1)
                                            : AppColors.textMuted.withOpacity(
                                                0.1,
                                              ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: item.quantity < maxStock
                                            ? AppColors.success
                                            : AppColors.textMuted,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              // Total price for this item
                              Text(
                                'Rp ${item.price * item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Premium Checkout Summary
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 40,
                        offset: Offset(0, -10),
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
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Rp ${sales.totalAmount}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: sales.isLoading
                              ? null
                              : () async {
                                  final success = await sales.processSale(
                                    userId!,
                                  );
                                  if (success && context.mounted) {
                                    await Provider.of<ProductProvider>(
                                      context,
                                      listen: false,
                                    ).fetchProducts();

                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('🎉 Transaksi Berhasil!'),
                                        backgroundColor: AppColors.success,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.primary.withOpacity(0.4),
                          ),
                          child: sales.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'KONFIRMASI PESANAN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
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
