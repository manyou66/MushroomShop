import 'dart:convert';

class ProductModel {
  final String uidShop;
  final String nameProduct;
  final String price;
  final String unit;
  final String detail;
  final String stock;
  final String pathProduct;
  ProductModel({
    this.uidShop,
    this.nameProduct,
    this.price,
    this.unit,
    this.detail,
    this.stock,
    this.pathProduct,
  });

  ProductModel copyWith({
    String uidShop,
    String nameProduct,
    String price,
    String unit,
    String detail,
    String stock,
    String pathProduct,
  }) {
    return ProductModel(
      uidShop: uidShop ?? this.uidShop,
      nameProduct: nameProduct ?? this.nameProduct,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      detail: detail ?? this.detail,
      stock: stock ?? this.stock,
      pathProduct: pathProduct ?? this.pathProduct,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uidShop': uidShop,
      'nameProduct': nameProduct,
      'price': price,
      'unit': unit,
      'detail': detail,
      'stock': stock,
      'pathProduct': pathProduct,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      uidShop: map['uidShop'],
      nameProduct: map['nameProduct'],
      price: map['price'],
      unit: map['unit'],
      detail: map['detail'],
      stock: map['stock'],
      pathProduct: map['pathProduct'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(uidShop: $uidShop, nameProduct: $nameProduct, price: $price, unit: $unit, detail: $detail, stock: $stock, pathProduct: $pathProduct)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductModel &&
      other.uidShop == uidShop &&
      other.nameProduct == nameProduct &&
      other.price == price &&
      other.unit == unit &&
      other.detail == detail &&
      other.stock == stock &&
      other.pathProduct == pathProduct;
  }

  @override
  int get hashCode {
    return uidShop.hashCode ^
      nameProduct.hashCode ^
      price.hashCode ^
      unit.hashCode ^
      detail.hashCode ^
      stock.hashCode ^
      pathProduct.hashCode;
  }
}
