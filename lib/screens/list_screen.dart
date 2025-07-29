import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> people;

  ListScreen({required this.people});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  void _deletePerson(int index) {
    setState(() {
      widget.people.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Personas")),
      body: widget.people.isEmpty
          ? Center(child: Text("No hay personas ingresadas."))
          : ListView.builder(
        itemCount: widget.people.length,
        itemBuilder: (context, index) {
          final person = widget.people[index];
          return ListTile(
            title: Text(person['name']),
            subtitle: Text("Edad: ${person['age']} - Email: ${person['email']}"),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePerson(index),
            ),
          );
        },
      ),
    );
  }
}
