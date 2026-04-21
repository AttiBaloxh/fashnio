import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fashio/presentation/state_managements/providers/home_provider.dart';
import 'package:fashio/presentation/widgets/home_header.dart';
import 'package:fashio/presentation/widgets/home_search_bar.dart';
import 'package:fashio/presentation/widgets/special_offers_section.dart';
import 'package:fashio/presentation/widgets/category_grid.dart';
import 'package:fashio/presentation/widgets/popular_section_header.dart';
import 'package:fashio/presentation/widgets/product_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            if (provider.user == null) {
              return const Center(child: Text("Failed to load data"));
            }

            return RefreshIndicator(
              onRefresh: () => provider.fetchHomeData(),
              color: Colors.black,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    HomeHeader(
                      userName: provider.user!.name,
                      greeting: provider.user!.greeting,
                      profileImage: provider.user!.profileImage,
                    ),
                    const SizedBox(height: 20),
                    const HomeSearchBar(),
                    const SizedBox(height: 10),
                    SpecialOffersSection(offers: provider.offers),
                    CategoryGrid(categories: provider.categories),
                    PopularSectionHeader(
                      popularCategories: provider.popularCategories,
                      selectedCategory: provider.selectedPopularCategory,
                      onCategorySelected: (category) =>
                          provider.selectPopularCategory(category),
                    ),
                    ProductGrid(
                      products: provider.products
                          .where(
                            (p) =>
                                provider.selectedPopularCategory == "All" ||
                                p.category == provider.selectedPopularCategory,
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
