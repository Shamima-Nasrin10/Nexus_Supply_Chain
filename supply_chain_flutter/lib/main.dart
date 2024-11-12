import 'package:flutter/material.dart';
import 'package:supply_chain_flutter/pages/homepage.dart';
import 'package:supply_chain_flutter/pages/loginpage.dart';
import 'package:supply_chain_flutter/pages/raw_material/procurement_create_page.dart';
import 'package:supply_chain_flutter/pages/raw_material/procurement_list_page.dart';
import 'package:supply_chain_flutter/pages/raw_material/raw_mat_category_list.dart';
import 'package:supply_chain_flutter/pages/raw_material/raw_mat_list_page.dart';
import 'package:supply_chain_flutter/pages/raw_material/supplier_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supply Chain Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/procurementList': (context) => ProcurementListPage(),
        '/procurementCreate': (context) => ProcurementCreatePage(),
        '/rawMatCategoryList': (context) => RawMaterialCategoryListPage(),
        '/rawMatList': (context) => RawMatListPage(),
        '/supplierList': (context) => SupplierListPage(),
        '/login': (context) => Login(),
      },
    );
  }
}
