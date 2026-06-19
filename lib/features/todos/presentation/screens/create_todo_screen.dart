import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/widgets/layouts/scaffold_layout.dart';
import 'package:tasksphere/features/todos/presentation/providers/todo_providers.dart';

class CreateTodoScreen extends ConsumerStatefulWidget {
  const CreateTodoScreen({super.key});

  @override
  ConsumerState<CreateTodoScreen> createState() => _CreateTodoScreenState();
}

class _CreateTodoScreenState extends ConsumerState<CreateTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void saveTodo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final todoActions = ref.read(todoProvider.notifier);
    setState(() {
      isLoading = true;
    });
    await todoActions.create(
      title: titleController.text,
      description: descriptionController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Todo created successfully")));
    titleController.clear();
    descriptionController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldLayout(
      appBar: AppBar(title: Text("Create todo")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : saveTodo,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLoading
                  ? Colors.grey
                  : AppConstants.primaryColor,
            ),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text("Save"),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
