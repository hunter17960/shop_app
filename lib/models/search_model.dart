class SearchModel {
  bool? status;
  SearchDataModel? data;
  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? SearchDataModel.fromJson(json['data']) : null;
  }
}

class SearchDataModel {
  late String id;
  List<SearchProductModel> products = [];
  SearchDataModel.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      products.add(SearchProductModel.fromJson(element));
    });
  }
}

class SearchProductModel {
  late int id;
  late dynamic price;
  late String image;
  late String name;
  bool? favorite;
  SearchProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    favorite = json['in_favorites'];
  }
}
