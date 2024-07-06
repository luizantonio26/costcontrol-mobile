import 'package:flutter/material.dart';
import 'package:mobile/pages/login.dart';
import 'package:mobile/services/auth.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  late bool isLogin;
  CustomAppBar({super.key, required this.isLogin});
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  //@override
  // TODO: implement preferredSize

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final AuthService _authService = AuthService();

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Cost Control",
        style: TextStyle(color: Colors.white, fontSize: 26),
      ),
      backgroundColor: Colors.deepPurple[600],
      actions: widget.isLogin
          ? null
          : <Widget>[
              IconButton(
                  onPressed: _logout,
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ))
            ],
    );
  }
}
