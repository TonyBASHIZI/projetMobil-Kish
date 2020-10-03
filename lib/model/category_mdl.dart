import 'package:zakuuza/model/api.dart';
class Category {
  final int id;
  final String name;
  final String image;

  Category({this.id, this.name, this.image});

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: num.tryParse(json['code_produit']),
      name: json['design_produit'],
      image: BaseUrl.uploadUrl + json['image']
      // image: json['image']
      );
  }
}