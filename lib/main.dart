import 'package:flutter/material.dart';

void main() => runApp(const TodoListApp());

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoListCategories',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final Map<String, List<String>> _categories = {};
  final Map<String, TextEditingController> _taskControllers = {};

  final TextEditingController _categoryController = TextEditingController();

  void _addCategory(String name) {
    if (name.isEmpty) return;
    setState(() {
      _categories[name] = [];
      _taskControllers[name] = TextEditingController();
    });
  }

  void _addTask(String category) {
    final controller = _taskControllers[category];
    if (controller == null) return;
    final task = controller.text;
    if (task.isEmpty) return;
    setState(() {
      _categories[category]?.add(task);
      controller.clear();
    });
  }

  void _deleteTask(String category, int index) {
    setState(() {
      _categories[category]?.removeAt(index);
    });
  }

  void _showAddCategoryDialog() {
    _categoryController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: _categoryController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addCategory(_categoryController.text.trim());
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _taskControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoListCategories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: _categories.keys.map((category) {
            final tasks = _categories[category] ?? [];
            final taskController = _taskControllers[category];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (int i = 0; i < tasks.length; i++) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tasks[i]),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () => _deleteTask(category, i),
                          ),
                        ],
                      ),
                    ],
                    const Divider(thickness: 1),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: taskController,
                            decoration: const InputDecoration(
                              hintText: 'New task',
                            ),
                            onSubmitted: