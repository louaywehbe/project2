import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'show_movie.dart';

const String _baseURL = 'https://louaywehbe.000webhostapp.com';

class AddMovie extends StatefulWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  State<AddMovie> createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  TextEditingController _controllerTitle = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  TextEditingController _controllerURL = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _controllerTitle.dispose();
    _controllerDescription.dispose();
    _controllerURL.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  Future<void> addMovie(String title, String pic, String description) async {
    try {
      final url = Uri.parse('$_baseURL/admin.php');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'title': title,
        'pic': pic,
        'description': description,
      });

      final response = await http.post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        update(response.body);
      } else {
        update('Please try again.');
      }
    } catch (e) {
      update('An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
        centerTitle: true,
        backgroundColor: Colors.brown[100],
      ),
      backgroundColor: Colors.brown[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controllerTitle,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controllerURL,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _controllerDescription,
              decoration: InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () =>
                  addMovie(
                    _controllerTitle.text,
                    _controllerURL.text,
                    _controllerDescription.text,
                  ),
              child: _loading
                  ? CircularProgressIndicator()
                  : const Text('Add'),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown[800],
                textStyle: const TextStyle(color: Colors.white),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoviesPage()),
                  ),
              child: _loading
                  ? CircularProgressIndicator()
                  : const Text('Show user page'),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown[800],
                textStyle: const TextStyle(color: Colors.white),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}