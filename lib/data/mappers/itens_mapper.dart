import 'package:lockpass/data/models/itens_model.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';

class ItensMapper {
  static ItensEntity toEntity(ItensModel model) => model.toEntity();

  static ItensModel toModel(ItensEntity entity) =>
      ItensModel.fromEntity(entity);
}
