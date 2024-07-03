import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/services/auth.dart'; // For formatting dates

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfimController =
      TextEditingController();
  DateTime? _selectedDate;
  AuthService _authService = AuthService();

  bool _hasNameError = false;
  bool _hasEmailError = false;
  bool _hasPasswordError = false;
  bool _hasPasswordConfimError = false;
  bool _hasbirthdateError = false;
  bool _hasErrorMessage = false;
  String _nameErrorMessage = '';
  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';
  String _passwordConfimErrorMessage = '';
  String _birthdateErrorMessage = '';
  String _errorMessage = '';

  void _clearErrors() {
    setState(() {
      _hasNameError = false;
      _hasEmailError = false;
      _hasPasswordError = false;
      _hasPasswordConfimError = false;
      _hasErrorMessage = false;
      _nameErrorMessage = '';
      _emailErrorMessage = '';
      _passwordErrorMessage = '';
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_clearErrors);
    _emailController.addListener(_clearErrors);
    _passwordController.addListener(_clearErrors);
    _passwordConfimController.addListener(_clearErrors);
  }

  void _signIn() async {
    if (_selectedDate != null) {
      // Process the registration with the collected information
      // For example, you can send the data to a server or save it locally
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String passwordConfim = _passwordConfimController.text;
      DateTime birthdate = _selectedDate!;

      Map<String, dynamic> message = await _authService.signin(
          name, email, password, passwordConfim, birthdate);
      if (message["success"]) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      } else if (message["message"] is String) {
        _hasErrorMessage = true;
        _errorMessage = message["message"];
      } else if (message["message"] is List) {
        for (var error in message["message"]) {
          String loc = error["loc"][1];

          if (loc == "name") {
            setState(() {
              _hasNameError = true;
              _nameErrorMessage = error["msg"];
            });
          } else if (loc == "email") {
            setState(() {
              _hasEmailError = true;
              _emailErrorMessage = error["msg"];
            });
          } else if (loc == "password") {
            setState(() {
              _hasPasswordError = true;
              _passwordErrorMessage = error["msg"];
            });
          } else if (loc == "confirm_password") {
            setState(() {
              _hasPasswordConfimError = true;
              _passwordConfimErrorMessage = error["msg"];
            });
          }
        }
      } else if (_selectedDate == null) {
        // If birthdate is not selected, show an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select your birthdate')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    DateTime today = DateTime.now();
    DateTime firstDate = DateTime(today.year - 100);
    DateTime lastDate = DateTime(today.year - 16);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
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
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white, // Cor do botão de voltar
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: ListView(
            padding: EdgeInsets.only(left: 20, right: 20),
            children: [
              Text(
                "Signin",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      // errorText: _hasEmailError ? _emailErrorMessage : null,
                      // errorBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.red),
                      suffixIcon: _hasNameError
                          ? null
                          : IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _nameController.clear();
                                setState(() {
                                  _hasNameError = false;
                                });
                              },
                            ),
                      errorText: _hasNameError ? _errorMessage : null,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ))),
              SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  suffixIcon: _hasEmailError
                      ? null
                      : IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _emailController.clear();
                            setState(() {
                              _hasEmailError = false;
                            });
                          },
                        ),
                  errorText: _hasEmailError ? _emailErrorMessage : null,
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
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
              SizedBox(height: 8),
              TextField(
                controller: _passwordConfimController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  errorText: _hasPasswordError ? _passwordErrorMessage : null,
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
                obscureText: true,
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'Select your birthdate'
                      : 'Birthdate: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signIn,
                child: Text(
                  "Signin",
                  style: TextStyle(color: Colors.deepPurple[100]),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.deepPurple[400])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
