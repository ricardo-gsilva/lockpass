import 'package:lockpass/domain/entities/itens_entity.dart';

class DecryptItemPasswordUseCase {
  ItensEntity call(ItensEntity item) {
    // Password decryption happens centrally in LoadItemsUseCase via DEK/AES-GCM.
    return item;
  }
}
