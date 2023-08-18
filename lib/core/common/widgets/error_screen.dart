import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String? message;
  const ErrorScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _errorScreenBody(),
    );
  }

  SingleChildScrollView _errorScreenBody() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 500,
                child: Image.network(
                    "https://img.freepik.com/premium-vector/funny-404-error-page-template-with-fallen-ice-cream_556049-83.jpg"),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  message ?? "Error Ocurred",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
