import 'package:flutter/material.dart';

class MyDetailsPage extends StatefulWidget {
  const MyDetailsPage({super.key});

  @override
  _MyDetailsPageState createState() => _MyDetailsPageState();
}

class _MyDetailsPageState extends State<MyDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('My Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('Full Name', 'Enter your full name', _nameController),
            const SizedBox(height: 16),
            buildTextField(
                'Email Address', 'Enter your email address', _emailController),
            const SizedBox(height: 16),
            buildTextField(
              'Date of Birth',
              'Select your date of birth',
              _dobController,
              isReadOnly: true,
              suffixIcon: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  _dobController.text =
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              value: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            buildTextField(
              'Phone Number',
              'Enter your phone number',
              _phoneController,
              prefixIcon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '🇮🇳',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  print('Full Name: ${_nameController.text}');
                  print('Email Address: ${_emailController.text}');
                  print('Date of Birth: ${_dobController.text}');
                  print('Gender: $_selectedGender');
                  print('Phone Number: ${_phoneController.text}');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        currentIndex: 4,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget buildTextField(String label, String hint, TextEditingController controller,
      {bool isReadOnly = false,
      Widget? prefixIcon,
      Widget? suffixIcon,
      Function()? onTap}) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
