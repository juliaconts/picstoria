import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showEditModal(
  BuildContext context,
  String docId,
  String currentTitle,
  String currentText,
  String currentUrl,
) {
  final titleController = TextEditingController(text: currentTitle);
  final textController = TextEditingController(text: currentText);
  final urlController = TextEditingController(
    text: currentUrl,
  ); // Added Controller for URL

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the modal to resize for the keyboard
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      // This padding ensures the modal stays above the keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Edit Entry",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),

          // NEW IMAGE URL INPUT FIELD
          TextField(
            controller: urlController,
            decoration: const InputDecoration(
              labelText: "Image URL",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.link), // Add a link icon for visual cue
            ),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: "Write your entry...",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity, // Stretch button full width for pro look
            height: 50,
            child: ElevatedButton(
              // Inside the ElevatedButton onPressed in edit_entry_modal.dart:
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('entries')
                      .doc(docId)
                      .update({
                        'title': titleController.text,
                        'text': textController.text,
                        'imageUrl': urlController.text,
                      });

                  // Close the modal
                  if (ctx.mounted) Navigator.pop(ctx);

                  // Show Success Box
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Entry updated successfully!"),
                      ),
                    );
                  }
                } catch (e) {
                  // Optional: Add error feedback here too
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to update: $e")),
                    );
                  }
                }
              },
              child: const Text("Save Changes"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
