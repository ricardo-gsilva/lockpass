import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/add_item/domain/usecases/create_item_usecase.dart';
import 'package:lockpass/features/add_item/domain/usecases/load_item_groups_usecase.dart';
import 'package:lockpass/features/add_item/presentation/controller/add_item_controller.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_state.dart';
import 'package:lockpass/features/add_item/presentation/state/add_item_status.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreateItemUseCase extends Mock implements CreateItemUseCase {}

class _MockLoadItemGroupsUseCase extends Mock implements LoadItemGroupsUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ItensEntity(
        userId: '',
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      ),
    );
    registerFallbackValue(<String>[]);
  });

  late _MockCreateItemUseCase createItemUseCase;
  late _MockLoadItemGroupsUseCase loadItemGroupsUseCase;

  AddItemController buildController({
    Duration minSubmitDuration = Duration.zero,
    AddItemDelayFn? delay,
  }) {
    return AddItemController(
      createItemUseCase: createItemUseCase,
      loadItemGroupsUseCase: loadItemGroupsUseCase,
      minSubmitDuration: minSubmitDuration,
      delay: delay ?? ((_) async {}),
    );
  }

  setUp(() {
    createItemUseCase = _MockCreateItemUseCase();
    loadItemGroupsUseCase = _MockLoadItemGroupsUseCase();
  });

  group('AddItemController', () {
    blocTest<AddItemController, AddItemState>(
      'onFormChanged updates isFormValid only when it changes',
      build: buildController,
      act: (cubit) {
        cubit.onFormChanged(group: '', service: 's', login: 'l', password: 'p');
        cubit.onFormChanged(group: 'g', service: 's', login: 'l', password: 'p');
        cubit.onFormChanged(group: 'g', service: 's', login: 'l', password: 'p');
      },
      expect: () => const [
        AddItemState(isFormValid: true),
      ],
    );

    blocTest<AddItemController, AddItemState>(
      'submit emits failure when required fields are blank',
      build: buildController,
      act: (cubit) => cubit.submit(
        const ItensEntity(
          userId: '',
          group: '',
          service: '',
          login: 'l',
          password: 'p',
        ),
      ),
      expect: () => const [
        AddItemState(status: AddItemFailure(CoreStrings.manyEmptyFields)),
      ],
      verify: (_) {
        verifyNever(() => createItemUseCase.call(any(), any()));
      },
    );

    blocTest<AddItemController, AddItemState>(
      'submit emits loading then success when use case succeeds',
      build: () {
        when(() => createItemUseCase.call(any(), any())).thenAnswer((_) async {});
        return buildController(minSubmitDuration: Duration.zero);
      },
      act: (cubit) => cubit.submit(
        const ItensEntity(
          userId: '',
          group: 'g',
          service: 's',
          login: 'l',
          password: 'p',
        ),
      ),
      expect: () => const [
        AddItemState(status: AddItemLoading()),
        AddItemState(status: AddItemSuccess()),
      ],
    );

    blocTest<AddItemController, AddItemState>(
      'submit maps AuthErrorType to failure message',
      build: () {
        when(() => createItemUseCase.call(any(), any()))
            .thenThrow(AuthErrorType.requiresRecentLogin);
        return buildController(minSubmitDuration: Duration.zero);
      },
      act: (cubit) => cubit.submit(
        const ItensEntity(
          userId: '',
          group: 'g',
          service: 's',
          login: 'l',
          password: 'p',
        ),
      ),
      expect: () => [
        const AddItemState(status: AddItemLoading()),
        AddItemState(
          status: AddItemFailure(AuthErrorType.requiresRecentLogin.message),
        ),
      ],
    );

    blocTest<AddItemController, AddItemState>(
      'submit emits saveItemError when use case throws non-security error',
      build: () {
        when(() => createItemUseCase.call(any(), any()))
            .thenThrow(Exception('boom'));
        return buildController(minSubmitDuration: Duration.zero);
      },
      act: (cubit) => cubit.submit(
        const ItensEntity(
          userId: '',
          group: 'g',
          service: 's',
          login: 'l',
          password: 'p',
        ),
      ),
      expect: () => const [
        AddItemState(status: AddItemLoading()),
        AddItemState(status: AddItemFailure(CoreStrings.saveItemError)),
      ],
    );

    blocTest<AddItemController, AddItemState>(
      'submit emits dataProtectionError when exception contains SECURITY_FAILURE',
      build: () {
        when(() => createItemUseCase.call(any(), any()))
            .thenThrow(Exception('SECURITY_FAILURE'));
        return buildController(minSubmitDuration: Duration.zero);
      },
      act: (cubit) => cubit.submit(
        const ItensEntity(
          userId: '',
          group: 'g',
          service: 's',
          login: 'l',
          password: 'p',
        ),
      ),
      expect: () => const [
        AddItemState(status: AddItemLoading()),
        AddItemState(status: AddItemFailure(CoreStrings.dataProtectionError)),
      ],
    );

    blocTest<AddItemController, AddItemState>(
      'setDropDownGroups emits new list when it changes',
      build: () {
        when(() => loadItemGroupsUseCase.call()).thenAnswer((_) async => ['a']);
        return buildController();
      },
      act: (cubit) => cubit.setDropDownGroups(),
      expect: () => [
        AddItemState(listItensDrop: ['a']),
      ],
      verify: (_) {
        verify(() => loadItemGroupsUseCase.call()).called(1);
      },
    );

    blocTest<AddItemController, AddItemState>(
      'setDropDownGroups does not emit when list is unchanged',
      build: () {
        when(() => loadItemGroupsUseCase.call()).thenAnswer((_) async => ['a']);
        return buildController();
      },
      seed: () => AddItemState(listItensDrop: ['a']),
      act: (cubit) => cubit.setDropDownGroups(),
      expect: () => const <AddItemState>[],
    );

    test('submit calls delay when minSubmitDuration > 0', () async {
      when(() => createItemUseCase.call(any(), any())).thenAnswer((_) async {});

      final delays = <Duration>[];
      final controller = buildController(
        minSubmitDuration: const Duration(milliseconds: 100),
        delay: (duration) async => delays.add(duration),
      );
      addTearDown(controller.close);

      await controller.submit(
        const ItensEntity(
          userId: '',
          group: 'g',
          service: 's',
          login: 'l',
          password: 'p',
        ),
      );

      expect(delays, hasLength(1));
      expect(delays.single, greaterThan(Duration.zero));
      expect(delays.single, lessThanOrEqualTo(const Duration(milliseconds: 100)));
    });
  });
}
