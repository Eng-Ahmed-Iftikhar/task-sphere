import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/features/todos/presentation/providers/todo_providers.dart';

class UpdateTodoScreen extends ConsumerStatefulWidget {
  final String id;

  const UpdateTodoScreen({super.key, required this.id});

  @override
  ConsumerState<UpdateTodoScreen> createState() => _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends ConsumerState<UpdateTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    getTodo();
    super.initState();
  }

  Future<void> getTodo() async {
    final todoActions = ref.read(todoProvider.notifier);
    final todo = await todoActions.getById(id: widget.id);
    todo.fold(
      (failure) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (todo) {
        if (!mounted) return;
        setState(() {
          titleController.text = todo.title;
          descriptionController.text = todo.description;
        });
      },
    );
  }

  Future<void> updateTodo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final todoActions = ref.read(todoProvider.notifier);
    setState(() {
      isLoading = true;
    });
    await todoActions.updateOne(
      id: widget.id,
      title: titleController.text,
      description: descriptionController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Todo updated successfully")));

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Todo")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : updateTodo,
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
                : const Text("update"),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
