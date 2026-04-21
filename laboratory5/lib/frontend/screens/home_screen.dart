import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:laboratory5/frontend/theme/app_theme.dart';
import 'package:laboratory5/frontend/widgets/edit_entry_modal.dart';
import 'package:laboratory5/frontend/widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final stream = FirebaseFirestore.instance
        .collection('entries')
        .where('userId', isEqualTo: currentUid)
        // .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: TitleAppBar(title: "Picstoria"),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No entries yet!"));
          }

          final docs = snapshot.data!.docs;

          // Sort the list manually in memory before building the UI
          docs.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aTime =
                (aData['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
            final bTime =
                (bData['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
            return bTime.compareTo(aTime); // Descending order
          });

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final Timestamp? timestamp = data['timestamp'];
              final String formattedDate = timestamp != null
                  ? DateFormat('EEE, MMM d, yyyy').format(timestamp.toDate())
                  : "Date not available";

              final docId = docs[index].id;
              final String imageUrl = data['imageUrl'] ?? '';
              final String title = data['title'] ?? 'Untitled';
              final String caption = data['text'] ?? '';
              final String userId = data['userId'] ?? '';

              return Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. DATE HEADER
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.inkColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 2. IMAGE
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) => Container(
                              height: 180,
                              color: Colors.grey.shade200,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 150,
                            color: Colors.blue.shade50,
                            child: const Center(
                              child: Icon(
                                Icons.notes,
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),
                          ),

                    // 3. CAPTION AREA
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (caption.isNotEmpty)
                            Text(
                              caption,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.inkColor,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // 4. ACTION BUTTONS (Only if owner)
                    if (userId == currentUid) ...[
                      const Divider(height: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                            ),
                            onPressed: () => showEditModal(
                              context,
                              docId,
                              title,
                              caption,
                              imageUrl,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _confirmDelete(context, docId),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // DELETE LOGIC
  Future<void> _confirmDelete(BuildContext context, String docId) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Entry"),
        content: const Text(
          "Are you sure you want to delete this? This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await FirebaseFirestore.instance
            .collection('entries')
            .doc(docId)
            .delete();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Entry deleted successfully!")),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: $e")));
        }
      }
    }
  }
}
