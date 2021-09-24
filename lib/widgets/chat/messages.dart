import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mandman/providers/auth.dart';
import 'package:mandman/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Messages extends StatelessWidget {
  String _currentUserId = '';

  @override
  Widget build(BuildContext context) {
    Auth().getCurrentUID().then((value) => _currentUserId = value);
    // print('id');
    // print(_currentUserId);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data != null) {
          final docs = snapshot.data!.docs;
          // print(_currentUserId);

          return ListView.builder(
              reverse: true,
              itemCount: docs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                    docs[index]['text'],
                    docs[index]['username'],
                    docs[index]['userId'] == _currentUserId,
                    //will pass true if equal
                    key: ValueKey(docs[index].id),
                  ));
        } else {
          return Center(
            child: Text('No messages'),
          );
        }
      },
    );
  }
}
