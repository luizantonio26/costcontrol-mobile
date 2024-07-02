import 'package:flutter/material.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/otpCodePage.dart';
import 'package:mobile/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hasPasswordError = false;
  String _passwordErrorMessage = "";
  bool _hasEmailError = false;
  String _emailErrorMessage = "";
  String _errorMessage = "";

  Future<void> _login() async {
    setState(() {
      _hasPasswordError = false;
      _passwordErrorMessage = "";
      _hasEmailError = false;
      _emailErrorMessage = "";
      _errorMessage = "";
    });

    if (_emailController.text.isEmpty) {
      _hasEmailError = true;
      _emailErrorMessage = "Please enter the email";
      return;
    }

    if (_passwordController.text.isEmpty) {
      _hasPasswordError = true;
      _passwordErrorMessage = "Please enter the password";
      return;
    }

    if (_hasPasswordError || _hasEmailError) {
      return;
    }

    String message = await _authService.login(
        _emailController.text, _passwordController.text);
    if (message == "success") {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    } else if (message == "2fa activated, you should send the opt code") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => OTPCodePage(
              email: _emailController.text,
              password: _passwordController.text)));
    } else {
      setState(() {
        _errorMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    errorText: _hasEmailError ? _emailErrorMessage : null,
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    )),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _hasPasswordError ? _passwordErrorMessage : null,
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
                obscureText: true,
              ),
              if (_errorMessage
                  .isNotEmpty) // Mostrando a mensagem de erro se houver erro
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
