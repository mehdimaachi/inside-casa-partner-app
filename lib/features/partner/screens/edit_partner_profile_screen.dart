import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class EditPartnerProfileScreen extends StatefulWidget {
  static const routeName = '/edit-partner-profile';
  final PartnerUser user;
  final String token;

  const EditPartnerProfileScreen({
    Key? key,
    required this.user,
    required this.token,
  }) : super(key: key);

  @override
  _EditPartnerProfileScreenState createState() => _EditPartnerProfileScreenState();
}

class _EditPartnerProfileScreenState extends State<EditPartnerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _businessNameController;
  late TextEditingController _contactNameController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController(text: widget.user.description);
    _contactNameController = TextEditingController(text: widget.user.fullname);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _contactNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() { _isLoading = true; });

    try {
      final apiService = ApiService();
      // NOTE: For now, this will fail because the login is blocked,
      // but the logic is ready for when it's unblocked.
      final updatedUser = await apiService.updateUserProfile(
        token: widget.token,
        fullname: _contactNameController.text,
        phone: _phoneController.text,
        description: _businessNameController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
      );
      // Go back to the profile screen and pass the new user data as a result.
      Navigator.of(context).pop(updatedUser);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _businessNameController,
                decoration: const InputDecoration(labelText: 'Business Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a business name.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactNameController,
                decoration: const InputDecoration(labelText: 'Contact Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a contact name.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Please enter a phone number.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.user.email,
                decoration: const InputDecoration(labelText: 'Email Address (read-only)'),
                readOnly: true,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('SAVE CHANGES'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}