import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<Map<String, String>> addresses = []; // Stores the list of addresses.

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
        title: const Text('Address'),
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
            const Text(
              'Saved Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            addresses.isEmpty
                ? const Center(child: Text('No addresses available.'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return ListTile(
                          leading: const Icon(Icons.location_pin),
                          title: Text(address['nickname']!),
                          subtitle: Text(address['fullAddress']!),
                          trailing: Radio(
                            value: index,
                            groupValue: null,
                            onChanged: (value) {
                              // Handle default selection logic
                            },
                          ),
                        );
                      },
                    ),
                  ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewAddressPage(
                      onSave: (newAddress) {
                        setState(() {
                          addresses.add(newAddress);
                        });
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewAddressPage extends StatefulWidget {
  final Function(Map<String, String>) onSave;

  const NewAddressPage({super.key, required this.onSave});

  @override
  _NewAddressPageState createState() => _NewAddressPageState();
}

class _NewAddressPageState extends State<NewAddressPage> {
  final TextEditingController _fullAddressController = TextEditingController();
  String? _selectedNickname;
  bool _makeDefault = false;

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
        title: const Text('New Address'),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.location_pin, size: 80, color: Colors.grey),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    const Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Address Nickname',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedNickname,
                      onChanged: (value) {
                        setState(() {
                          _selectedNickname = value;
                        });
                      },
                      items: ['Home', 'Office', 'Others']
                          .map((nickname) => DropdownMenuItem<String>(
                                value: nickname,
                                child: Text(nickname),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _fullAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Full Address',
                        border: OutlineInputBorder(),
                        hintText: 'Enter your full address...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _makeDefault,
                          onChanged: (value) {
                            setState(() {
                              _makeDefault = value!;
                            });
                          },
                        ),
                        const Text('Make this a default address'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedNickname != null &&
                            _fullAddressController.text.isNotEmpty) {
                          widget.onSave({
                            'nickname': _selectedNickname!,
                            'fullAddress': _fullAddressController.text,
                          });
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Address Saved'),
                              content:
                                  const Text('Your address has been saved.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the popup
                                    Navigator.pop(context); // Navigate back
                                  },
                                  child: const Text('Thanks'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          ElegantNotification.error(
                            title: Text('Warning!'),
                            description: Text('Please fill all the fields!'),
                          ).show(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Add'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
