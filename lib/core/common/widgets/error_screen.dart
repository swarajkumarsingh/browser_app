import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/strings.dart';

class ErrorScreen extends ConsumerStatefulWidget {
  final String? message;
  const ErrorScreen({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  ConsumerState<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends ConsumerState<ErrorScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _errorScreenBody(ref, context),
    );
  }

  SingleChildScrollView _errorScreenBody(WidgetRef ref, BuildContext context) {
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
                  widget.message ?? Strings.errorOccurred,
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
