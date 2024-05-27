import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:flutter/services.dart';

class SavedRepliesPage extends StatelessWidget {
  // Method to copy text to clipboard
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to Clipboard')),
    );
  }

  // Method to delete a saved reply
  void _deleteSavedReply(BuildContext context, String docId) {
    FirebaseFirestore.instance.collection("SavedReplies").doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reply Deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Replies'),
         backgroundColor: Color.fromARGB(255, 4, 83, 158),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("SavedReplies").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Show an error message if there's an error
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Show a message if there's no data
            return Center(child: Text("There are no saved replies"));
          }
          // If data is available, display it
          return ListView(
            children: getSavedRepliesItems(context, snapshot),
          );
        },
      ),
    );
  }

  List<Widget> getSavedRepliesItems(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((doc) {
      // Convert Firestore Timestamp to DateTime
      DateTime savedDate = (doc["saved_date"] as Timestamp).toDate();

      // Format the DateTime using intl package
      String formattedDate = DateFormat.yMMMd().add_jm().format(savedDate);

      return ListTile(
        title: Text(doc["saved"]),
        subtitle: Text(formattedDate),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                String textToCopy = doc["saved"];
                _copyToClipboard(context, textToCopy);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteSavedReply(context, doc.id);
              },
            ),
          ],
        ),
      );
    }).toList();
  }
}
