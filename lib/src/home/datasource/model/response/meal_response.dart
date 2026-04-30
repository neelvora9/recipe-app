class MealModel {
  final String id;
  final String name;
  final String thumbnail;

  MealModel({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json["idMeal"] ?? "",
      name: json["strMeal"] ?? "",
      thumbnail: json["strMealThumb"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idMeal": id,
      "strMeal": name,
      "strMealThumb": thumbnail,
    };
  }
}

class MealDetailModel {
  final String name;
  final String image;
  final String instructions;
  final String area;
  final String category;
  final List<String> ingredients;

  MealDetailModel({
    required this.name,
    required this.image,
    required this.instructions,
    required this.area,
    required this.category,
    required this.ingredients,
  });

  factory MealDetailModel.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ing = json["strIngredient$i"];
      final measure = json["strMeasure$i"];

      if (ing != null && ing.toString().isNotEmpty) {
        ingredients.add("$ing - $measure");
      }
    }

    return MealDetailModel(
      name: json["strMeal"] ?? "",
      image: json["strMealThumb"] ?? "",
      instructions: json["strInstructions"] ?? "",
      area: json["strArea"] ?? "",
      category: json["strCategory"] ?? "",
      ingredients: ingredients,
    );
  }
}