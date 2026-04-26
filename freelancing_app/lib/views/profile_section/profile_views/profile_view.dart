import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_nav_bar.dart';


class TestNavScreen extends StatefulWidget {
  final bool isClient; // true = عميل، false = مستقل

  const TestNavScreen({super.key, required this.isClient});

  @override
  State<TestNavScreen> createState() => _TestNavScreenState();
}

class _TestNavScreenState extends State<TestNavScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    Center(child: Text("الصفحة الرئيسية", style: TextStyle(fontSize: 22))),
    Center(child: Text("البحث", style: TextStyle(fontSize: 22))),
    Center(child: Text("الرسائل", style: TextStyle(fontSize: 22))),
    Center(child: Text("البروفايل", style: TextStyle(fontSize: 22))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        isClient: widget.isClient, // إذا عميل يظهر زر +
      ),
    );
  }
}
