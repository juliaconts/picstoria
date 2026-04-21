import 'package:flutter/material.dart';
import 'package:laboratory5/backend/services/database_service.dart';

class AddEntryModal extends StatefulWidget {
  const AddEntryModal({super.key});

  @override
  State<AddEntryModal> createState() => _AddEntryModalState();
}

class _AddEntryModalState extends State<AddEntryModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _textController = TextEditingController();

  // Helper method to create consistent inputs
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ), // Form styling
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "New Entry",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: _titleController,
              decoration: _inputDecoration("Title", Icons.title),
              validator: (val) => val!.isEmpty ? "Please enter a title" : null,
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: _urlController,
              decoration: _inputDecoration("Image URL", Icons.image),
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: _textController,
              decoration: _inputDecoration("Write your entry...", Icons.edit),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await DatabaseService().addEntry(
                        _titleController.text,
                        _urlController.text,
                        _textController.text,
                      );
                      if (mounted) Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  }
                },
                child: const Text("Post Entry"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}
