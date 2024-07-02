import 'package:flutter/material.dart';

class Recipes extends StatelessWidget {
  const Recipes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: Colors.deepPurple[100],
        backgroundColor: Colors.deepPurple[600],
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Text("Recipes"),
      ),
    );
  }
}
