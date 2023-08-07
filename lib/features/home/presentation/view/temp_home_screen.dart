import 'package:flutter/material.dart';
import '../../domain/models/home.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

import '../../../../dio/remote_response.dart';
import '../../../../event_tracker/event_tracker.dart';
import '../../application/services/home_service.dart';

class TempHomeScreen extends StatelessWidget {
  const TempHomeScreen({super.key});

  Future<void> checkInternet() async {
    logger.pink("<-- Start Time"); // 10 seconds
    final RemoteResponse<Home> remoteResponse = await homeService.getData();
    logger.success("<-- END Time ${remoteResponse.message} -->");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("HOME 1"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await checkInternet();
                },
                icon: const Icon(
                  Icons.ads_click_rounded,
                  color: Colors.black,
                ),
                label: const Text("PUSH"),
              ),
              TextButton(
                onPressed: () => throw Exception("SIMU BABU 2 👶🐥🍼"),
                child: const Text("Throw Test Exception"),
              ),
              TextButton(
                onPressed: () async {
                 await eventTracker.log("Simu_cuteness", {"number": "infinite"});
                },
                child: const Text("Test firebase analysis"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
