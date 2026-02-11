import 'dart:io';
// import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/constants/core_strings.dart';
import 'package:lockpass/core/paths/lockpass_paths.dart';
import 'package:lockpass/core/utils/extensions/string_extensions.dart';
import 'package:lockpass/core/utils/validators/validators.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/database/database_helper.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:lockpass/services/pin_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_archive/flutter_archive.dart';

import '../state/config_state.dart';

class ConfigController extends Cubit<ConfigState> {
  final VaultService _vaultService;
  final AuthService _authService;
  final DataBaseHelper _db;
  final PinService _pinService;

  ConfigController({
    required VaultService vaultService,
    required AuthService authService,
    required DataBaseHelper db,
    required PinService pinService,
  })  : _vaultService = vaultService,
        _authService = authService,
        _db = db,
        _pinService = pinService,
        super(const ConfigState()) {
    _initialize();
  }

  void _initialize() async {
    await getPinVerification();
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: '', successMessage: ''));
  }

  String get _uid {
    final uid = _authService.currentUserId;
    if (uid.isEmpty) throw Exception('Usuário não autenticado.');
    return uid;
  }

  void resetPinForm() {
    emit(state.copyWith(
      isFormValid: false,
      pinValidate: false,
    ));
  }

  void onFormChanged({
    required bool isFormValid,
    required bool isUpdate,
    required String currentPin,
    String? newPin,
  }) {
    final _currentPin =
        currentPin.isNotNullOrBlank && currentPin.trim().length == 5;
    final _newPin = newPin.isNotNullOrBlank && newPin?.trim().length == 5;

    if (!isUpdate) {
      if (!_newPin) {
        emit(state.copyWith(pinValidate: false, isFormValid: false));
        return;
      }

      emit(
        state.copyWith(pinValidate: true, isFormValid: true),
      );
    }

    if (!_currentPin || !_newPin) {
      emit(
        state.copyWith(
          pinValidate: false,
          isFormValid: false,
        ),
      );
    }

    emit(state.copyWith(
      pinValidate: true,
      isFormValid: isFormValid,
    ));
  }

  // -------------------------
  // Initial load
  // -------------------------
  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _vaultService.initializePreferences();
      await verifyPlatform();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<bool> reauthenticate({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(
        isLoading: true,
        successMessage: '',
        errorMessage: '',
      ));
      await _authService.reauthenticateWithPassword(
        email: email,
        password: password,
      );
      emit(state.copyWith(
        successMessage: "Identidade confirmada. Agora crie um novo PIN.",
        isLoading: false,
        hasPin: false,
      ));
      removePin();
      return true;
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage:
            "Não foi possível confirmar sua identidade. Verifique e-mail e senha e tente novamente.",
      ));
      return false;
    }
  }

  // -------------------------
  // Delete Account
  // -------------------------

  Future<void> deleteAccount() async {
    emit(
      state.copyWith(isLoading: true, errorMessage: '', successMessage: ''),
    );

    final stopwatch = Stopwatch()..start();
    const minDuration = Duration(milliseconds: 600);

    bool success = false;

    try {
      await _db.closeDatabase();

      await _db.deleteLocalDatabase();

      final appDir = await getApplicationDocumentsDirectory();
      final backupFile = File(p.join(appDir.path, 'LPB_automatic.zip'));
      if (await backupFile.exists()) {
        await backupFile.delete();
        print("Backup automático removido com sucesso.");
      }

      await _vaultService.initializePreferences();
      final prefs = await _vaultService.prefs();
      await prefs.clearUserData();
      await _authService.deleteAccount();

      success = true;
    } catch (e) {
      success = false;
      print("Erro ao excluir conta: $e");
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Não foi possível excluir a conta. Tente novamente.',
      ));
    } finally {
      final elapsed = stopwatch.elapsed;
      if (elapsed < minDuration) {
        await Future.delayed(minDuration - elapsed);
      }

      emit(state.copyWith(
        isLoading: false,
        successMessage: success ? 'Conta removida com sucesso.' : '',
      ));
    }
  }

  Future<bool> signOut() async {
    emit(state.copyWith(isLoading: true));
    try {
      await importAutomaticBackup();
      await AuthService().sigInOut();
      emit(state.copyWith(isLoading: false, successMessage: 'Saiu da conta.'));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return false;
    }
  }

  // -------------------------
  // PIN
  // -------------------------

  Future<bool> verifyCurrentPin(String typedPin) async {
    final uid = _authService.currentUserId;
    if (uid.isEmpty) return false;

    return await _pinService.validatePin(uid, typedPin.trim());
  }

  bool pinIsValid(String pin) {
    final exp = RegExp(CoreStrings.regExpValidatePin);
    return exp.hasMatch(pin);
  }

  Future<void> saveNewPin(String newAndUpdatePin) async {
    try {
      final newPin = pinIsValid(newAndUpdatePin);
      if (!newPin) {
        emit(state.copyWith(
          pinValidate: false,
          errorMessage:
              'PIN inválido. Consulta as regras de criaçāo no botāo de informação.',
        ));
        return;
      }

      await _pinService.savePin(_uid, newAndUpdatePin);

      emit(state.copyWith(
        pinValidate: true,
        successMessage: 'PIN salvo com sucesso.',
        hasPin: true,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> saveUpdatePin(String currentPin, String newAndUpdatePin) async {
    try {
      final isValidCurrentAndUpdatePin =
          pinIsValid(currentPin) && pinIsValid(newAndUpdatePin);
      final checkingCurrentPin = await verifyCurrentPin(currentPin);
      if (!isValidCurrentAndUpdatePin) {
        emit(state.copyWith(
          pinValidate: false,
          errorMessage:
              'PIN inválido. Consulte as regras para criação do PIN no botão de informação.',
        ));
        return;
      }

      if (!checkingCurrentPin) {
        emit(state.copyWith(
          pinValidate: false,
          errorMessage: 'O PIN informado não corresponde ao PIN cadastrado.',
        ));
        return;
      }
      await _pinService.savePin(_uid, newAndUpdatePin);

      emit(state.copyWith(
        pinValidate: true,
        successMessage: 'PIN atualizado com sucesso.',
        hasPin: true,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> savePin(
      String currentPin, String newAndUpdatePin, bool hasPin) async {
    emit(state.copyWith(
      isLoading: true,
      isFormValid: false,
    ));
    try {
      clearMessages();
      if (hasPin) {
        await saveUpdatePin(currentPin, newAndUpdatePin);
      } else {
        await saveNewPin(newAndUpdatePin);
      }
      // Future.delayed(const Duration(seconds: 1), () {
      //   emit(state.copyWith(
      //     isLoading: false,
      //   ));
      // });
      emit(state.copyWith(
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> removePin() async {
    emit(state.copyWith(
      isLoading: true,
      successMessage: '',
      errorMessage: '',
    ));

    final stopwatch = Stopwatch()..start();
    const minDuration = Duration(milliseconds: 600);

    try {
      await _pinService.removePin(_uid);

      await _vaultService.initializePreferences();
      final prefs = await _vaultService.prefs();
      await prefs.setVisibleCreatePinInfo(false);

      await getPinVerification();

      final elapsed = stopwatch.elapsed;
      if (elapsed < minDuration) {
        await Future.delayed(minDuration - elapsed);
      }

      emit(state.copyWith(
        isLoading: false,
        successMessage: 'PIN removido com sucesso.',
      ));
    } catch (e) {
      final elapsed = stopwatch.elapsed;
      if (elapsed < minDuration) {
        await Future.delayed(minDuration - elapsed);
      }

      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Não foi possível remover o PIN. Tente novamente.',
      ));
    }
  }

  // Future<void> getPinVerification() async {
  //   emit(state.copyWith(
  //     isCheckingPin: true,
  //   ));
  //   final pin = await _pinService.getPin(_uid);

  //   if (pin.isNullOrBlank) {
  //     emit(state.copyWith(hasPin: false, isCheckingPin: false));
  //     return;
  //   }

  //   final pinInt = int.tryParse(pin?? '') ?? 0;

  //   emit(state.copyWith(
  //     hasPin: pinInt != 0,
  //     isCheckingPin: false,
  //   ));
  // }

  Future<void> getPinVerification() async {
    emit(state.copyWith(isCheckingPin: true));

    final hasPin = await _pinService.hasPin();

    emit(state.copyWith(
      hasPin: hasPin,
      isCheckingPin: false,
    ));
  }

  Future<String> pinDecrypt() async {
    final pin = await _pinService.getPin(_uid);
    return pin ?? '';
  }

  Future<void> confirmAndRemovePin(String typedPin) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: '',
      successMessage: '',
    ));

    final uid = _authService.currentUserId;
    if (uid.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Usuário não autenticado.',
      ));
      return;
    }

    try {
      // 🔐 Valida PIN digitado
      final isValid = await _pinService.validatePin(uid, typedPin.trim());

      if (!isValid) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'O PIN informado não corresponde ao PIN cadastrado.',
        ));
        return;
      }

      // 🗑️ Remove PIN
      await _pinService.removePin(uid);

      // 🧠 Ajustes de UI / UX
      await _vaultService.initializePreferences();
      final prefs = await _vaultService.prefs();
      await prefs.setVisibleCreatePinInfo(false);

      emit(state.copyWith(
        isLoading: false,
        hasPin: false,
        successMessage: 'PIN removido com sucesso.',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Não foi possível remover o PIN. Tente novamente.',
      ));
    }
  }

  // -------------------------
  // Platform
  // -------------------------
  Future<void> verifyPlatform() async {
    emit(state.copyWith(isAndroid: Platform.isAndroid));
    // if (Platform.isAndroid) {
    //   final p = await AndroidPathProvider.downloadsPath;
    //   emit(state.copyWith(isAndroid: true, path: p));
    // } else {
    //   final directory = await getApplicationDocumentsDirectory();
    //   emit(state.copyWith(isAndroid: false, path: directory.path));
    // }
  }

  // -------------------------
  // Permission
  // -------------------------
  Future<void> requestPermission(Permission permission) async {
    await _vaultService.initializePreferences();
    final prefs = await _vaultService.prefs();
    final status = await permission.request();

    if (status.isGranted) {
      await prefs.setPermissionStorage(true);
      emit(state.copyWith(successMessage: 'Permissão concedida.'));
    } else {
      await prefs.setPermissionStorage(false);
      emit(state.copyWith(errorMessage: 'Permissão negada.'));
    }
  }

  Future<bool> checkPermission() async {
    await _vaultService.initializePreferences();
    final prefs = await _vaultService.prefs();
    return prefs.getPermissionStorage();
  }

  void togglePasswordVisibility() {
    final newSufixIcon = !state.sufixIcon;
    emit(state.copyWith(
      sufixIcon: newSufixIcon,
      obscureText: newSufixIcon, // seu padrão atual
    ));
  }

  // -------------------------
  // File picker
  // -------------------------
  Future<void> selectFile() async {
    emit(state.copyWith(isLoading: true));
    try {
      final directory = CoreStrings.appName;

      final picked = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        initialDirectory: directory,
        lockParentWindow: true,
      );

      final file = picked?.files.firstOrNull;

      if (file == null) {
        emit(state.copyWith(isLoading: false, selectedFile: false));
        return;
      }

      emit(state.copyWith(
        isLoading: false,
        selectedFile: true,
        selectedFileName: file.name,
      ));
    } on PlatformException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        selectedFile: false,
        errorMessage: e.message ?? e.toString(),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        selectedFile: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // -------------------------
  // Zip encryption
  // -------------------------
  String _generateListItensFileName() {
    final now = DateTime.now();

    final date =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

    final time = '${now.hour.toString().padLeft(2, '0')}-'
        '${now.minute.toString().padLeft(2, '0')}-'
        '${now.second.toString().padLeft(2, '0')}';

    return 'LPB_${date}_$time.zip';
  }

  Future<void> selectedFolder() async {
    emit(state.copyWith(isLoading: true));
    try {
      final directory = CoreStrings.appName;

      final folderPath = await FilePicker.platform.getDirectoryPath(
        initialDirectory: directory,
        lockParentWindow: true,
      );

      if (folderPath == null) {
        emit(state.copyWith(isLoading: false, selectedFolder: false));
        return;
      }

      String folderName = folderPath.split('/').last;

      if (folderName.isEmpty) {
        List<String> partes = folderPath.split('/');
        folderName =
            partes.length > 1 ? partes[partes.length - 2] : "Pasta selecionada";
      }

      emit(state.copyWith(
        isLoading: false,
        selectedFolder: true,
        selectedFolderPath: folderPath,
        folderName: folderName,
      ));
    } on PlatformException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        selectedFolder: false,
        errorMessage: e.message ?? e.toString(),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        selectedFolder: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void resetSelectedFolder() {
    emit(state.copyWith(
      selectedFolder: false,
      selectedFolderPath: '',
      folderName: '',
    ));
  }

  Future<void> selectZipFile() async {
    emit(state.copyWith(
      selectedZipPath: '',
      selectedZipName: '',
      hasSelectedZip: false,
    ));
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        allowMultiple: false,
      );

      if (result == null) {
        emit(state.copyWith(hasSelectedZip: false));
        return;
      }

      final file = result.files.single;

      emit(state.copyWith(
        selectedZipPath: file.path!,
        selectedZipName: file.name,
        hasSelectedZip: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        hasSelectedZip: false,
        errorMessage: 'Falha ao selecionar arquivo',
      ));
    }
  }

  Future<void> exportBackup() async {
    clearMessages();
    emit(state.copyWith(isLoading: true, saveZip: false));
    try {
      final Directory dbDir = await LockPassPaths.dbDir;
      final File dbFile = File(p.join(dbDir.path, 'lockpass_itens.db'));

      if (!await dbFile.exists()) {
        throw Exception("Arquivo de banco de dados não encontrado.");
      }

      final fileName = _generateListItensFileName();
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = p.join(tempDir.path, fileName);
      final zipFile = File(tempPath);

      await ZipFile.createFromFiles(
          sourceDir: dbDir, // Diretório base
          files: [dbFile], // Lista de arquivos para incluir
          zipFile: zipFile, // Onde salvar o ZIP
          includeBaseDirectory: false);

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Onde deseja salvar o backup?',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: await zipFile.readAsBytes(), // Passamos os dados do arquivo
      );

      if (outputFile.isNullOrBlank) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      if (await zipFile.exists()) {
        await zipFile.delete();
      }

      emit(state.copyWith(
        isLoading: false,
        saveZip: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Não foi possível salvar a lista.',
      ));
    }
  }

  Future<void> importManualBackup() async {
    final path = state.selectedZipPath;
    if (path == null || path.isEmpty) return;

    emit(state.copyWith(isLoading: true, errorMessage: '', successMessage: ''));

    final dbHelper = DataBaseHelper();
    final Directory destinationDir = await LockPassPaths.dbDir;
    final File dbFileAtual =
        File(p.join(destinationDir.path, 'lockpass_itens.db'));
    final File dbFileBackup =
        File(p.join(destinationDir.path, 'lockpass_itens.db.bak'));

    try {
      await dbHelper.closeDatabase();

      if (await dbFileAtual.exists()) {
        if (await dbFileBackup.exists()) await dbFileBackup.delete();
        await dbFileAtual.rename(dbFileBackup.path);
      }

      await ZipFile.extractToDirectory(
        zipFile: File(path),
        destinationDir: destinationDir,
      );

      await dbHelper.database;

      if (await dbFileBackup.exists()) await dbFileBackup.delete();

      emit(state.copyWith(
        isLoading: false,
        successMessage: "Backup restaurado com sucesso!",
        selectedZipName: '',
        selectedZipPath: '',
        hasSelectedZip: false,
      ));
    } catch (e) {
      print("Erro na importação: $e");

      if (await dbFileBackup.exists()) {
        if (await dbFileAtual.exists()) await dbFileAtual.delete();
        await dbFileBackup.rename(dbFileAtual.path);
      }

      emit(state.copyWith(
        isLoading: false,
        errorMessage: "Falha ao restaurar: arquivo inválido ou corrompido.",
        selectedZipName: '',
        selectedZipPath: '',
        hasSelectedZip: false,
      ));
    }
  }

  Future<void> importAutomaticBackup() async {
    emit(state.copyWith(isLoading: true));

    try {
      // 1. Localiza o backup automático
      final directory = await getApplicationDocumentsDirectory();
      final backupFile = File(p.join(directory.path, 'LPB_automatic.zip'));

      if (!await backupFile.exists()) {
        emit(state.copyWith(
            isLoading: false,
            errorMessage: "Nenhum backup automático encontrado."));
        return;
      }

      final dbHelper = DataBaseHelper();
      final Directory destinationDir = await LockPassPaths.dbDir;
      final File dbFileAtual =
          File(p.join(destinationDir.path, 'lockpass_itens.db'));
      final File dbFileBackup =
          File(p.join(destinationDir.path, 'lockpass_itens.db.bak'));

      await dbHelper.closeDatabase();

      if (await dbFileAtual.exists()) {
        if (await dbFileBackup.exists()) await dbFileBackup.delete();
        await dbFileAtual.rename(dbFileBackup.path);
      }

      await ZipFile.extractToDirectory(
        zipFile: backupFile,
        destinationDir: destinationDir,
      );

      await dbHelper.database;

      if (await dbFileBackup.exists()) await dbFileBackup.delete();

      emit(state.copyWith(
          isLoading: false, successMessage: "Backup automático restaurado!"));
    } catch (e) {
      // Lógica de Rollback aqui (renomear o .bak de volta para .db)
      // ...
      emit(
          state.copyWith(isLoading: false, errorMessage: "Erro ao restaurar."));
    }
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    emit(state.copyWith(isLoading: true, updatedPassword: false));
    clearMessages();
    try {
      await _authService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      signOut();
      // Sucesso
      emit(state.copyWith(
        isLoading: false,
        successMessage: "Sua senha foi alterada!",
        updatedPassword: true,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    }
  }

  void isFormValid(String currentPassword, String newPassword) {
    final isFormValid = currentPassword.isNotBlank && newPassword.length >= 6;
    emit(state.copyWith(isFormValid: isFormValid));
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
