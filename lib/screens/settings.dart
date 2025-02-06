import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kriptogram/screens/profile.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Matching the gradient background
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800, // Matching the app bar color
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView(
            children: [
              // Profile Section
              ListTile(
                leading: Icon(Icons.person, color: Colors.blue.shade800),
                title: Text(
                  'Profile',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              const Divider(),

              // Change Theme Section
              ListTile(
                leading: Icon(Icons.palette, color: Colors.blue.shade800),
                title: Text(
                  'Change Theme',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                onTap: () {
                  // Implement Theme Change Logic
                },
              ),
              const Divider(),

              // Notifications Section
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.blue.shade800),
                title: Text(
                  'Notifications',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                onTap: () {
                  // Implement Notification Preferences Logic
                },
              ),
              const Divider(),

              // Privacy Section
              ListTile(
                leading: Icon(Icons.lock, color: Colors.blue.shade800),
                title: Text(
                  'Privacy',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                onTap: () {
                  // Implement Privacy Settings Logic
                },
              ),
              const Divider(),

              // Log Out Section
              ListTile(
                leading: Icon(Icons.logout, color: Colors.blue.shade800),
                title: Text(
                  'Log Out',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}