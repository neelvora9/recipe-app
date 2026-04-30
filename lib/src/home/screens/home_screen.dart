import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layer_kit/layer_kit.dart';
import 'package:myapp/config/theme/configs/theme_extensions.dart';
import 'package:myapp/core/common/widgets/custom_image.dart';
import 'package:myapp/core/constants/app_strings.dart';
import 'package:myapp/core/network/network_checker_widget.dart';
import 'package:myapp/src/home/screens/meal_details_screen.dart';
import 'package:myapp/src/home/screens/meal_list_screen.dart';
import '../../../config/routes/routes.dart';
import '../../../config/theme/atoms/padding.dart';
import '../../../config/theme/atoms/text.dart';
import '../../../core/constants/image_constants.dart';
import '../datasource/model/response/meal_response.dart';
import '../home_bloc/home_bloc.dart';
import '../home_bloc/home_event.dart';
import '../home_bloc/home_state.dart';

class HomeScreen extends StatefulWidget with BaseRoute {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  @override
  Widget get screen => this;

  @override
  Routes get routeName => Routes.home;
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // 🔥 Trigger BLoC Event
    // context.read<HomeBloc>().add(LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          title: AppString.custom("Home")
              .appbar
              .build(color: context.colors.primary),
          centerTitle: true,
        ),
        body: NetworkCheckerWidget(
          child: SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// ✅ OFFLINE MODE UI
                // if (state.isOffline) {
                //   return Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       const Icon(Icons.wifi_off, size: 50),
                //       const SizedBox(height: 10),
                //       const Text("You're offline"),
                //       const Text("Showing cached data"),
                //     ],
                //   );
                // }

                return ListView(
                  padding: Gap.size18.paddingHorizontal,
                  children: [
                    // -------- TIME BASED --------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppString.custom("Recommended for You")
                            .t18
                            .build(),
                        AppString.custom("View more")
                            .t12
                            .build(color: context.colors.primary)
                            .onTap(() {
                          context.pushNamed(
                            MealListScreen(
                              title: "Recommended for You",
                              meals: state.mealsByTime,
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildHorizontalList(state.mealsByTime,state.isOffline),

                    const SizedBox(height: 20),

                    // -------- LOCATION BASED --------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppString.custom("Popular in Your Area")
                            .t18
                            .build(),
                        AppString.custom("View more")
                            .t12
                            .build(color: context.colors.primary)
                            .onTap(() {
                          context.pushNamed(
                            MealListScreen(
                              title: "Popular in Your Area",
                              meals: state.mealsByLocation,
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildHorizontalList(state.mealsByLocation,state.isOffline),
                  ],
                );
              },
            ),
          ),
        ),
      );
  }

  // ---------------- COMMON LIST ----------------
  Widget _buildHorizontalList(List<MealModel> meals, bool isOffline) {
    if (meals.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.wifi_off, size: 30),
            SizedBox(height: 8),
            Text(
              isOffline
                  ? "No internet & no cached data"
                  : "No data available",
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: meals.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final meal = meals[index];

          return Container(
            width: 140,
            decoration: BoxDecoration(
              color: context.colors.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: CustomImage(
                      borderRadius: 0,
                      placeHolderImage:
                      AssetImage(AppImages.image_placeholder),
                      url: meal.thumbnail,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: AppString.custom(meal.name)
                      .t12
                      .build(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ).onTap(() {
            context.read<HomeBloc>().add(
              LoadMealDetail(meal.id),
            );

            context.pushNamed(
              MealDetailScreen(
                mealId: meal.id,
              ),
            );
          });
        },
      ),
    );
  }
}