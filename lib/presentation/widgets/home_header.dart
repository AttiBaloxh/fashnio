import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashio/config/router/app_router.dart';
import '../../utils/constants/app_constants.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String greeting;
  final String profileImage;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.greeting,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundImage: NetworkImage(profileImage)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.textSubtitle,
                ),
              ),
              Text(
                userName,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBody,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.notification);
            },
            icon: const Icon(Icons.notifications_none_rounded, size: 28),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.wishlist);
            },
            icon: const Icon(Icons.favorite_border_rounded, size: 28),
          ),
        ],
      ),
    );
  }
}
