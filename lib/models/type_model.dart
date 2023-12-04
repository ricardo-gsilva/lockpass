import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TypeModel {
  int? typeId;
  String? type;
  bool? visible;

  TypeModel({
    this.typeId,
    this.type,
    this.visible = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'typeId': typeId,
      'type': type,
      'visible': visible == true? 1 : 0,
    };
  }

  factory TypeModel.fromMap(Map<String, dynamic> map) {
    return TypeModel(
      typeId: map['typeId'] != null ? map['typeId'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      visible: map['visible'] == 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeModel.fromJson(String source) => TypeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  TypeModel.empty():
    type = '',
    visible = false;

  @override
  String toString() => 'TypeModel(typeId: $typeId, type: $type, visible: $visible)';
}