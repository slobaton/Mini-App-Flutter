import 'package:flutter/material.dart';
import 'list_screen.dart';

class FormScreen extends StatefulWidget {
  final String userEmail;
  FormScreen({required this.userEmail});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();

  String name = '';
  int age = 0;
  String email = '';
  List<Map<String, dynamic>> people = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("¡Bienvenido!"),
          content: Text("Has iniciado sesión como:\n${widget.userEmail}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        people.add({'name': name, 'age': age, 'email': email});
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Datos guardados"),
          content: Text("Nombre: $name\nEdad: $age\nCorreo: $email"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nameController.clear();
                _ageController.clear();
                _emailController.clear();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _goToList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListScreen(people: people),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulario")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ingrese sus datos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Nombre obligatorio' : null,
                  onSaved: (value) => name = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Edad',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final n = int.tryParse(value!);
                    return (n == null || n <= 0)
                        ? 'Edad inválida'
                        : null;
                  },
                  onSaved: (value) => age = int.parse(value!),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => RegExp(
                      r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$')
                      .hasMatch(value!)
                      ? null
                      : 'Correo inválido',
                  onSaved: (value) => email = value!,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Guardar'),
                ),
                TextButton(
                  onPressed: _goToList,
                  child: Text('Ver Lista'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
