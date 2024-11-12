import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supply_chain_flutter/model/raw_material/procurement_model.dart';
import 'package:supply_chain_flutter/pages/raw_material/procurement_create_page.dart';
import 'package:supply_chain_flutter/util/apiresponse.dart';
import '../../service/raw_material/procurement_service.dart';

class ProcurementListPage extends StatefulWidget {
  @override
  _ProcurementListPageState createState() => _ProcurementListPageState();
}

class _ProcurementListPageState extends State<ProcurementListPage> {
  final ProcurementService _procurementService = ProcurementService();
  List<Procurement> _procurements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProcurements();
  }

  Future<void> _fetchProcurements() async {
    setState(() {
      _isLoading = true;
    });

    ApiResponse response = await _procurementService.getAllProcurements();

    if (response.success) {
      setState(() {
        _procurements = (response.data?['procurements'] as List)
            .map((json) => Procurement.fromJson(json))
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load procurements')),
      );
    }
  }

  void _navigateToCreateProcurement() async {
    final newProcurement = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcurementCreatePage(),
      ),
    );

    if (newProcurement != null) {
      _fetchProcurements();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procurement List',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        elevation: 4,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _procurements.isEmpty
          ? Center(
          child: Text('No procurements available.',
              style: TextStyle(fontSize: 16, color: Colors.grey)))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _procurements.length,
        itemBuilder: (context, index) {
          final procurement = _procurements[index];
          return _buildProcurementCard(procurement);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateProcurement,
        child: Icon(Icons.add),
        tooltip: 'Create Procurement',
      ),
    );
  }

  Widget _buildProcurementCard(Procurement procurement) {
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
            _buildCardHeader(procurement),
            SizedBox(height: 16),
            _buildCardDetails(procurement),
            Divider(thickness: 1, color: Colors.grey.shade300),
            _buildActionButtons(procurement),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(Procurement procurement) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Procurement Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blueAccent,
          ),
        ),
        Text(
          DateFormat('yyyy-MM-dd').format(procurement.procurementDate ?? DateTime.now()),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCardDetails(Procurement procurement) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.inventory, 'Raw Material', procurement.rawMaterial?.name ?? 'N/A'),
        _buildDetailRow(Icons.business, 'Supplier', procurement.supplier?.companyName ?? 'N/A'),
        _buildDetailRow(Icons.production_quantity_limits, 'Quantity', '${procurement.quantity ?? 0}'),
        _buildDetailRow(Icons.monetization_on, 'Unit Price', '\$${procurement.unitPrice?.toStringAsFixed(2) ?? '0.00'}'),
        _buildDetailRow(Icons.attach_money, 'Total Price', '\$${(procurement.quantity ?? 0) * (procurement.unitPrice ?? 0.0)}'),
        _buildDetailRow(Icons.check_circle, 'Status', procurement.status.toString().split('.').last),
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

  Widget _buildActionButtons(Procurement procurement) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text('Edit', style: TextStyle(color: Colors.blueAccent)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProcurementCreatePage(procurement: procurement),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        TextButton(
          child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
          onPressed: () async {
            final confirm = await _confirmDelete(context);
            if (confirm) {
              await _deleteProcurement(procurement.id);
            }
          },
        ),
      ],
    );
  }

  Future<void> _deleteProcurement(int? id) async {
    if (id == null) return;

    ApiResponse response = await _procurementService.deleteProcurementById(id);
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Procurement deleted successfully')),
      );
      _fetchProcurements(); // Refresh the list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete procurement')),
      );
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Procurement'),
        content: Text('Are you sure you want to delete this procurement?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ??
        false;
  }
}
