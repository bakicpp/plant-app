import 'package:flutter/material.dart';
import 'package:plant_app/firebase_services/database_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(child: Text("Hello World")),
          textField(),
          button(),
        ],
      ),
    );
  }

  ElevatedButton button() => ElevatedButton(
      onPressed: () {
        FirebaseCollection("users").addDocument({"name": "John Doe"});
        print("added data");
      },
      child: const Text("add data"));

  Padding textField() {
    return const Padding(
      padding: EdgeInsets.all(18.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter your username',
        ),
      ),
    );
  }
}
