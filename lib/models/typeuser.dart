import 'dart:convert';

class TypeUserModel {
  final String name;
  final String typeuser;
  final String urlshopper;
  
  TypeUserModel({
    this.name,
    this.typeuser,
    this.urlshopper,
  });

  TypeUserModel copyWith({
    String name,
    String typeuser,
    String urlshopper,
  }) {
    return TypeUserModel(
      name: name ?? this.name,
      typeuser: typeuser ?? this.typeuser,
      urlshopper: urlshopper ?? this.urlshopper,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'typeuser': typeuser,
      'urlshopper': urlshopper,
    };
  }

  factory TypeUserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TypeUserModel(
      name: map['name'],
      typeuser: map['typeuser'],
      urlshopper: map['urlshopper'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeUserModel.fromJson(String source) => TypeUserModel.fromMap(json.decode(source));

  @override
  String toString() => 'TypeUserModel(name: $name, typeuser: $typeuser, urlshopper: $urlshopper)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TypeUserModel &&
      o.name == name &&
      o.typeuser == typeuser &&
      o.urlshopper == urlshopper;
  }

  @override
  int get hashCode => name.hashCode ^ typeuser.hashCode ^ urlshopper.hashCode;
}
