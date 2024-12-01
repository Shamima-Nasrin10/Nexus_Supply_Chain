import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../util/apiresponse.dart';
import 'dashboard_service.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int supplierCount = 0;
  int retailerCount = 0;
  List<dynamic> productStockData = [];

  // Bar Chart Data
  List<BarChartGroupData> barChartData = [];

  // Pie Chart Data
  List<PieChartSectionData> pieChartData = [];

  @override
  void initState() {
    super.initState();
    loadDashboardStats();
  }

  // Fetching the dashboard data
  Future<void> loadDashboardStats() async {
    try {
      ApiResponse response = await DashboardService().getDashboardStats();
      if (response.success) {
        setState(() {
          supplierCount = response.data?['supplierCount'];
          retailerCount = response.data?['retailerCount'];
          productStockData = response.data?['productStock'];

          // Update Bar Chart Data
          barChartData = [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: supplierCount.toDouble(),
                  color: Color(0xFFB03D49), // Red color for Suppliers
                  width: 30,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: retailerCount.toDouble(),
                  color: Color(0xFF03A58A), // Green color for Retailers
                  width: 30,
                ),
              ],
            ),
          ];

          // Update Pie Chart Data
          pieChartData = productStockData.map((item) {
            return PieChartSectionData(
              value: item['totalStock'].toDouble(),
              title: item['productName'],
              color: Colors.primaries[productStockData.indexOf(item) % Colors.primaries.length],
              radius: 50,
              titleStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            );
          }).toList();
        });
      } else {
        print('Failed to load data: ${response.message}');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Heading for Bar Chart
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Supplier and Retailer Counts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Bar Chart Section
            Expanded(
              child: BarChart(
                BarChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Suppliers');
                            case 1:
                              return Text('Retailers');
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: barChartData,
                ),
              ),
            ),

            SizedBox(height: 30),

            // Heading for Pie Chart
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Product Stock Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Pie Chart Section
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: pieChartData,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
