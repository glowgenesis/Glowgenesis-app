import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glowgenesis/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddDeliveryAddressPage extends StatefulWidget {
  @override
  _AddDeliveryAddressPageState createState() => _AddDeliveryAddressPageState();
}

class _AddDeliveryAddressPageState extends State<AddDeliveryAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController houseNoController = TextEditingController();
  final TextEditingController roadNameController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  String addressType = "Home";

  Future<void> fetchCurrentLocation() async {
    try {
      // Check if location services are enabled
      if (!await Geolocator.isLocationServiceEnabled()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Location services are disabled. Please enable them.'),
          ),
        );
        return;
      }

      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }

      // Fetch the current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocoding using Google Maps API
      const String apiKey = "AIzaSyCksUPpIhrhPMYBLD2gjnMj9U63O-K1Je4";
      final String url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == "OK" && data['results'].isNotEmpty) {
          final components = data['results'][0]['address_components'];

          String? city;
          String? state;
          String? pincode;
          String? fullAddress;

          // Extract relevant address components
          for (var component in components) {
            if (component['types'].contains('administrative_area_level_1')) {
              state = component['long_name'];
            } else if (component['types'].contains('locality')) {
              city = component['long_name'];
            } else if (component['types'].contains('postal_code')) {
              pincode = component['long_name'];
            }
          }

          // Set address details in the controllers
          if (city != null && state != null && pincode != null) {
            setState(() {
              pincodeController.text = pincode!;
              cityController.text = city!;
              stateController.text = state!;
            });
          } else {
            throw Exception("Address components not found.");
          }

          // Set full address (optional)
          fullAddress = data['results'][0]['formatted_address'];
          if (fullAddress != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Address: $fullAddress')),
            );
          }
        } else {
          throw Exception("No results found for the current location.");
        }
      } else {
        throw Exception(
            "Failed to fetch address. HTTP Status: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  Future<void> fetchCityStateFromPincode(String pincode) async {
    const String apiKey = "AIzaSyCksUPpIhrhPMYBLD2gjnMj9U63O-K1Je4";
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$pincode&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == "OK" && data['results'].isNotEmpty) {
          final components = data['results'][0]['address_components'];

          String? city;
          String? state;

          // Extract city and state from address components
          for (var component in components) {
            if (component['types'].contains('administrative_area_level_1')) {
              state = component['long_name'];
            } else if (component['types'].contains('locality')) {
              city = component['long_name'];
            }
          }

          if (city != null && state != null) {
            setState(() {
              cityController.text = city!;
              stateController.text = state!;
            });
          } else {
            throw Exception("City or state not found for the given pincode.");
          }
        } else {
          throw Exception("Invalid pincode or no results found.");
        }
      } else {
        throw Exception(
            "Failed to fetch data. HTTP Status: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching city/state: $e')),
      );
    }
  }

  void saveAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
          '${Api.backendApi}/user/update'); // Replace with your live URL if deployed

      final addressData = {
        "email":
            email, // Use the email stored in preferences (optional if you want to send it)
        "address": {
          "fullName": fullNameController.text,
          "pincode": pincodeController.text,
          "phoneNumber": phoneNumberController.text,
          "state": stateController.text,
          "city": cityController.text,
          "houseNo": houseNoController.text,
          "roadName": roadNameController.text,
          "landmark": landmarkController.text,
          "addressType":
              addressType, // Ensure you have this variable defined elsewhere
          "roadDetails": roadNameController.text, // Adding roadDetails
          "houseDetails": houseNoController.text, // Adding houseDetails
        },
      };

      try {
        final response = await http.put(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(addressData),
        );

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);

          if (responseBody['success']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseBody['message'])),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseBody['message'])),
            );
          }
        } else {
          throw Exception(
              "Failed to save address. HTTP Status: ${response.statusCode}");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Delivery Address',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: pincodeController,
                      decoration: const InputDecoration(
                        labelText: 'Pincode',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 6) {
                          fetchCityStateFromPincode(value);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the pincode';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: fetchCurrentLocation,
                    icon: const Icon(Icons.location_searching),
                    tooltip: "Use current location",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the state';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: houseNoController,
                decoration: const InputDecoration(
                  labelText: 'House No., Building Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter house/building details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: roadNameController,
                decoration: const InputDecoration(
                  labelText: 'Road Name, Area, Colony',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the road/area details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: landmarkController,
                decoration: const InputDecoration(
                  labelText: 'Landmark (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveAddress,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 198, 236, 232),
                ),
                child: const Text('Add Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
