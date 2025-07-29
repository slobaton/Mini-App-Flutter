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
  bool _isLogin = true; // Indica si estamos en modo login o registro
  String _errorMessage = ''; // Para mostrar errores de Firebase

  /// Método que ejecuta el login o el registro según el modo actual
  void _submit() async {
    try {
      if (_isLogin) {
        // LOGIN
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        // Si el login fue exitoso, ir a la pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FormScreen()),
        );
      } else {
        // REGISTRO
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Mostrar AlertDialog en lugar de SnackBar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registro exitoso'),
            content: Text('Usuario registrado. Ahora puedes iniciar sesión.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // cerrar el diálogo
                },
                child: Text('Aceptar'),
              ),
            ],
          ),
        );

        setState(() {
          _isLogin = true; // cambia al modo login después del registro
        });
      }
    } catch (e) {
      // Captura errores y los muestra debajo del botón
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  /// Cambia entre modo login y registro
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
              // Campo de correo con borde tipo caja
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Campo de contraseña con borde tipo caja
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              // Mensaje de error si existe
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              // Botón principal (login o registro)
              ElevatedButton(
                onPressed: _submit,
                child: Text(buttonText),
              ),
              // Botón para alternar entre login y registro
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
