import 'package:flutter/foundation.dart';

// Notification Model
class Notification {
  final String message;
  final String type; // e.g., 'critical', 'info', 'success'

  Notification({required this.message, required this.type});
}

// Provider Class
class MedicalFormProvider with ChangeNotifier {
  int _age = 0;
  String _gender = '';
  int _systolic = 0;
  int _diastolic = 0;
  int _weight = 0;
  int _heightFeet = 0;
  int _heightInches = 0;
  bool _familyHistory = false;
  bool _crowdedEnvironment = false;
  List<String> _chronicIllnesses = [];
  bool _sickleCell = false;
  bool _smoker = false;
  bool _reducedImmunity = false;
  bool _specialEnvironment = false;
  List<Notification> _findings = [];

  // Getters
  int get age => _age;
  String get gender => _gender;
  int get systolic => _systolic;
  int get diastolic => _diastolic;
  int get weight => _weight;
  int get heightFeet => _heightFeet;
  int get heightInches => _heightInches;
  bool get familyHistory => _familyHistory;
  bool get crowdedEnvironment => _crowdedEnvironment;
  List<String> get chronicIllnesses => _chronicIllnesses;
  bool get sickleCell => _sickleCell;
  bool get smoker => _smoker;
  bool get reducedImmunity => _reducedImmunity;
  bool get specialEnvironment => _specialEnvironment;
  List<Notification> get findings => _findings;

  // Setters with Logic
  void updateAge(int age) {
    _age = age;
    _updateFindings();
    notifyListeners();
  }

  void updateGender(String gender) {
    _gender = gender;
    _updateFindings();
    notifyListeners();
  }

  void updateSystolic(int systolic) {
    _systolic = systolic;
    _updateFindings();
    notifyListeners();
  }

  void updateDiastolic(int diastolic) {
    _diastolic = diastolic;
    _updateFindings();
    notifyListeners();
  }

  void updateWeight(int weight) {
    _weight = weight;
    _updateFindings();
    notifyListeners();
  }

  void updateHeightFeet(int heightFeet) {
    _heightFeet = heightFeet;
    _updateFindings();
    notifyListeners();
  }

  void updateHeightInches(int heightInches) {
    _heightInches = heightInches;
    _updateFindings();
    notifyListeners();
  }

  void updateFamilyHistory(bool familyHistory) {
    _familyHistory = familyHistory;
    _updateFindings();
    notifyListeners();
  }

   void updateCrowdedEnvironment(bool crowdedEnvironment) {
    _crowdedEnvironment = crowdedEnvironment;
    _updateFindings();
    notifyListeners();
  }

  void updateChronicIllnesses(List<String> chronicIllnesses) {
    _chronicIllnesses = chronicIllnesses;
    _updateFindings();
    notifyListeners();
  }

  void updateSickleCell(bool sickleCell) {
    _sickleCell = sickleCell;
    _updateFindings();
    notifyListeners();
  }

  void updateSmoker(bool smoker) {
    _smoker = smoker;
    _updateFindings();
    notifyListeners();
  }

  void updateReducedImmunity(bool reducedImmunity) {
    _reducedImmunity = reducedImmunity;
    _updateFindings();
    notifyListeners();
  }

  void updateSpecialEnvironment(bool specialEnvironment) {
    _specialEnvironment = specialEnvironment;
    _updateFindings();
    notifyListeners();
  }

  void reset() {
    _age = 0;
    _gender = '';
    _systolic = 0;
    _diastolic = 0;
    _weight = 0;
    _heightFeet = 0;
    _heightInches = 0;
    _familyHistory = false;
    _crowdedEnvironment = false;
    _chronicIllnesses = [];
    _sickleCell = false;
    _smoker = false;
    _reducedImmunity = false;
    _specialEnvironment = false;
    _findings = [];
    notifyListeners();
  }

  // Private Logic to Generate Findings
  void _updateFindings() {
    _findings = [];
    final int totalHeightInInches = (_heightFeet * 12) + _heightInches;

    if (_age >= 50 || (_age < 50 && _familyHistory)) {
      _findings.add(Notification(message: 'Colonoscopy.', type: 'routine'));
    }

    if (_age >= 40 && _gender == 'female') {
      _findings.add(Notification(message: 'Mammogram (Q2 Years)', type: 'routine'));
    }

    if (_age >= 65 && _gender == 'female') {
      _findings.add(Notification(message: 'Bone Density Screening.', type: 'routine'));
    }

    bool recommendVaccine = (_age >= 65 || (_age >= 2 && (_chronicIllnesses.isNotEmpty || _sickleCell || _smoker || _reducedImmunity || _specialEnvironment)));

    if (recommendVaccine) {
      _findings.add(Notification(message: 'Pneumococcal Vaccination.', type: 'routine'));
    }

    if (_age >= 11 && _age <= 16) {
      _findings.add(Notification(message: 'Meningococcal Conjugate Vaccine.', type: 'routine'));
    }

    if (_gender == 'female' && _age >= 21 && _age <= 65) {
      _findings.add(Notification(message: 'Pap Smear Test.', type: 'routine'));
    }

    if (_age >= 15 && _age <= 65) {
      _findings.add(Notification(message: 'HIV Screening.', type: 'routine'));
    }

    if (_gender == 'female' && (_age >= 16 && _age <= 55)) {
      _findings.add(Notification(message: 'HCG.', type: 'routine'));
    }

    if (_systolic > 0 && _diastolic > 0) {
      if (_systolic > 140 || _diastolic > 90) {
        _findings.add(Notification(message: 'Elevated Blood Pressure.', type: 'critical'));
      }
      if (_systolic < 90 || _diastolic < 60) {
        _findings.add(Notification(message: 'Low Blood Pressure.', type: 'critical'));
      }
    }

    if (totalHeightInInches > 0 && _weight > 0) {
      double bmi = (_weight / (totalHeightInInches * totalHeightInInches)) * 703;
      if (bmi >= 30) {
        _findings.add(Notification(message: 'Obese. BMI is ${bmi.toStringAsFixed(1)} kg/m²', type: 'critical'));
      }
    }

    notifyListeners();
  }
}
