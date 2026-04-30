import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layer_kit/layer_kit.dart';
import 'package:myapp/config/theme/configs/theme_extensions.dart';
import 'package:myapp/core/constants/app_strings.dart';
import 'package:myapp/core/network/network_checker_widget.dart';
import 'package:myapp/src/home/datasource/model/response/meal_response.dart';
import '../../../config/routes/routes.dart';
import '../../../config/theme/atoms/padding.dart';
import '../../../config/theme/atoms/text.dart';
import '../../../core/common/widgets/custom_image.dart';
import '../../../core/common/widgets/custom_text_field.dart';
import '../../../core/constants/image_constants.dart';
import '../home_bloc/home_bloc.dart';
import '../home_bloc/home_event.dart';
import '../home_bloc/home_state.dart';
import 'meal_details_screen.dart';

class MealListScreen extends StatefulWidget with BaseRoute {
  final String title;
  final List<MealModel> meals;

  const MealListScreen({
    super.key,
    required this.title,
    required this.meals,
  });

  @override
  State<MealListScreen> createState() => _MealListScreenState();

  @override
  Widget get screen => this;

  @override
  Routes get routeName => Routes.mealList;
}

class _MealListScreenState extends State<MealListScreen> {
  Timer? _debounce;

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<HomeBloc>().add(SearchMeals(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return NetworkCheckerWidget(
      child: Scaffold(
        appBar: AppBar(
          title: AppString.custom(widget.title).t16.build(),
        ),
        body: Padding(
          padding: Gap.size18.paddingHorizontal,
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// 🔍 SEARCH BAR
              CustomTextField(
                onChanged: _onSearch,
                hintText: "Search meals...",
              ),

              const SizedBox(height: 12),

              /// 📦 DATA
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    final meals = state.searchResults.isEmpty ? widget.meals : state.searchResults;

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (meals.isEmpty) {
                      return Center(
                        child: AppString.custom("No meals found").t14.build(),
                      );
                    }

                    return GridView.builder(
                      itemCount: meals.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        return _MealCard(meal: meals[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealCard extends StatefulWidget {
  final MealModel meal;

  const _MealCard({required this.meal});

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _toggleFavorite() {
    context.read<HomeBloc>().add(ToggleFavorite(widget.meal));
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;

    final isFav = context.select<HomeBloc, bool>(
          (bloc) => bloc.state.favorites.any((e) => e.id == meal.id),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.pushNamed(
          MealDetailScreen(mealId: meal.id),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.secondary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                /// 🔥 HERO IMAGE
                Hero(
                  tag: "meal_${meal.id}",
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: CustomImage(
                      borderRadius: 0,
                      placeHolderImage: const AssetImage(AppImages.image_placeholder),
                      url: meal.thumbnail,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                /// ❤️ FAVORITE BUTTON
                Positioned(
                  top: 8,
                  right: 8,
                  child: ScaleTransition(
                    scale: _scale,
                    child: GestureDetector(
                      onTap: _toggleFavorite,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// 📝 TITLE
            AppString.custom(meal.name)
                .t14
                .build(
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )
                .paddingAll(6),
          ],
        ),
      ),
    );
  }
}
