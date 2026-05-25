import 'package:flutter/material.dart';
import 'package:tasksphere/core/widgets/Layouts/Scaffold_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FeatureValue {
  counter({
    "title": "Counter",
    "icon": Icons.add,
    "route": "/counter",
    "description": "A simple counter app",
  }),

  todo({
    "title": "Todo App",
    "icon": Icons.list,
    "route": "/todos",
    "description": "A simple todo app",
  });

  const FeatureValue(this.options);

  final Map<String, dynamic> options;
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: FeatureValue.values.map((feature) {
          return SizedBox(
            width: 350,
            child: Card(
              elevation: .5,
              child: ListTile(
                leading: Icon(feature.options["icon"]),
                title: Text(
                  feature.options["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  feature.options["description"],
                  style: const TextStyle(fontSize: 13),
                ),
                trailing: const Icon(Icons.arrow_forward, size: 18),
                onTap: () {
                  Navigator.pushNamed(context, feature.options["route"]);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
