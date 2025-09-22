import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/app_styles.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Welcome Heading
            Text(
              "Welcome, ${user?.displayName ?? "User"} 👋",
              style: AppStyles.heading1,
            ),
            const SizedBox(height: 10),
            Text("Email: ${user?.email ?? "Not available"}",
                style: AppStyles.bodyText),

            const SizedBox(height: 30),

            // ✅ Section Buttons
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text("My Wishlist"),
              onTap: () {
                Navigator.pushNamed(context, '/wishlist');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("My Orders"),
              onTap: () {
                Navigator.pushNamed(context, '/orders');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                // later: navigate to settings screen
              },
            ),

            const Spacer(),

            // ✅ Logout
            CustomButton(
              text: "Logout",
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
}
