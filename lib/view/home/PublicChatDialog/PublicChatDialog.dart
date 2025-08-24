import 'package:flutter/material.dart';

class PublicChatDialog extends StatelessWidget {
  const PublicChatDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 400,
        height: 500,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Public Chat",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Chat area (can be a ListView)
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text("No messages yet..."), // Replace with ListView.builder later
              ),
            ),

            // Message input area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Type message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {
                      // TODO: Add file picker
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      // TODO: Send message
                    },
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
