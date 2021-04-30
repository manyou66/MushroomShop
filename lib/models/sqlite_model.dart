import 'dart:convert';

class SQLiteModel {
  final int id;
  final String idShop;
  final String nameShop;
  final String idProduct;
  final String nameProduct;
  final String price;
  final String amount;
  final String sum;
  SQLiteModel({
    this.id,
    this.idShop,
    this.nameShop,
    this.idProduct,
    this.nameProduct,
    this.price,
    this.amount,
    this.sum,
  });

  SQLiteModel copyWith({
    int id,
    String idShop,
    String nameShop,
    String idProduct,
    String nameProduct,
    String price,
    String amount,
    String sum,
  }) {
    return SQLiteModel(
      id: id ?? this.id,
      idShop: idShop ?? this.idShop,
      nameShop: nameShop ?? this.nameShop,
      idProduct: idProduct ?? this.idProduct,
      nameProduct: nameProduct ?? this.nameProduct,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      sum: sum ?? this.sum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idShop': idShop,
      'nameShop': nameShop,
      'idProduct': idProduct,
      'nameProduct': nameProduct,
      'price': price,
      'amount': amount,
      'sum': sum,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id'],
      idShop: map['idShop'],
      nameShop: map['nameShop'],
      idProduct: map['idProduct'],
      nameProduct: map['nameProduct'],
      price: map['price'],
      amount: map['amount'],
      sum: map['sum'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) =>
      SQLiteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SQLiteModel(id: $id, idShop: $idShop, nameShop: $nameShop, idProduct: $idProduct, nameProduct: $nameProduct, price: $price, amount: $amount, sum: $sum)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SQLiteModel &&
        other.id == id &&
        other.idShop == idShop &&
        other.nameShop == nameShop &&
        other.idProduct == idProduct &&
        other.nameProduct == nameProduct &&
        other.price == price &&
        other.amount == amount &&
        other.sum == sum;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idShop.hashCode ^
        nameShop.hashCode ^
        idProduct.hashCode ^
        nameProduct.hashCode ^
        price.hashCode ^
        amount.hashCode ^
        sum.hashCode;
  }
}
