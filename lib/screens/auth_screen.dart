import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'form_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String _errorMessage = '';

  void _submit() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_isLogin) {
        // LOGIN
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Ir a la pantalla de formulario con mensaje de bienvenida
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FormScreen(userEmail: email),
          ),
        );
      } else {
        // REGISTRO
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registro exitoso'),
            content: Text('Usuario registrado. Ahora puedes iniciar sesión.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Aceptar'),
              ),
            ],
          ),
        );

        setState(() {
          _isLogin = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _isLogin ? 'Iniciar sesión' : 'Registro';
    final buttonText = _isLogin ? 'Iniciar sesión' : 'Registrarse';
    final toggleText = _isLogin
        ? '¿No tienes cuenta? Regístrate aquí'
        : '¿Ya tienes cuenta? Inicia sesión';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _submit,
                child: Text(buttonText),
              ),
              TextButton(
                onPressed: _toggleForm,
                child: Text(toggleText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
