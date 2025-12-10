import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
            Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
