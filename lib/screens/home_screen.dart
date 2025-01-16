import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final Uri _url = Uri.parse('https://github.com/toyosee');
  String selectedUnit = 'Metric (kg/cm)';

  void calculateBMI() {
    try {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text);

      if (selectedUnit == 'Imperial (lbs/inches)') {
        weight *= 0.453592; // Convert lbs to kg
        height *= 2.54; // Convert inches to cm
      }

      height /= 100; // Convert height to meters

      if (weight <= 0 || height <= 0) {
        throw Exception("Invalid Input");
      }

      final double bmi = weight / (height * height);
      String result;
      Color backgroundColor;
      IconData resultIcon;

      if (bmi < 18.5) {
        result = "Your BMI is ${bmi.toStringAsFixed(1)}\nYou are Underweight";
        backgroundColor = Colors.lightBlue.shade100;
        resultIcon = Icons.sentiment_dissatisfied;
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        result =
            "Your BMI is ${bmi.toStringAsFixed(1)}\nGreat Job staying fit.";
        backgroundColor = Colors.green.shade100;
        resultIcon = Icons.sentiment_satisfied_rounded;
      } else if (bmi >= 25 && bmi <= 29.9) {
        result =
            "Your BMI is ${bmi.toStringAsFixed(1)}\nYou are Overweight. Time to hit the Gym.";
        backgroundColor = Colors.orange.shade100;
        resultIcon = Icons.sentiment_neutral;
      } else {
        result =
            "Your BMI is ${bmi.toStringAsFixed(1)}\nYou are Obese. Time to shed some weight.";
        backgroundColor = Colors.red.shade100;
        resultIcon = Icons.sentiment_very_dissatisfied;
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              width: double.infinity,
              // height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(resultIcon, size: 50),
                  const SizedBox(height: 20),
                  Text(
                    result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Empty Fields"),
          content: const Text("Invalid input. Please enter valid values."),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).primaryColor)),
              child: Text(
                "Close",
                 style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                  ),
                ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final isLandscape = size.width > size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _launchUrl,
          )
        ],
        title: const Text('BMI Calculator'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Check Your BMI',
                    style: TextStyle(
                      fontSize: constraints.maxWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: selectedUnit,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUnit = newValue!;
                      });
                    },
                    items: <String>['Metric (kg/cm)', 'Imperial (lbs/inches)']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.line_weight_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: selectedUnit == 'Metric (kg/cm)'
                          ? 'Weight (kg)'
                          : 'Weight (lbs)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.height_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: selectedUnit == 'Metric (kg/cm)'
                          ? 'Height (cm)'
                          : 'Height (inches)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: calculateBMI,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.2,
                        vertical: 15,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calculate,
                          color: Theme.of(context).primaryColorLight,
                          size: constraints.maxWidth * 0.07,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Calculate',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: constraints.maxWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
