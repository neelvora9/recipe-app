import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layer_kit/layer_kit.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';
import 'package:myapp/config/theme/configs/theme_extensions.dart';
import 'package:myapp/core/common/widgets/custom_image.dart';
import 'package:myapp/core/constants/app_strings.dart';
import 'package:myapp/core/constants/image_constants.dart';
import 'package:myapp/src/home/datasource/model/response/meal_response.dart';
import '../../../config/routes/routes.dart';
import '../../../config/theme/atoms/text.dart';
import '../home_bloc/home_bloc.dart';
import '../home_bloc/home_event.dart';
import '../home_bloc/home_state.dart';

class MealDetailScreen extends StatefulWidget with BaseRoute {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();

  @override
  Widget get screen => this;

  @override
  Routes get routeName => Routes.mealDetail;
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  void initState() {
    super.initState();

    // 🔥 Trigger BLoC event
    Future.microtask(() {
      context.read<HomeBloc>().add(LoadMealDetail(widget.mealId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppString.custom("Meal Details").appbar.build(color: context.colors.primary),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            // if (state.isLoading) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            final meal = state.selectedMeal;

            if (meal == null) {
              return Center(
                child: AppString.custom("No Data Found").t14.build(),
              );
            }

            return _buildContent(meal);
          },
        ),
      ),
    );
  }

  Widget _buildContent(MealDetailModel meal) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🍽️ IMAGE
          CustomImage(
            placeHolderImage: AssetImage(AppImages.image_placeholder),
            url: meal.image,
            height: 25.h,
            radius: BorderRadius.vertical(bottom: Radius.circular(12)),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🥘 TITLE
                AppString.custom(meal.name).t18.build(),

                const SizedBox(height: 8),

                /// 🌍 AREA + CATEGORY
                AppString.custom(
                  "${meal.area} • ${meal.category}",
                ).t14.build(),

                const SizedBox(height: 20),

                /// 🧾 INGREDIENTS
                AppString.custom("Ingredients").t16.build(),
                const SizedBox(height: 8),
                ..._buildIngredients(meal),

                const SizedBox(height: 20),

                /// 📖 INSTRUCTIONS
                AppString.custom("Instructions").t16.build(),
                const SizedBox(height: 8),

                AppString.custom(meal.instructions).t14.build(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIngredients(MealDetailModel meal) {
    return meal.ingredients.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: AppString.custom("• $item").t14.build(),
      );
    }).toList();
  }
}
