import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';

class DecryptItemPasswordUseCase {
  final AuthService _authService;

  DecryptItemPasswordUseCase(this._authService);

  ItensEntity call(ItensEntity item) {
    final uid = _authService.currentUserId;

    if (uid.isEmpty) {
      return item;
    }

    final decrypted =
        EncryptDecrypt.decrypt(item.password, uid);

    return item.copyWith(password: decrypted);
  }
}