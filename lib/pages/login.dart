import 'package:flutter/material.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/otpCodePage.dart';
import 'package:mobile/pages/signin.dart';
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

  void _navigateToRegister() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SigninPage()));
  }

  void _navigateToForgotPassword() {
    // Navegar para a página de esqueci a senha
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cost Control",
          style: TextStyle(color: Colors.white, fontSize: 26),
        ),
        backgroundColor: Colors.deepPurple[600],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Container(
            height: 400,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
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
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.deepPurple[100]),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.deepPurple[400])),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _navigateToRegister,
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.deepPurple[400]),
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToForgotPassword,
                      child: Text(
                        "Esqueceu a senha?",
                        style: TextStyle(color: Colors.deepPurple[400]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
