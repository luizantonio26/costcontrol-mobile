import 'package:flutter/material.dart';
import 'package:mobile/pages/ingredients.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/pages/profile.dart';
import 'package:mobile/pages/recipes.dart';
import 'package:mobile/services/auth.dart';
import 'package:mobile/widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // Substitua HomePage por HomeScreen ou outra página inicial
    Recipes(),
    Ingredients(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final AuthService _authService = AuthService();

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isLogin: false),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple[600],
        elevation: 0,
        onTap: _onItemTapped,
        currentIndex: _currentIndex, // Adicione o currentIndex aqui
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.deepPurple[300],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.breakfast_dining, color: Colors.white),
            label: "Recipes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wheelchair_pickup, color: Colors.white),
            label: "Ingredients",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: "Profile",
          ),
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}
