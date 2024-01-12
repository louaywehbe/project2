import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'admin.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key});

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final TextEditingController _controller = TextEditingController();
  final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

  void update(bool success) {
    if (success) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddMovie()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to set key')));
    }
  }

  void checkLogin() async {
    final String enteredKey = _controller.text.toString().trim();
    if (enteredKey == 'admin') {
      _encryptedData.setString('myKey', enteredKey).then((bool success) {
        if (success) {
          update(true);
        } else {
          update(false);
        }
      });
    } else {
      update(false);
    }
  }

  void checkSavedData() async {
    _encryptedData.getString('myKey').then((String myKey) {
      if (myKey.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddMovie()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login Page'),
        backgroundColor: Colors.brown[200],
        centerTitle: true,
      ),
      backgroundColor: Colors.brown[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 200,
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Key',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: checkLogin,
              style: ElevatedButton.styleFrom(
                primary: Colors.brown,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}