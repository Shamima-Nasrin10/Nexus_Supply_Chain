import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supply_chain_flutter/model/accounts/sales_model.dart';
import 'package:supply_chain_flutter/service/accounts/sales_service.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';
import '../../dialog/add_sales_dialog.dart';

class SalesListPage extends StatefulWidget {
  @override
  _SalesListPageState createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  final SalesService _salesService = SalesService();
  List<Sales> _sales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSales();
  }

  Future<void> _fetchSales() async {
    setState(() {
      _isLoading = true;
    });

    ApiResponse response = await _salesService.getAllSales();

    if (response.success) {
      setState(() {
        _sales = (response.data?['sales'] as List)
            .map((json) => Sales.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load sales')),
      );
    }
  }

  void _navigateToCreateSale() async {
    final newSale = await showDialog<Sales>(
      context: context,
      builder: (BuildContext context) {
        return SalesCreateDialog();
      },
    );

    if (newSale != null) {
      ApiResponse response = await _salesService.saveSale(newSale);
      if (response.success) {
        _fetchSales(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create sale')),
        );
      }
    }
  }

  void _navigateToEditSale(Sales sale) async {
    final updatedSale = await showDialog<Sales>(
      context: context,
      builder: (BuildContext context) {
        return SalesCreateDialog(sales: sale);
      },
    );

    if (updatedSale != null) {
      ApiResponse response = await _salesService.saveSale(updatedSale);
      if (response.success) {
        _fetchSales();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update sale')),
        );
      }
    }
  }

  // Function to handle Delete Sale
  void _deleteSale(Sales sale) async {
    ApiResponse response = await _salesService.deleteSaleById(sale.id!);

    if (response.success) {
      _fetchSales(); // Refresh the list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sale deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete sale')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales List',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        elevation: 4,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _sales.isEmpty
          ? Center(
          child: Text('No sales available.',
              style: TextStyle(fontSize: 16, color: Colors.grey)))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _sales.length,
        itemBuilder: (context, index) {
          final sale = _sales[index];
          return _buildSalesCard(sale);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateSale,
        child: Icon(Icons.add),
        tooltip: 'Create Sale',
      ),
    );
  }

  Widget _buildSalesCard(Sales sales) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      shadowColor: Colors.grey.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(sales),
            SizedBox(height: 16),
            _buildCardDetails(sales),
            Divider(thickness: 1, color: Colors.grey.shade300),
            _buildActionButtons(sales),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(Sales sales) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sales Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blueAccent,
          ),
        ),
        Text(
          DateFormat('yyyy-MM-dd').format(sales.salesDate ?? DateTime.now()),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCardDetails(Sales sales) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.inventory, 'Product', sales.productionProduct?.product?.name ?? 'N/A'),
        _buildDetailRow(Icons.person, 'Retailer', sales.productRetailer?.companyName ?? 'N/A'),
        _buildDetailRow(Icons.production_quantity_limits, 'Quantity', '${sales.quantity ?? 0}'),
        _buildDetailRow(Icons.monetization_on, 'Unit Price', '\$${sales.unitPrice?.toStringAsFixed(2) ?? '0.00'}'),
        _buildDetailRow(Icons.attach_money, 'Total Price', '\$${sales.totalPrice?.toStringAsFixed(2) ?? '0.00'}'),
        _buildDetailRow(Icons.check_circle, 'Status', sales.status?.toString().split('.').last ?? 'N/A'),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Sales sales) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text('Edit', style: TextStyle(color: Colors.blueAccent)),
          onPressed: () => _navigateToEditSale(sales), // Edit functionality
        ),
        const SizedBox(width: 8),
        TextButton(
          child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
          onPressed: () => _deleteSale(sales), // Delete functionality
        ),
      ],
    );
  }
}
