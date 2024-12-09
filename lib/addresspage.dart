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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Address'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
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
            Text(
              'Saved Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            addresses.isEmpty
                ? Center(child: Text('No addresses available.'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return ListTile(
                          leading: Icon(Icons.location_pin),
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
            Spacer(),
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
              icon: Icon(Icons.add),
              label: Text('Add New Address'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('New Address'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
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
              child: Center(
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
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
                    SizedBox(height: 16),
                    TextField(
                      controller: _fullAddressController,
                      decoration: InputDecoration(
                        labelText: 'Full Address',
                        border: OutlineInputBorder(),
                        hintText: 'Enter your full address...',
                      ),
                    ),
                    SizedBox(height: 16),
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
                        Text('Make this a default address'),
                      ],
                    ),
                    SizedBox(height: 16),
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
                              title: Text('Address Saved'),
                              content: Text('Your address has been saved.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the popup
                                    Navigator.pop(context); // Navigate back
                                  },
                                  child: Text('Thanks'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill all the fields'),
                            ),
                          );
                        }
                      },
                      child: Text('Add'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
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
