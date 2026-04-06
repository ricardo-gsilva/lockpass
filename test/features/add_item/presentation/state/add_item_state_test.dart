import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_state.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_status.dart';

void main() {
  group('AddItemState', () {
    test('default values', () {
      const state = AddItemState();
      expect(state.isFormValid, isFalse);
      expect(state.obscureText, isTrue);
      expect(state.sufixIcon, isTrue);
      expect(state.listItensDrop, isEmpty);
      expect(state.status, const AddItemInitial());
    });

    test('copyWith updates fields', () {
      const state = AddItemState();

      final next = state.copyWith(
        isFormValid: true,
        obscureText: false,
        sufixIcon: false,
        listItensDrop: const ['a'],
        status: const AddItemLoading(),
      );

      expect(
        next,
        AddItemState(
          isFormValid: true,
          obscureText: false,
          sufixIcon: false,
          listItensDrop: const ['a'],
          status: const AddItemLoading(),
        ),
      );
    });

    test('supports value equality (Equatable)', () {
      expect(
        AddItemState(listItensDrop: const ['a'], status: const AddItemFailure('x')),
        AddItemState(listItensDrop: const ['a'], status: const AddItemFailure('x')),
      );
    });
  });
}

