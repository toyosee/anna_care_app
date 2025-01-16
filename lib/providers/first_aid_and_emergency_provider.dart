import 'package:flutter/foundation.dart';

// First Aid Tip Model
class FirstAidTip {
  final String message;
  final String category; // e.g., 'first_aid', 'emergency_contact', 'guidance'

  FirstAidTip({required this.message, required this.category});
}

// Provider Class
class FirstAidTipsProvider with ChangeNotifier {
  List<FirstAidTip> _firstAidTips = [];

  // Predefined list of first aid tips and emergency guidance (simulating data from an API)
  final List<Map<String, String>> _predefinedTips = [
    {
      'message':
          'For minor cuts and scrapes, clean the wound with water and apply an antibiotic ointment. Cover with a clean bandage to prevent infection.',
      'category': 'first_aid',
    },
    {
      'message':
          'For burns, run cool (not cold) water over the burn area for at least 10 minutes. Do not apply ice or butter. Cover with a sterile, non-stick dressing.',
      'category': 'first_aid',
    },
    {
      'message':
          'In case of choking, perform the Heimlich maneuver. Stand behind the person and give quick, upward thrusts just above the navel.',
      'category': 'first_aid',
    },
    {
      'message':
          'Emergency Contact: Dial 911 (or your local emergency number) immediately if someone is unconscious, not breathing, or has severe bleeding.',
      'category': 'emergency_contact',
    },
    {
      'message':
          'For suspected heart attacks, call emergency services and have the person chew an aspirin while waiting for medical help. Keep the person calm and seated.',
      'category': 'guidance',
    },
    {
      'message':
          'In case of a stroke, remember the FAST acronym: Face drooping, Arm weakness, Speech difficulty, Time to call emergency services immediately.',
      'category': 'guidance',
    },
    {
      'message':
          'For allergic reactions, use an epinephrine auto-injector if available and call emergency services. Keep the person calm and monitor their breathing.',
      'category': 'first_aid',
    },
    {
      'message':
          'Emergency Contact: Keep a list of emergency contacts, including local emergency numbers, family members, and close friends, easily accessible.',
      'category': 'emergency_contact',
    },
    {
      'message':
          'For seizures, do not restrain the person or put anything in their mouth. Protect them from injury and call emergency services if the seizure lasts more than 5 minutes.',
      'category': 'guidance',
    },
    {
      'message':
          'In case of nosebleeds, lean forward slightly and pinch the soft part of the nose. Keep pinching for 10 minutes and breathe through your mouth.',
      'category': 'first_aid',
    },
    {
      'message':
          'For sprains, follow the RICE method: Rest, Ice, Compression, and Elevation. Apply ice for 20 minutes every hour, compress with an elastic bandage, and elevate the injured area.',
      'category': 'first_aid',
    },
    {
      'message':
          'If you suspect a fracture, immobilize the affected area and use a splint if available. Avoid moving the person unnecessarily and seek medical attention.',
      'category': 'first_aid',
    },
    {
      'message':
          'For eye injuries, rinse the eye with clean water or saline solution. Avoid rubbing the eye and seek medical attention if there is persistent pain or vision problems.',
      'category': 'first_aid',
    },
    {
      'message':
          'In case of poisoning, do not induce vomiting unless advised by a medical professional. Call your local poison control center or emergency services immediately.',
      'category': 'first_aid',
    },
    {
      'message':
          'For hypothermia, move the person to a warm place and remove any wet clothing. Warm the body gradually with blankets and warm (not hot) beverages. Avoid direct heat sources.',
      'category': 'first_aid',
    },
    {
      'message':
          'For heat exhaustion, move the person to a cool place, loosen tight clothing, and provide cool water to drink. Use cool, damp cloths to lower body temperature.',
      'category': 'first_aid',
    },
    {
      'message':
          'For insect stings, remove the stinger by scraping it with a straight-edged object. Clean the area with soap and water, and apply a cool compress to reduce swelling.',
      'category': 'first_aid',
    },
    {
      'message':
          'In case of snake bites, keep the affected limb immobilized and at or slightly below the level of the heart. Do not attempt to suck out the venom. Seek medical attention immediately.',
      'category': 'first_aid',
    },
    {
      'message':
          'For asthma attacks, help the person use their inhaler. If symptoms persist, seek emergency medical help.',
      'category': 'first_aid',
    },
    {
      'message':
          'For diabetic emergencies, if the person is conscious and able to swallow, give them something sweet to eat or drink. If they are unconscious, seek emergency medical help immediately.',
      'category': 'first_aid',
    },
    {
      'message':
          'Emergency Contact: Program emergency numbers into your phone and teach children how to call for help. Include local emergency services, family members, and close friends.',
      'category': 'emergency_contact',
    },
    {
      'message':
          'For electric shocks, do not touch the person if they are still in contact with the electrical source. Turn off the power if possible and call emergency services.',
      'category': 'first_aid',
    },
    {
      'message':
          'In case of drowning, remove the person from the water if it is safe to do so. Perform CPR if the person is not breathing and seek emergency medical help.',
      'category': 'guidance',
    },
  ];

  // Getter
  List<FirstAidTip> get firstAidTips => _firstAidTips;

  // Method to load predefined first aid tips
  void loadFirstAidTips() {
    _firstAidTips = _predefinedTips
        .map((tip) =>
            FirstAidTip(message: tip['message']!, category: tip['category']!))
        .toList();
    notifyListeners();
  }
}
