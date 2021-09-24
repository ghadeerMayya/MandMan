// import 'dart:convert';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  String? _userId = '';
  String? _userName='';
  _senMessage() async {
    // final user = FirebaseAuth.instance.currentUser;
    // final userData = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user.uid)
    //     .get();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userName')) {
      final Map<String, dynamic> extractedData =
      json.decode(prefs.getString('userName').toString())
      as Map<String, dynamic>;

      _userId = extractedData['userId'];
      _userName =extractedData['username'];
    }
    // print(_userId);
    //if using mobile i should add this line
    FocusScope.of(context).unfocus();
    //send a message here
    try {
      FirebaseFirestore.instance.collection('chat').add({
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'username': _userName,
        'userId': _userId,
      });
    } catch (e) {
      print(e);
    }
    _controller.clear(); // to zerofy texfield
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed:
                  // _senMessage(),
                  () {
                _enteredMessage.trim().isEmpty ? null : _senMessage();
              }
              // _enteredMessage.trim().isEmpty ? null : _senMessage(),
              ),
        ],
      ),
    );
  }
}
