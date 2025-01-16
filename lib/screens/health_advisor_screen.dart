import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_advisor_provider.dart'; // Import the provider file
import 'package:url_launcher/url_launcher.dart';

class MedicalFormScreen extends StatelessWidget {
  const MedicalFormScreen({super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://github.com/toyosee');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicalFormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _launchUrl,
          )
        ],
        title: const Text('Preventive Medicine'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.assistant_rounded,
                        color: Theme.of(context).primaryColor,
                        ),
                      Text(
                        'Anna Assistant',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      provider.updateAge(int.tryParse(value) ?? 0);
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: provider.gender.isEmpty ? null : provider.gender,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                    ],
                    onChanged: (value) {
                      if (value != null) provider.updateGender(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.transgender,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    hint: const Text('Select Gender'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.favorite,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Systolic',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      provider.updateSystolic(int.tryParse(value) ?? 0);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.favorite,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Diastolic',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      provider.updateDiastolic(int.tryParse(value) ?? 0);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.monitor_weight,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: 'Weight (lbs)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      provider.updateWeight(int.tryParse(value) ?? 0);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.height,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Height (ft)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            provider.updateHeightFeet(int.tryParse(value) ?? 0);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.height,
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Height (in)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            provider.updateHeightInches(int.tryParse(value) ?? 0);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CheckboxListTile(
                    title: const Text('Family History (Colon Cancer)'),
                    value: provider.familyHistory,
                    onChanged: (value) {
                      if (value != null) provider.updateFamilyHistory(value);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text('Crowded Environment'),
                    value: provider.crowdedEnvironment,
                    onChanged: (value) {
                      if (value != null) provider.updateCrowdedEnvironment(value);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 5.0,
                    children: [
                      ChoiceChip(
                        label: const Text('Chronic Illness'),
                        selected: provider.chronicIllnesses.contains('chronic-illness'),
                        onSelected: (isSelected) {
                          if (isSelected) {
                            provider.updateChronicIllnesses(
                                [...provider.chronicIllnesses, 'chronic-illness']);
                          } else {
                            provider.updateChronicIllnesses(provider
                                .chronicIllnesses
                                .where((e) => e != 'chronic-illness')
                                .toList());
                          }
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Sickle Cell'),
                        selected: provider.chronicIllnesses.contains('sickle-cell'),
                        onSelected: (isSelected) {
                          if (isSelected) {
                            provider.updateSickleCell(true);
                          } else {
                            provider.updateSickleCell(false);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Smoke'),
                        selected: provider.smoker,
                        onSelected: (isSelected) {
                          provider.updateSmoker(isSelected);
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Reduced Immunity'),
                        selected: provider.reducedImmunity,
                        onSelected: (isSelected) {
                          provider.updateReducedImmunity(isSelected);
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Special Environment'),
                        selected: provider.specialEnvironment,
                        onSelected: (isSelected) {
                          provider.updateSpecialEnvironment(isSelected);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (provider.findings.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications:',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...provider.findings.map(
                          (notification) => ListTile(
                            leading: Icon(
                              notification.type == 'critical'
                                  ? Icons.warning
                                  : notification.type == 'success'
                                      ? Icons.check_circle
                                      : Icons.info,
                              color: notification.type == 'critical'
                                  ? Colors.red
                                  : notification.type == 'success'
                                      ? Colors.green
                                      : Colors.blue,
                            ),
                            title: Text(
                              notification.message,
                              style: TextStyle(fontSize: constraints.maxWidth * 0.045),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (provider.findings.isEmpty)
                    Center(
                      child: Text(
                        'No findings yet. Fill out the form to see results.',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.045,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      provider.reset();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.25, vertical: 15),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Theme.of(context).primaryColorLight,
                          size: constraints.maxWidth * 0.07,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Reset Form',
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
