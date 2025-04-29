class CategoriesModel {
  bool? status;
  CategoriesDataModel? data;
  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? CategoriesDataModel.fromJson(json['data'])
        : null;
  }
}

class CategoriesDataModel {
  List<CategoryModel> categories = [];
  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      categories.add(CategoryModel.fromJson(element));
    });
  }
}

class CategoryModel {
  late int id;
  late String name;
  late String image;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
