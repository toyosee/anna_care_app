import 'package:flutter/foundation.dart';

// Health Tip Model
class HealthTip {
  final String message;
  final String type; // e.g., 'routine', 'critical', 'info'

  HealthTip({required this.message, required this.type});
}

// Provider Class
class HealthTipsProvider with ChangeNotifier {
  List<HealthTip> _healthTips = [];

  // Predefined list of health tips (simulating data from an API)
  final List<Map<String, String>> _predefinedTips = [
    {
      'message':
          'Stay hydrated. Drink at least 8 cups of water a day. Water is essential for maintaining body temperature, removing waste, and lubricating joints. Aim to drink water regularly throughout the day to stay hydrated and support overall bodily functions.',
      'type': 'routine',
    },
    {
      'message':
          'Exercise regularly to maintain a healthy body weight. Engage in at least 150 minutes of moderate aerobic activity or 75 minutes of vigorous activity each week. Regular exercise helps improve cardiovascular health, strengthens muscles, and boosts mental health.',
      'type': 'routine',
    },
    {
      'message':
          'Get at least 7-8 hours of sleep every night. Quality sleep is crucial for overall health. It helps improve memory, mood, and cognitive function. Create a bedtime routine to ensure you get enough restful sleep and wake up feeling refreshed.',
      'type': 'routine',
    },
    {
      'message':
          'Avoid smoking and limit alcohol consumption. Smoking can lead to lung cancer, heart disease, and other health issues. Limiting alcohol intake reduces the risk of liver disease, cancer, and alcohol dependence. These lifestyle changes greatly improve your overall health.',
      'type': 'critical',
    },
    {
      'message':
          'Eat a balanced diet rich in fruits and vegetables. Incorporate a variety of fruits and vegetables into your meals. They provide essential vitamins, minerals, and fiber, which support overall health and reduce the risk of chronic diseases.',
      'type': 'routine',
    },
    {
      'message':
          'Practice good hand hygiene to prevent infections. Wash your hands with soap and water for at least 20 seconds, especially before eating and after using the restroom. Good hand hygiene reduces the spread of germs and infections, keeping you healthier.',
      'type': 'routine',
    },
    {
      'message':
          'Schedule regular health check-ups with your doctor. Regular health check-ups help detect potential health issues early. Discuss with your doctor about necessary screenings and preventive measures to maintain your health and catch any concerns early.',
      'type': 'routine',
    },
    {
      'message':
          'Manage stress through relaxation techniques. Practice relaxation techniques such as deep breathing, meditation, or yoga. Managing stress helps improve mental well-being and reduces the risk of stress-related illnesses. A calm mind promotes a healthy body.',
      'type': 'critical',
    },
    {
      'message':
          'Maintain a healthy weight for optimal health. Achieve and maintain a healthy weight through a balanced diet and regular physical activity. A healthy weight reduces the risk of chronic diseases like diabetes, heart disease, and improves overall well-being.',
      'type': 'critical',
    },
    {
      'message':
          'Stay socially connected with friends and family. Social connections support mental health and well-being. Spend quality time with loved ones, engage in social activities, and build a strong support network for emotional and psychological health.',
      'type': 'routine',
    },
    {
      'message':
          'Regularly monitor your blood pressure. High blood pressure can lead to heart disease and stroke. Make sure to check your blood pressure regularly and maintain it within a healthy range through diet, exercise, and medication if needed.',
      'type': 'routine',
    },
    {
      'message':
          'Recognize the signs of a stroke. A stroke can be life-threatening. Look for symptoms like sudden numbness, confusion, trouble speaking, or loss of balance. If you notice any of these signs, seek medical attention immediately.',
      'type': 'critical',
    },
    {
      'message':
          'Incorporate strength training into your exercise routine. Strength training helps build muscle mass, improve metabolism, and maintain bone density. Aim to include weight-bearing exercises at least twice a week.',
      'type': 'routine',
    },
    {
      'message':
          'Be aware of the symptoms of diabetes. Common signs include frequent urination, excessive thirst, unexplained weight loss, and fatigue. Early detection and management are key to preventing complications.',
      'type': 'critical',
    },
    {
      'message':
          'Take care of your mental health. Engage in activities that promote relaxation and reduce stress, such as reading, spending time in nature, or practicing mindfulness. Maintaining good mental health is essential for overall well-being.',
      'type': 'routine',
    },
    {
      'message':
          'Understand the risks of high cholesterol. High cholesterol can lead to heart disease and other serious conditions. Monitor your cholesterol levels and maintain a heart-healthy diet low in saturated fats and cholesterol.',
      'type': 'critical',
    },
    {
      'message':
          'Protect your skin from the sun. Use sunscreen with an SPF of at least 30, wear protective clothing, and seek shade during peak sun hours to reduce the risk of skin cancer and premature aging.',
      'type': 'routine',
    },
    {
      'message':
          'Be vigilant about cancer screenings. Regular screenings can detect cancer early when treatment is most effective. Discuss with your doctor which screenings are appropriate for your age and risk factors.',
      'type': 'critical',
    },
  ];

  // Getter
  List<HealthTip> get healthTips => _healthTips;

  // Method to load predefined health tips
  void loadHealthTips() {
    _healthTips = _predefinedTips
        .map((tip) => HealthTip(message: tip['message']!, type: tip['type']!))
        .toList();
    notifyListeners();
  }
}
