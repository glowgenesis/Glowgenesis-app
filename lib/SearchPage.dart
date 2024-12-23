import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> recentSearches = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecentSearches(); // Load saved recent searches when the page opens
  }

  // Load recent searches from local storage
  void _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  // Save recent searches to local storage
  void _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentSearches', recentSearches);
  }

  // Function to clear all recent searches
  void _clearAllSearches() {
    setState(() {
      recentSearches.clear();
      _saveRecentSearches(); // Update the storage after clearing
    });
  }

  // Function to add a search to recent searches
  void _addSearch(String searchText) {
    if (searchText.isNotEmpty) {
      setState(() {
        if (!recentSearches.contains(searchText)) {
          recentSearches.add(searchText);
        }
        _saveRecentSearches(); // Update the storage with the new search
      });
    }
  }

  // Function to remove a specific search
  void _removeSearch(int index) {
    setState(() {
      recentSearches.removeAt(index);
      _saveRecentSearches(); // Update the storage after removing a search
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.solidBell),
          ),
        ],
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(FontAwesomeIcons.search),
                hintText: 'Search for products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
              ),
              onSubmitted: (value) {
                _addSearch(value); // Add search term to recent searches
                searchController.clear(); // Clear the text field after submission
              },
            ),
            SizedBox(height: screenWidth * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _clearAllSearches(); // Clear all recent searches when pressed
                  },
                  child: Text(
                    'Clear all',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(recentSearches[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _removeSearch(index); // Remove specific search from the list
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
