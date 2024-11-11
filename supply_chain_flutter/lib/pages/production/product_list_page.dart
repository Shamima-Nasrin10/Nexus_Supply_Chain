import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/model/production/product_model.dart';
import 'package:supply_chain_flutter/service/production/product_service.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

import '../../dialog/add_product_dialog.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final response = await ProductService().getAllProducts();

    if (response.success) {
      setState(() {
        if (response.data != null && response.data!['products'] != null) {
          products = (response.data!['products'] as List)
              .map((json) => Product.fromJson(json))
              .toList();
        } else {
          NotifyUtil.error(context, 'Data format is incorrect');
        }
      });
    } else {
      NotifyUtil.error(context, response.message ?? 'Failed to load products');
    }
  }

  Future<void> deleteProduct(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete')),
        ],
      ),
    );

    if (confirmDelete) {
      final response = await ProductService().deleteProductById(id);
      if (response.success) {
        NotifyUtil.success(
            context, response.message ?? 'Product deleted successfully');
        loadProducts(); // Refresh list after deletion
      } else {
        NotifyUtil.error(
            context, response.message ?? 'Failed to delete product');
      }
    }
  }

  Future<void> openAddProductDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AddProductDialog(onSave: loadProducts),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.blueAccent, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "Product List",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.blueAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image display
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: product.image != null
                                ? Image.network(
                                    'http://localhost:8080/images/products/${product.image}',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.broken_image, size: 80),
                                  )
                                : Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image,
                                        size: 40, color: Colors.grey[700]),
                                  ),
                          ),
                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.description ?? 'No Description',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        // Handle edit
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () =>
                                          deleteProduct(product.id!),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddProductDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
