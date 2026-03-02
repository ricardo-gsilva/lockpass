import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class LoadItemGroupsUseCase {
  final AuthService _authService;
  final ItensRepository _repository;
  final DekManager _dekManager;

  LoadItemGroupsUseCase(
    this._authService,
    this._repository,
    this._dekManager,
  );

  Future<List<String>> call() async {
    final uid = _authService.currentUserId;

    if (uid.isEmpty) {
      return [];
    }
    final uidSearchMask = EncryptDecrypt.generateUserMask(uid);
    final dek = await _dekManager.getOrCreateDek(uid);

    final itens = await _repository.getActiveItensByUser(uidSearchMask);

    final decryptedGroups = await Future.wait(itens.map((item) async {
      return await EncryptDecrypt.decryptInformation(payloadB64: item.group.trim(), dek: dek);
    }));

    final groups = decryptedGroups
        .whereType<String>()
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return groups;
  }
}