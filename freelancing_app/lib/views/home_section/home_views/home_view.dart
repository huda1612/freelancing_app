import 'package:flutter/material.dart';
import 'package:freelancing_platform/views/auth_section/auth_controller/sign_out_controller.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الرئيسية"),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () =>
                  Get.put<SignOutController>(SignOutController()).signOut(),
              icon: Icon(Icons.output_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "مرحباً بك 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "إليك بعض الاقتراحات والمشاريع المناسبة لك",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  _SuggestionCard(title: "مشاريع مقترحة لك"),
                  _SuggestionCard(title: "أفضل المستقلين"),
                  _SuggestionCard(title: "عملاء يبحثون عن خدماتك"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String title;

  const _SuggestionCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
