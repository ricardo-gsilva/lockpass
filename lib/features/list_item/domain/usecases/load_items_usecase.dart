import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';

class LoadItemsUseCase {
  final AuthService _authService;
  final ItensRepository _repository;
  final DekManager _dekManager;

  LoadItemsUseCase(
    this._authService,
    this._repository,
    this._dekManager,
  );

  Future<({
    List<ItensEntity> items,
    List<ItensEntity> sorted,
    bool hasDeleted,
    ListViewModeEnum mode,
  })> call(ListViewModeEnum currentMode) async {
    final uid = _authService.currentUserId;

    if (uid.isEmpty) {
      throw AuthErrorType.requiresRecentLogin;
    }

    final dek = await _dekManager.getOrCreateDek(uid);

    final uidSearchMask = EncryptDecrypt.generateUserMask(uid);
    if (uidSearchMask.isEmpty) throw Exception("SECURITY_FAILURE");

    final deletedEncrypted = await _repository.getDeletedItensByUser(uidSearchMask);
    final hasDeleted = deletedEncrypted.isNotEmpty;

    final nextMode = hasDeleted ? currentMode : ListViewModeEnum.list;

    final List<ItensEntity> encryptedList = nextMode == ListViewModeEnum.trash
        ? deletedEncrypted
        : await _repository.getActiveItensByUser(uidSearchMask);

    final decryptedItems = await Future.wait(
      encryptedList.map((item) async {
        return item.copyWith(
          userId: uid,
          group: await EncryptDecrypt.decryptInformation(payloadB64: item.group, dek: dek) ?? "Erro",
          service: await EncryptDecrypt.decryptInformation(payloadB64: item.service, dek: dek) ?? "Serviço Indisponível",
          email: await EncryptDecrypt.decryptInformation(payloadB64: item.email, dek: dek) ?? "",
          login: await EncryptDecrypt.decryptInformation(payloadB64: item.login, dek: dek) ?? "",
          password: await EncryptDecrypt.decryptInformation(payloadB64: item.password, dek: dek) ?? "",
          site: item.site != null ? await EncryptDecrypt.decryptInformation(payloadB64: item.site!, dek: dek) : "",
        );
      }),
    );

    final sorted = [...decryptedItems]
      ..sort((a, b) => a.service.toLowerCase().compareTo(b.service.toLowerCase()));

    return (
      items: decryptedItems,
      sorted: sorted,
      hasDeleted: hasDeleted,
      mode: nextMode,
    );
  }
}