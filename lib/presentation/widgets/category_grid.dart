import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fashio/config/router/app_router.dart';
import '../../domain/models/home_models.dart';
import '../../utils/constants/app_constants.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: 10,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.categoryProducts,
              arguments: category.name,
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: AppColors.grey100,
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIcon(category.icon), size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'checkroom':
        return Icons.checkroom_rounded;
      case 'ice_skating':
        return Icons.ice_skating_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'devices':
        return Icons.devices_rounded;
      case 'watch':
        return Icons.watch_rounded;
      case 'diamond':
        return Icons.diamond_rounded;
      case 'soup_kitchen':
        return Icons.soup_kitchen_rounded;
      case 'toys':
        return Icons.toys_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
