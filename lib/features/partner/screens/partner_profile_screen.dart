import 'package:flutter/material.dart';
import '../models/user.dart'; // Import your PartnerUser model
import './edit_partner_profile_screen.dart';
import './change_password_screen.dart';

// 1. CONVERTED TO A STATEFUL WIDGET
class PartnerProfileScreen extends StatefulWidget {
  static const routeName = '/partner-profile';

  const PartnerProfileScreen({Key? key}) : super(key: key);

  @override
  State<PartnerProfileScreen> createState() => _PartnerProfileScreenState();
}

class _PartnerProfileScreenState extends State<PartnerProfileScreen> {
  // 2. CREATE VARIABLES TO HOLD THE UNPACKED DATA
  late PartnerUser user;
  late String token;

  var _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This check ensures the code only runs once.
    if (!_isInitialized) {
      // 3. THIS IS THE CRITICAL FIX: UNPACK THE ARGUMENTS
      // Get the arguments which are now a Map.
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      // Extract the user and token from the Map.
      user = args['user'] as PartnerUser;
      token = args['token'] as String;

      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        // You might want to remove this or use your app's theme color
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the edit screen and wait for a result.
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditPartnerProfileScreen(
                    // Pass the current user and token to the edit screen
                    user: user,
                    token: token,
                  ),
                ),
              );

              // After returning, check if we got an updated user object.
              if (result != null && result is PartnerUser) {
                // If so, rebuild the screen with the new user data.
                setState(() {
                  user = result;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 4. THE REST OF THE UI NOW USES THE 'user' VARIABLE FROM THE STATE
            _buildProfileInfoCard(
              context,
              title: 'Business Details',
              icon: Icons.business,
              children: [
                _buildInfoRow('Business Name', user.description ?? 'Not Provided'),
              ],
            ),
            const SizedBox(height: 20),
            _buildProfileInfoCard(
              context,
              title: 'Contact Information',
              icon: Icons.person,
              children: [
                _buildInfoRow('Contact Name', user.fullname),
                _buildInfoRow('Email Address', user.email),
                _buildInfoRow('Phone Number', user.phone),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Change Password screen, passing the real token.
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(token: token),
                  ),
                );
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS (NO CHANGES NEEDED) ---

  Widget _buildProfileInfoCard(BuildContext context, {required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}