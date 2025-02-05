import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample data for the profile
  String _name = "John Doe";
  String _email = "johndoe@example.com";
  String _bio = "A passionate Flutter developer.";
  String _phoneNumber = "123-456-7890";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isEditing = false;

  // This function is to toggle between view and edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;

      if (!_isEditing) {
        // Save data when exiting edit mode
        _name = _nameController.text;
        _email = _emailController.text;
        _bio = _bioController.text;
        _phoneNumber = _phoneController.text;
      } else {
        // Populate the controllers with current data for editing
        _nameController.text = _name;
        _emailController.text = _email;
        _bioController.text = _bio;
        _phoneController.text = _phoneNumber;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Text(
          'Profile',
          style: GoogleFonts.sarpanch(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: .5,
            ),
          ),
        ),
        automaticallyImplyLeading: false,  // Prevent default back button
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: Colors.white70,
            ),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: CircleAvatar(
                radius: 60,
                //backgroundImage: AssetImage('assets/profile_picture.jpg'),
              ),
            ),
            SizedBox(height: 30),

            // Name Field
            _buildTextField(
              label: "Name",
              controller: _nameController,
              enabled: _isEditing,
              initialValue: _name,
            ),

            // Email Field
            _buildTextField(
              label: "Email",
              controller: _emailController,
              enabled: _isEditing,
              initialValue: _email,
            ),

            // Bio Field
            _buildTextField(
              label: "Bio",
              controller: _bioController,
              enabled: _isEditing,
              initialValue: _bio,
            ),

            // Phone Number Field
            _buildTextField(
              label: "Phone Number",
              controller: _phoneController,
              enabled: _isEditing,
              initialValue: _phoneNumber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required String initialValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: initialValue,
          border: OutlineInputBorder(),
          suffixIcon: enabled
              ? IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  initialValue = controller.text;
                });
              }
            },
          )
              : null,
        ),
      ),
    );
  }
}
