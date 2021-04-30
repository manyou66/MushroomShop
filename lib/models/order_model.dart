import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderModel {
  final String uidBuyer;
  final String nameBuyer;
  final List<String> nameProducts;
  final List<String> prices;
  final List<String> amounts;
  final List<String> sums;
  final String total;
  OrderModel({
    this.uidBuyer,
    this.nameBuyer,
    this.nameProducts,
    this.prices,
    this.amounts,
    this.sums,
    this.total,
  });
  

  OrderModel copyWith({
    String uidBuyer,
    String nameBuyer,
    List<String> nameProducts,
    List<String> prices,
    List<String> amounts,
    List<String> sums,
    String total,
  }) {
    return OrderModel(
      uidBuyer: uidBuyer ?? this.uidBuyer,
      nameBuyer: nameBuyer ?? this.nameBuyer,
      nameProducts: nameProducts ?? this.nameProducts,
      prices: prices ?? this.prices,
      amounts: amounts ?? this.amounts,
      sums: sums ?? this.sums,
      total: total ?? this.total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uidBuyer': uidBuyer,
      'nameBuyer': nameBuyer,
      'nameProducts': nameProducts,
      'prices': prices,
      'amounts': amounts,
      'sums': sums,
      'total': total,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      uidBuyer: map['uidBuyer'],
      nameBuyer: map['nameBuyer'],
      nameProducts: List<String>.from(map['nameProducts']),
      prices: List<String>.from(map['prices']),
      amounts: List<String>.from(map['amounts']),
      sums: List<String>.from(map['sums']),
      total: map['total'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(uidBuyer: $uidBuyer, nameBuyer: $nameBuyer, nameProducts: $nameProducts, prices: $prices, amounts: $amounts, sums: $sums, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrderModel &&
      other.uidBuyer == uidBuyer &&
      other.nameBuyer == nameBuyer &&
      listEquals(other.nameProducts, nameProducts) &&
      listEquals(other.prices, prices) &&
      listEquals(other.amounts, amounts) &&
      listEquals(other.sums, sums) &&
      other.total == total;
  }

  @override
  int get hashCode {
    return uidBuyer.hashCode ^
      nameBuyer.hashCode ^
      nameProducts.hashCode ^
      prices.hashCode ^
      amounts.hashCode ^
      sums.hashCode ^
      total.hashCode;
  }
}
