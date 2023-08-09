import '../../domain/repository/home_repository.dart';
import 'package:flutter/material.dart';
import '../../core/event_tracker/event_tracker.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

import '../../data/data_source/remote_response.dart';
import '../../domain/models/home.dart';
import '../../utils/preferences/preferences_service.dart';

class TempHomeScreen extends StatelessWidget {
  const TempHomeScreen({super.key});

  Future<void> checkInternet() async {
    logger.pink("<-- Start Time"); // 10 seconds
    final RemoteResponse<Home> remoteResponse =
        await homeRepository.getHomeData();
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
                  await eventTracker
                      .log("Simu_cuteness", {"number": "infinite"});
                },
                child: const Text("Test firebase analysis"),
              ),
              TextButton(
                onPressed: () async {
                  await sf.setBool(key: "simu", value: true);
                  final a = sf.getBool(key: "simu", defaultValue: false);
                  logger.error(a);
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
