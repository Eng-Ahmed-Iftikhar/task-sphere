import 'package:flutter/material.dart';
import 'package:tasksphere/core/constants/app_constants.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void decrementCounter() {
    setState(() {
      if (counter == 0) return;
      counter--;
    });
  }

  void resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Theme.brightnessOf(context);
    final isDarkMode = themeMode == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Counter App",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "$counter",
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: decrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.secondaryColor,
                  ),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: resetCounter,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Reset"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: incrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.secondaryColor,
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
