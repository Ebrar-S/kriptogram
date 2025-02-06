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

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current profile data
    _nameController = TextEditingController(text: _name);
    _emailController = TextEditingController(text: _email);
    _bioController = TextEditingController(text: _bio);
    _phoneController = TextEditingController(text: _phoneNumber);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
      }
    });
  }

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
          'Profile',
          style: GoogleFonts.nunito(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue.shade800,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
            
                  // Name Field
                  _buildTextField(
                    label: "Name",
                    controller: _nameController,
                    enabled: _isEditing,
                  ),
            
                  // Email Field
                  _buildTextField(
                    label: "Email",
                    controller: _emailController,
                    enabled: _isEditing,
                  ),
            
                  // Bio Field
                  _buildTextField(
                    label: "Bio",
                    controller: _bioController,
                    enabled: _isEditing,
                  ),
            
                  // Phone Number Field
                  _buildTextField(
                    label: "Phone Number",
                    controller: _phoneController,
                    enabled: _isEditing,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.nunito(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade800),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade800),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
          ),
          suffixIcon: enabled
              ? IconButton(
            icon: Icon(Icons.check, color: Colors.blue.shade800),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  // Update the corresponding profile field
                  switch (label) {
                    case "Name":
                      _name = controller.text;
                      break;
                    case "Email":
                      _email = controller.text;
                      break;
                    case "Bio":
                      _bio = controller.text;
                      break;
                    case "Phone Number":
                      _phoneNumber = controller.text;
                      break;
                  }
                });
              }
            },
          )
              : null,
        ),
        style: GoogleFonts.nunito(
          color: Colors.blue.shade800,
          fontSize: 16,
        ),
      ),
    );
  }
}