import 'dart:async';
import 'package:anna_care/providers/health_tips_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double _opacity = 1.0;
  late Timer _timer;
  HealthTip? _currentHealthTip;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HealthTipsProvider>(context, listen: false);
    provider.loadHealthTips();
    _currentHealthTip = provider.healthTips.first;
    _startBlinking();
  }

  void _startBlinking() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          final provider = Provider.of<HealthTipsProvider>(context, listen: false);
          _currentHealthTip = (provider.healthTips.toList()..shuffle()).first;
          _opacity = 0.0;
        });

        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _opacity = 1.0;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://github.com/toyosee');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showHealthTipDialog(String tip) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.health_and_safety,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 10),
              Text(
                tip,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<HealthTipsProvider>(context);
    final healthTipOfTheDay = _currentHealthTip;

    final tools = [
      {'icon': Icons.calculate, 'label': 'BMI Calculator', 'route': '/bmi'},
      {'icon': Icons.medical_services_rounded, 'label': 'Check Up', 'route': '/healthAdvisor'},
      {'icon': Icons.local_hospital, 'label': 'Health Tips', 'route': '/healthTips'},
      {'icon': Icons.crisis_alert_rounded, 'label': 'Covid-19 \nMonitor', 'route': '/outbreakTracker'},
      {'icon': Icons.fitness_center, 'label': 'Fitness Tracker', 'route': '/fitness', 'comingSoon': true},
      {'icon': Icons.schedule, 'label': 'Workout Scheduler', 'route': '/workoutScheduler', 'comingSoon': true},
      {'icon': Icons.food_bank, 'label': 'Meal Planner', 'route': '/mealPlanner', 'comingSoon': true},
      {'icon': Icons.bar_chart, 'label': 'Progress Tracker', 'route': '/progressTracker', 'comingSoon': true},
    ];

    final screenWidth = MediaQuery.of(context).size.width;

    // Determine crossAxisCount dynamically
    final crossAxisCount = screenWidth > 600 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _launchUrl,
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.dashboard),
          onPressed: () {},
        ),
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.health_and_safety_rounded,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 10),
                Text(
                  'Pick a tool to get started',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showHealthTipDialog(healthTipOfTheDay?.message ?? ''),
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 1),
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Health Tip of the Day',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          healthTipOfTheDay?.message ?? '',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1, // Maintain square-like cards
                ),
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  final tool = tools[index];
                  final isComingSoon = tool['comingSoon'] == true;

                  return GestureDetector(
                    onTap: isComingSoon
                        ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  icon: Icon(
                                    Icons.info,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  title: const Text('Coming Soon'),
                                  content: Text(
                                    'This feature is coming soon. Stay tuned!',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                      ),
                                      child: Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColorLight,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        : () {
                            Navigator.pushNamed(context, tool['route'] as String);
                          },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tool['icon'] as IconData,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            tool['label'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isComingSoon ? Colors.grey : Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
