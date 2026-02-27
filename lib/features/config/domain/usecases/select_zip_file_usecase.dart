import 'package:lockpass/core/services/file_picker/file_picker_service.dart';

class SelectZipFileUseCase {
  final FilePickerService _filePickerService;

  SelectZipFileUseCase(this._filePickerService);

  Future<String?> call() async {
    return await _filePickerService.pickZipFile();
  }
}