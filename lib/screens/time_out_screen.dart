import 'package:anna_care/providers/timeout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class TimeOutWidget extends StatefulWidget {
  const TimeOutWidget({super.key});

  @override
  State<TimeOutWidget> createState() => _TimeOutWidgetState();
}

class _TimeOutWidgetState extends State<TimeOutWidget> {
  final Uri _url = Uri.parse('https://github.com/toyosee');
  final workHourController = TextEditingController();
  final breakIntervalController = TextEditingController();

  // Launch URL for additional information
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  // Show error dialog for invalid input
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Heads Up!'),
          content: Text(message),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).primaryColorLight,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete this break timer?'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).primaryColorLight,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog if 'No' is pressed
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).primaryColorLight,
              ),
              onPressed: () {
                final timerProvider = Provider.of<TimerProvider>(context, listen: false);
                timerProvider.deleteTimer(index); // Delete the timer
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _launchUrl,
          ),
        ],
        title: const Text('Time Out'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Set working hours input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Set your working hours',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              TextField(
                controller: workHourController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.work, color: Theme.of(context).primaryColor),
                  labelText: 'Working Hours',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Set break interval input
              TextField(
                controller: breakIntervalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.timer, color: Theme.of(context).primaryColor),
                  labelText: 'Break Interval (minutes)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Set break timer button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).primaryColorLight,
                ),
                onPressed: () {
                  final workHours = int.tryParse(workHourController.text);
                  final breakIntervalMinutes = int.tryParse(breakIntervalController.text);

                  if (workHours == null || workHours <= 0 || breakIntervalMinutes == null || breakIntervalMinutes <= 0) {
                    _showErrorDialog('Please enter valid work hours and break interval.');
                  } else {
                    timerProvider.startBreakTimer(workHours, breakIntervalMinutes, context);
                    workHourController.clear();
                    breakIntervalController.clear();
                  }
                },
                child: Text(
                  'Set Break',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Timer list
              ListView.builder(
                shrinkWrap: true,
                itemCount: timerProvider.timers.length,
                itemBuilder: (context, index) {
                  final timer = timerProvider.timers[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          'Work: ${timer['workDuration'].inHours}h, \nBreak: ${timer['breakDuration'].inMinutes}min'),
                      subtitle: Text('Remaining: ${timer['remainingMinutes']} minutes'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmationDialog(index), // Show delete confirmation dialog
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
