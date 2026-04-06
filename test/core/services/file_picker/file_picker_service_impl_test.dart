import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/file_picker/file_picker_service_impl.dart';

class _FakeFilePicker extends FilePicker {
  _FakeFilePicker({this.result});

  FilePickerResult? result;
  FileType? lastType;
  List<String>? lastAllowedExtensions;
  bool? lastAllowMultiple;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    lastType = type;
    lastAllowedExtensions = allowedExtensions;
    lastAllowMultiple = allowMultiple;
    return result;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FilePickerServiceImpl', () {
    setUp(() {
      // In widget/unit tests, FilePicker.platform is not initialized by default.
      // Keep it set to a fake for the duration of the test.
      FilePicker.platform = _FakeFilePicker(result: null);
    });

    tearDown(() {
      FilePicker.platform = _FakeFilePicker(result: null);
    });

    test('returns null when user cancels', () async {
      final fake = _FakeFilePicker(result: null);
      FilePicker.platform = fake;

      final service = FilePickerServiceImpl();
      final path = await service.pickZipFile();

      expect(path, isNull);
      expect(fake.lastType, FileType.custom);
      expect(fake.lastAllowedExtensions, ['zip']);
      expect(fake.lastAllowMultiple, isFalse);
    });

    test('returns picked path when file is selected', () async {
      final fake = _FakeFilePicker(
        result: FilePickerResult([
          PlatformFile(name: 'backup.zip', size: 1, path: '/tmp/backup.zip'),
        ]),
      );
      FilePicker.platform = fake;

      final service = FilePickerServiceImpl();
      final path = await service.pickZipFile();

      expect(path, '/tmp/backup.zip');
    });
  });
}
