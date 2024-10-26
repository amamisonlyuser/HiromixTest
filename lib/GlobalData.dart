import 'package:flutter/foundation.dart';

class GlobalData extends ChangeNotifier {
  String? userName;
  String? phoneNumber;
  Map<String, dynamic>? pollData;
  List<Map<String, String>> selectedOptions = [];
  String? jwtToken;
  String? _firstName;
  String? _lastName;
  String? _institutionShortName;
  String? _institutionName;
  int? _age;
  String? _gender;
  String? _state;
  String? _city;

  // Method to update user name
  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  // Method to get user name
  String? getUserName() {
    return userName;
  }

  // Method to update phone number
  void setPhoneNumber(String phone) {
    phoneNumber = phone;
    notifyListeners();
  }

  // Method to get phone number
  String? getPhoneNumber() {
    return phoneNumber;
  }

  // Method to store poll data
  void setPollData(Map<String, dynamic> data) {
    pollData = data;
    notifyListeners();
  }

  // Method to get poll data
  Map<String, dynamic>? getPollData() {
    return pollData;
  }

  // Method to add selected options
  void addSelectedOption(Map<String, String> option) {
    selectedOptions.add(option);
    notifyListeners();
  }

  // Method to get selected options
  List<Map<String, String>> getSelectedOptions() {
    return selectedOptions;
  }

  // Method to set JWT token
  void setJwtToken(String token) {
    jwtToken = token;
    notifyListeners();
  }

  // Method to get JWT token
  String? getJwtToken() {
    return jwtToken;
  }

  // Reset selected options
  void resetSelectedOptions() {
    selectedOptions = [];
    notifyListeners();
  }

  // Method to set first name
  void setFirstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  // Method to get first name
  String? getFirstName() {
    return _firstName;
  }

  // Method to set last name
  void setLastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  // Method to get last name
  String? getLastName() {
    return _lastName;
  }

  // Method to set institution short name
  void setInstitutionShortName(String institutionShortName) {
    _institutionShortName = institutionShortName;
    notifyListeners();
  }

  // Method to get institution short name
  String? getInstitutionShortName() {
    return _institutionShortName;
  }

  // Method to set institution name
  void setInstitutionName(String institutionName) {
    _institutionName = institutionName;
    notifyListeners();
  }

  // Method to get institution name
  String? getInstitutionName() {
    return _institutionName;
  }

  // Method to set age
  void setAge(int age) {
    _age = age;
    notifyListeners();
  }

  // Method to get age
  int? getAge() {
    return _age;
  }

  // Method to set gender
  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  // Method to get gender
  String? getGender() {
    return _gender;
  }

  // Method to set state
  void setState(String state) {
    _state = state;
    notifyListeners();
  }

  // Method to get state
  String? getState() {
    return _state;
  }

  // Method to set city
  void setCity(String city) {
    _city = city;
    notifyListeners();
  }

  // Method to get city
  String? getCity() {
    return _city;
  }
}
