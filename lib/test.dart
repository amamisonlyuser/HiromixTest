import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalData = Provider.of<GlobalData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Global Data Example'),
      ),
      body: Column(
        children: [
          Text('User Name: ${globalData.userName ?? 'No Name Set'}'),
          Text('Phone Number: ${globalData.phoneNumber ?? 'No Phone Set'}'),
          ElevatedButton(
            onPressed: () {
              globalData.setUserName('John Doe'); // Update user name globally
              globalData.setPhoneNumber('1234567890'); // Update phone number
            },
            child: Text('Set Global Values'),
          ),
        ],
      ),
    );
  }
}
You can also modify or read global variables anywhere in your app:

dart
Copy code



ElevatedButton(
  onPressed = () {
    Provider.of<GlobalData>(context, listen: false).setUserName('Jane Doe');
  },
  child = Text('Change User Name Globally'),
),


Advantages:
Easy access: You can easily access global data anywhere in your app using Provider.
Efficiency: The ChangeNotifier ensures efficient updates, and widgets only rebuild when necessary.
Scalability: You can add more global variables and methods to the GlobalData class as needed.
Conclusion:
Using Provider with a GlobalData singleton makes global state management simple and clean in Flutter apps, offering a well-structured way to manage and access global variables across pages.






void setFirstName(String firstName) {
    _firstName = firstName;
    notifyListeners(); // Notify listeners about the change
  }

  void setLastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  void setInstitutionShortName(String institutionShortName) {
    _institutionShortName = institutionShortName;
    notifyListeners();
  }

  void setInstitutionName(String institutionName) {
    _institutionName = institutionName;
    notifyListeners();
  }

  void setAge(int age) {
    _age = age;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setState(String state) {
    _state = state;
    notifyListeners();
  }

  void setCity(String city) {
    _city = city;
    notifyListeners();
  }