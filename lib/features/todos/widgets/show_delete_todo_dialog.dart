import 'package:flutter/material.dart';

Future<void> showDeleteTodoDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Delete Todo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to delete this todo? This action cannot be undone.",
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            icon: const Icon(Icons.delete_rounded),
            label: const Text("Delete"),
          ),
        ],
      );
    },
  );
}
