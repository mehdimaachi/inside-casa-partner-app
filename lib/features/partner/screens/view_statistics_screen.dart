import 'package:flutter/material.dart';

class ViewStatisticsScreen extends StatelessWidget {
  const ViewStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Performance Statistics"),
      ),
      body: const Center(
        child: Text("Charts and reports will be shown here."),
      ),
    );
  }
}