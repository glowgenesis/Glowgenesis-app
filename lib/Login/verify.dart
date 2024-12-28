import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glowgenesis/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // For token storage
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class OtpVerificationPage extends StatefulWidget {
  // final String phoneNumber;
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(
      6, (index) => FocusNode()); // Individual focus nodes for each field

  // API call function for OTP verification
  Future<void> _verifyOtp() async {
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length == 6) {
      try {
        final response = await http.post(
          Uri.parse('${Api.backendApi}/verify-otp'),
          headers: {'Content-Type': 'application/json'},
          // body: jsonEncode({'phoneNumber': widget.email, 'otp': otp}),
          body: jsonEncode({'email': widget.email, 'otp': otp}),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final token = responseData['token'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          await prefs.setString('email', widget.email);

          final snackBar = SnackBar(
            content: AwesomeSnackbarContent(
              title: 'Success!',
              message: 'OTP Verified Successfully',
              contentType: ContentType.success,
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          final snackBar = SnackBar(
            content: AwesomeSnackbarContent(
              title: 'Error!',
              message: 'Invalid or expired OTP',
              contentType: ContentType.failure,
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        final snackBar = SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Error verifying OTP',
            contentType: ContentType.failure,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print("Error verifying OTP: $e");
      }
    } else {
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Warning!',
          message: 'Please enter a valid OTP',
          contentType: ContentType.warning,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _onOtpFieldChange(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        // Move to the next field
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else if (value.isEmpty && index > 0) {
      // Handle backspace: move to the previous field
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    // Automatically trigger OTP verification when all fields are filled
    if (_otpControllers.every((controller) => controller.text.isNotEmpty)) {
      _verifyOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'A one-time password (OTP) has been sent to ${widget.email}.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 40,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    autofocus: index == 0,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _onOtpFieldChange(value, index),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
