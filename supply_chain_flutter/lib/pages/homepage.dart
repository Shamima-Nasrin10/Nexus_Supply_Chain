import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Supply Chain Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.blueAccent),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              icon: Icons.shopping_cart,
              label: 'Procurement',
              routeName: '/procurementList',
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
              ),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.category,
              label: 'Raw Materials Category',
              routeName: '/rawMatCategoryList',
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
              ),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.list,
              label: 'Raw Materials List',
              routeName: '/rawMatList',
              gradient: LinearGradient(
                colors: [Colors.greenAccent, Colors.tealAccent],
              ),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.people,
              label: 'Suppliers',
              routeName: '/supplierList',
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
              ),
            ),
            _buildDashboardCard(
              context,
              icon: Icons.business,
              label: 'Production',
              routeName: '/prodProductList',
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String routeName,
        required Gradient gradient,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
