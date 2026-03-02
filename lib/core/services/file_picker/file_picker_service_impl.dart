import 'package:file_picker/file_picker.dart';

import 'file_picker_service.dart';

class FilePickerServiceImpl implements FilePickerService {
  @override
  Future<String?> pickZipFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      allowMultiple: false,
    );

    if (result == null) return null;

    return result.files.single.path;
  }
}