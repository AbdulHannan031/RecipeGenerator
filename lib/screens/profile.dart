import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screens/signin.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController updateController = TextEditingController();
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Profile'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SigninPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Profile icon with border
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile_icon.png'),
                backgroundColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.deepOrange,
                      width: 4,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Email
              Text(
                user?.email ?? 'No Email',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              SizedBox(height: 30),

              // Row with text field and button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Change password field
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: updateController,
                        decoration: InputDecoration(
                          labelText: 'Change Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              Icon(Icons.lock, color: Colors.deepOrange),
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  // Update password button
                  ElevatedButton(
                    onPressed: () async {
                      if (updateController.text.isNotEmpty) {
                        try {
                          await user?.updatePassword(updateController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Password updated successfully.')),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'requires-recent-login') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please re-authenticate to update your password.')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.message}')),
                            );
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please fill in the password field first.')),
                        );
                      }
                    },
                    child: Text('Update'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange, // Button color
                      foregroundColor: Colors.white, // Text color
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
