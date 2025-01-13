import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class TimerProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  List<Map<String, dynamic>> timers = [];
  Timer? globalTimer;

  TimerProvider() {
    _initializeNotifications();
  }

  // Initialize the notification plugin
  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher_foreground'); // Ensure this resource exists
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    final bool? result = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload == 'resume') {
          _resumeWork();
        }
      },
    );
  }

  // Method to start break timer
  void startBreakTimer(int workHours, int breakIntervalMinutes, BuildContext context) {
    if (workHours > 0 && breakIntervalMinutes > 0) {
      final totalDuration = Duration(hours: workHours);
      final breakDuration = Duration(minutes: breakIntervalMinutes);

      timers.add({
        'workDuration': totalDuration,
        'breakDuration': breakDuration,
        'remainingMinutes': totalDuration.inMinutes,
        'nextBreakInMinutes': breakIntervalMinutes,
        'paused': false, // Flag to indicate if the timer is paused
        'timer': Timer.periodic(const Duration(seconds: 60), (timer) {
          final index = timers.indexWhere((t) => t['timer'] == timer);

          if (index != -1) {
            if (timers[index]['paused']) {
              // If the timer is paused, we do nothing
              return;
            }

            timers[index]['remainingMinutes']--;

            // Trigger break notification
            if (timers[index]['remainingMinutes'] % breakIntervalMinutes == 0 &&
                timers[index]['remainingMinutes'] > 0) {
              _showBreakNotification();
              timers[index]['paused'] = true; // Pause timer for the break
              timer.cancel(); // Stop the timer during the break
            }

            // Work session ends
            if (timers[index]['remainingMinutes'] <= 0) {
              timer.cancel();
              _showWorkCompletionNotification();
            }

            notifyListeners();
          }
        }),
      });

      notifyListeners();
    }
  }

  // Resume the timer after a break
  void _resumeWork() {
    if (timers.isNotEmpty) {
      final index = timers.length - 1; // Resume the last active timer
      timers[index]['paused'] = false; // Mark the timer as unpaused

      timers[index]['timer'] = Timer.periodic(const Duration(seconds: 60), (timer) {
        timers[index]['remainingMinutes']--;

        // Check if it's time for the next break
        if (timers[index]['remainingMinutes'] % timers[index]['nextBreakInMinutes'] == 0 &&
            timers[index]['remainingMinutes'] > 0) {
          _showBreakNotification();
          timers[index]['paused'] = true; // Pause timer for the break
          timer.cancel(); // Pause timer during the break
        }

        // Work session ends
        if (timers[index]['remainingMinutes'] <= 0) {
          timer.cancel();
          _showWorkCompletionNotification();
        }

        notifyListeners();
      });
    }
  }

  // Delete the timer
  void deleteTimer(int index) {
    timers[index]['timer'].cancel();
    timers.removeAt(index);
    notifyListeners();
  }

  // Public method for break notifications
  void showBreakNotification() {
    _showBreakNotification();
  }

  // Public method for work completion notifications
  void showWorkCompletionNotification() {
    _showWorkCompletionNotification();
  }

  // Private method for triggering break notifications
  Future<void> _showBreakNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'break_notifications',
      'Break Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_launcher_foreground',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Change ID for multiple notifications
      'Break Time',
      'Take a break! You can resume work when ready.',
      platformChannelSpecifics,
      payload: 'resume',
    );
  }

  // Private method for triggering work completion notifications
  Future<void> _showWorkCompletionNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'work_completion_notifications',
      'Work Completion Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      1, // Change ID for multiple notifications
      'Work Completed',
      'Great job! You\'ve completed your work session.',
      platformChannelSpecifics,
    );
  }
}
