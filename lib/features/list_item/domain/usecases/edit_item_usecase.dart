import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/extensions/string_validators.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class EditItemUseCase {
  final AuthService _authService;
  final ItensRepository _repository;
  final DekManager _dekManager;

  EditItemUseCase(
    this._authService,
    this._repository,
    this._dekManager,
  );

  Future<ItensEntity> call(ItensEntity item) async {
    final uid = _authService.currentUserId;

    if (uid.isEmpty) {
      throw AuthErrorType.requiresRecentLogin;
    }

    final dek = await _dekManager.getOrCreateDek(uid);

    final encryptUid = EncryptDecrypt.generateUserMask(uid);
    final encryptedGroup = await EncryptDecrypt.encryptInformation(plainText: item.group.trim(), dek: dek);
    final encryptedService = await EncryptDecrypt.encryptInformation(plainText: item.service.trim(), dek: dek);
    final encryptedSite =
        item.site != null ? await EncryptDecrypt.encryptInformation(plainText: item.site!.trim(), dek: dek) : null;
    final encryptedEmail = await EncryptDecrypt.encryptInformation(plainText: item.email.trim(), dek: dek);
    final encryptedLogin = await EncryptDecrypt.encryptInformation(plainText: item.login.trim(), dek: dek);
    final encryptedPassword = await EncryptDecrypt.encryptInformation(plainText: item.password.trim(), dek: dek);

    final isSecurity = encryptedGroup.isNotNull &&
        encryptedService.isNotNull &&
        encryptedEmail.isNotNull &&
        encryptedLogin.isNotNull &&
        encryptedPassword.isNotNull;
    if (!isSecurity) {
      throw Exception("SECURITY_FAILURE");
    }

    final itemToSave = item.copyWith(
      userId: encryptUid,
      group: encryptedGroup,
      service: encryptedService,
      site: encryptedSite,
      email: encryptedEmail,
      login: encryptedLogin,
      password: encryptedPassword,
    );

    await _repository.updateItem(itemToSave);

    return item;
  }
}