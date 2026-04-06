import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/file_picker/file_picker_service.dart';
import 'package:lockpass/features/config/domain/usecases/select_zip_file_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockFilePickerService extends Mock implements FilePickerService {}

void main() {
  group('SelectZipFileUseCase', () {
    test('returns selected path from file picker service', () async {
      final picker = _MockFilePickerService();
      final useCase = SelectZipFileUseCase(picker);

      when(() => picker.pickZipFile()).thenAnswer((_) async => '/tmp/a.zip');

      final result = await useCase();
      expect(result, '/tmp/a.zip');
    });
  });
}

