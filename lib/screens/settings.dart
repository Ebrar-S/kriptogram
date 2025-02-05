import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kriptogram/screens/profile.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Text(
          'Settings',
          style: GoogleFonts.sarpanch(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: .5,
            ),
          ),
        ),
        automaticallyImplyLeading: false,  // Prevent default back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Section
            ListTile(
              leading: const Icon(Icons.person, color: Colors.deepPurple),
              title: Text(
                'Profile',
                style: GoogleFonts.sarpanch(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple[600],
                  ),
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
              leading: const Icon(Icons.palette, color: Colors.deepPurple),
              title: Text(
                'Change Theme',
                style: GoogleFonts.sarpanch(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple[600],
                  ),
                ),
              ),
              onTap: () {
                // Implement Theme Change Logic
              },
            ),
            const Divider(),

            // Notifications Section
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.deepPurple),
              title: Text(
                'Notifications',
                style: GoogleFonts.sarpanch(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple[600],
                  ),
                ),
              ),
              onTap: () {
                // Implement Notification Preferences Logic
              },
            ),
            const Divider(),

            // Privacy Section
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.deepPurple),
              title: Text(
                'Privacy',
                style: GoogleFonts.sarpanch(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple[600],
                  ),
                ),
              ),
              onTap: () {
                // Implement Privacy Settings Logic
              },
            ),
            const Divider(),

            // Log Out Section
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.deepPurple),
              title: Text(
                'Log Out',
                style: GoogleFonts.sarpanch(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple[600],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );              },
            ),
          ],
        ),
      ),
    );
  }
}
