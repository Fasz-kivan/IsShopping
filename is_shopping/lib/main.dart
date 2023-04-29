import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("IsShopping"),
        centerTitle: true,
      ),
      body: const Center(
          child: Text(
        "XD",
        style: TextStyle(
          fontSize: 200,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      )),
      floatingActionButton: const FloatingActionButton(
        onPressed: showAddingDialog,
        child: Icon(Icons.add),
      ),
    )));

void showAddingDialog() {}
