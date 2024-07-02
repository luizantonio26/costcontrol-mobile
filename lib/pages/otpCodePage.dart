import 'package:flutter/material.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/services/auth.dart';

// Suponho que você tenha um AuthService que lida com a lógica de autenticação
AuthService _authService = AuthService();

class OTPCodePage extends StatefulWidget {
  final String email;
  final String password;

  const OTPCodePage({required this.email, required this.password});

  @override
  State<OTPCodePage> createState() => _OTPCodePageState();
}

class _OTPCodePageState extends State<OTPCodePage> {
  final AuthService _authService = AuthService();
  final TextEditingController _otpController = TextEditingController();
  bool _hasError = false;
  String _errorMessage = "";

  Future<void> _verifyOTP() async {
    setState(() {
      _hasError = false;
      _errorMessage = "";
    });

    if (_otpController.text.isEmpty) {
      // Adicione uma verificação básica para o campo OTP não estar vazio
      setState(() {
        _hasError = true;
        _errorMessage = "Please enter OTP";
      });
      print("Please enter OTP");
      return;
    }

    String message = await _authService.login(
        widget.email, widget.password, _otpController.text);
    if (message == "success") {
      // Corrigido de "sucess" para "success"
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      setState(() {
        _hasError = true;
        _errorMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Code")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                    labelText: "OTP",
                    errorText: _hasError ? _errorMessage : null,
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red))),
              ),
              if (_errorMessage
                  .isNotEmpty) // Mostrando a mensagem de erro se houver erro
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: Text("Verify Code"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
