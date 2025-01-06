import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_tips_provider.dart'; 
import 'package:url_launcher/url_launcher.dart';

class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://github.com/toyosee');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthTipsProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight;

    // Load health tips when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadHealthTips();
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _launchUrl,
          ),
        ],
        title: const Text('Health Tips'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        width: screenWidth,
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.health_and_safety_rounded,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                  blendMode: BlendMode.multiply,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Tips To Stay Healthy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: provider.healthTips.isEmpty
                  ? Center(
                      child: Text(
                        'No health tips available.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isLandscape ? 3 : 2, // 3 columns in landscape, 2 in portrait
                        childAspectRatio: isLandscape ? 4 / 3 : 3 / 2, // Adjust aspect ratio
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: provider.healthTips.length,
                      itemBuilder: (context, index) {
                        final tip = provider.healthTips[index];
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Health Tip!',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          tip.message,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context).primaryColorDark,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
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
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    tip.type == 'critical'
                                        ? Icons.warning
                                        : tip.type == 'success'
                                            ? Icons.check_circle
                                            : Icons.info,
                                    color: tip.type == 'critical'
                                        ? Colors.red
                                        : tip.type == 'success'
                                            ? Colors.green
                                            : Colors.blue,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    tip.message,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
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
