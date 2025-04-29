class FavoritesModel {
  bool? status;
  FavoritesDataModel? data;
  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data =
        json['data'] != null ? FavoritesDataModel.fromJson(json['data']) : null;
  }
}

class FavoritesDataModel {
  late String id;
  List<FavoriteProductModel> favoritesProducts = [];
  FavoritesDataModel.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      favoritesProducts.add(FavoriteProductModel.fromJson(element['product']));
    });
  }
}

class FavoriteProductModel {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  late String name;
  bool? favorite;
  FavoriteProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    favorite = true;
  }
}
