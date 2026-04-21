import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../state_managements/providers/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: const Icon(Icons.all_inclusive, color: Colors.black, size: 32),
        ),
        leadingWidth: 48,
        title: Text(
          'Profile',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: const Icon(Icons.more_horiz, color: Colors.black, size: 20),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading || provider.profile == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          final profile = provider.profile!;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(profile.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profile.phone,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),

                const Divider(
                  color: Color(0xFFEEEEEE),
                  thickness: 1,
                  indent: 24,
                  endIndent: 24,
                ),
                const SizedBox(height: 8),

                _buildMenuItem(Icons.person_outline, 'Edit Profile'),
                _buildMenuItem(Icons.location_on_outlined, 'Address'),
                _buildMenuItem(
                  Icons.notifications_none_outlined,
                  'Notification',
                ),
                _buildMenuItem(
                  Icons.account_balance_wallet_outlined,
                  'Payment',
                ),
                _buildMenuItem(Icons.security_outlined, 'Security'),
                _buildMenuItem(
                  Icons.language_outlined,
                  'Language',
                  trailingText: profile.language,
                ),
                _buildMenuItem(
                  Icons.visibility_outlined,
                  'Dark Mode',
                  trailingWidget: Switch(
                    value: profile.isDarkMode,
                    onChanged: (val) => provider.toggleDarkMode(val),
                    activeThumbColor: Colors.black,
                  ),
                ),
                _buildMenuItem(Icons.lock_outline, 'Privacy Policy'),
                _buildMenuItem(Icons.info_outline, 'Help Center'),
                _buildMenuItem(Icons.people_outline, 'Invite Friends'),

                _buildMenuItem(Icons.login_outlined, 'Logout', isLogout: true),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    String? trailingText,
    Widget? trailingWidget,
    bool isLogout = false,
  }) {
    final color = isLogout ? const Color(0xFFF75555) : Colors.black87;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
            ],
            if (trailingWidget != null)
              trailingWidget
            else if (!isLogout)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black54,
              ),
          ],
        ),
      ),
    );
  }
}
