import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:anna_care/providers/disease_outbreak_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OutbreakTracker extends StatefulWidget {
  const OutbreakTracker({super.key});

  @override
  _OutbreakTrackerState createState() => _OutbreakTrackerState();
}

class _OutbreakTrackerState extends State<OutbreakTracker> {
  final DiseaseOutbreakProvider apiProvider = DiseaseOutbreakProvider();
  Map<String, dynamic>? data;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await apiProvider.fetchData('all');
      if (!mounted) return;
      setState(() {
        data = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Error fetching information. Please check your internet connection.'),
            actions: [
              TextButton(
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
  }

  String formatUpdatedTime(int updatedTime){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(updatedTime);
    String formattedDate = DateFormat('MMMM d, y – h:mm a').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covid-19 Monitor'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchData,
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _launchUrl,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ))
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Global Outbreak Summary',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Data from Disease.sh API',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Last updated: ${formatUpdatedTime(data!['updated'])}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 15),
                    _buildInfoCard(
                      context,
                      icon: Icons.local_hospital,
                      label: 'Cases',
                      value: data!['cases'].toString(),
                      color: Theme.of(context).primaryColor,
                    ),
                    _buildInfoCard(
                      context,
                      icon: Icons.sentiment_very_dissatisfied,
                      label: 'Deaths',
                      value: data!['deaths'].toString(),
                      color: Colors.red,
                    ),
                    _buildInfoCard(
                      context,
                      icon: Icons.health_and_safety,
                      label: 'Recovered',
                      value: data!['recovered'].toString(),
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    _buildDoughnutChart(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Card(
      elevation: 8, // Added shadow for 3D effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 120, // Increased card height
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 50, // Increased icon size
              color: color,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 20,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoughnutChart() {
    final total = data!['cases'] + data!['deaths'] + data!['recovered'];
    return LayoutBuilder(
      builder: (context, constraints) {
        return AspectRatio(
          aspectRatio: constraints.maxWidth > 600
              ? 2
              : 1.5, // Adjust aspect ratio based on device width
          child: Card(
            elevation: 8, // Added shadow for 3D effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 40,
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieChartSections(total),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {},
                          ),
                        ),
                      ),
                    ),
                    if (constraints.maxWidth > 600) const SizedBox(width: 60),
                    Expanded(
                      child: _buildLegend(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildPieChartSections(int total) {
    return [
      PieChartSectionData(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            const Color.fromARGB(255, 0, 43, 79)
          ],
        ),
        // color: Colors.orange,
        value: (data!['cases'] / total) * 100,
        title: '${((data!['cases'] / total) * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context)
              .primaryColorLight, // Changed font color to primary app color
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: (data!['deaths'] / total) * 100,
        title: '${((data!['deaths'] / total) * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColorLight,
          shadows: List.filled(
              2,
              Shadow(
                  blurRadius: 2,
                  color:
                      Colors.black)), // Changed font color to primary app color
        ),
      ),
      PieChartSectionData(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 3, 69, 5),
            const Color.fromARGB(255, 3, 135, 8)
          ],
        ),
        // color: Colors.green,
        value: (data!['recovered'] / total) * 100,
        title: '${((data!['recovered'] / total) * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context)
              .primaryColorLight, // Changed font color to primary app color
        ),
      ),
    ];
  }

  Widget _buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(color: Theme.of(context).primaryColor, text: 'Cases'),
        _buildLegendItem(color: Colors.red, text: 'Deaths'),
        _buildLegendItem(
            color: const Color.fromARGB(255, 3, 69, 5), text: 'Recovered'),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context)
                  .primaryColor, // Changed font color to primary app color
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://github.com/toyosee');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
