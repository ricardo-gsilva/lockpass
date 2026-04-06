import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/features/home/domain/usecases/check_if_should_show_pin_alert_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/create_automatic_backup_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/get_current_user_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/set_hide_create_pin_usecase.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/home/presentation/enums/home_tab_enum.dart';
import 'package:lockpass/features/home/presentation/state/home_event.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/features/home/presentation/state/home_status.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_enum.dart';
import 'package:mocktail/mocktail.dart';

class _MockCheckIfShouldShowPinAlertUseCase extends Mock
    implements CheckIfShouldShowPinAlertUseCase {}

class _MockCreateAutomaticBackupUseCase extends Mock
    implements CreateAutomaticBackupUseCase {}

class _MockSetHideCreatePinAlertUseCase extends Mock
    implements SetHideCreatePinAlertUseCase {}

class _MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  late _MockCheckIfShouldShowPinAlertUseCase checkIfShouldShowPinAlertUseCase;
  late _MockCreateAutomaticBackupUseCase createAutomaticBackupUseCase;
  late _MockSetHideCreatePinAlertUseCase setHideCreatePinAlertUseCase;
  late _MockGetCurrentUserUseCase getCurrentUserUseCase;

  HomeController buildController() {
    return HomeController(
      checkIfShouldShowPinAlertUseCase: checkIfShouldShowPinAlertUseCase,
      createAutomaticBackupUseCase: createAutomaticBackupUseCase,
      setHideCreatePinAlertUseCase: setHideCreatePinAlertUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
    );
  }

  setUp(() {
    checkIfShouldShowPinAlertUseCase = _MockCheckIfShouldShowPinAlertUseCase();
    createAutomaticBackupUseCase = _MockCreateAutomaticBackupUseCase();
    setHideCreatePinAlertUseCase = _MockSetHideCreatePinAlertUseCase();
    getCurrentUserUseCase = _MockGetCurrentUserUseCase();

    when(() => getCurrentUserUseCase.uid).thenReturn('uid123');
    when(() => getCurrentUserUseCase.email).thenReturn('a@b.com');

    when(() => createAutomaticBackupUseCase.call(any())).thenAnswer((_) async {});
    when(() => checkIfShouldShowPinAlertUseCase.call(any()))
        .thenAnswer((_) async => false);
  });

  group('HomeController', () {
    blocTest<HomeController, HomeState>(
      'init emits loading then success',
      build: buildController,
      act: (cubit) => cubit.init(),
      expect: () => const [
        HomeState(
          status: HomeLoading(),
          userEmail: 'a@b.com',
        ),
        HomeState(
          status: HomeSuccess(),
          userEmail: 'a@b.com',
        ),
      ],
      verify: (_) {
        verify(() => createAutomaticBackupUseCase.call('uid123')).called(1);
        verify(() => checkIfShouldShowPinAlertUseCase.call('uid123')).called(1);
      },
    );

    blocTest<HomeController, HomeState>(
      'checkIfShouldShowPinAlert emits ShowPinDialogEvent when use case returns true',
      build: () {
        when(() => checkIfShouldShowPinAlertUseCase.call('uid123'))
            .thenAnswer((_) async => true);
        return buildController();
      },
      act: (cubit) => cubit.checkIfShouldShowPinAlert('uid123'),
      expect: () => const [
        HomeState(event: ShowPinDialogEvent()),
      ],
    );

    blocTest<HomeController, HomeState>(
      'clearEvent clears event',
      build: buildController,
      seed: () => const HomeState(event: ShowPinDialogEvent()),
      act: (cubit) => cubit.clearEvent(),
      expect: () => const [
        HomeState(event: null),
      ],
    );

    blocTest<HomeController, HomeState>(
      'onItemTapped toggles viewMode when staying on list tab',
      build: buildController,
      act: (cubit) {
        cubit.onItemTapped(0);
        cubit.onItemTapped(0);
      },
      expect: () => const [
        HomeState(
          currentTab: HomeTab.list,
          selectedIndex: 0,
          viewMode: ListViewEnum.grouped,
        ),
        HomeState(
          currentTab: HomeTab.list,
          selectedIndex: 0,
          viewMode: ListViewEnum.list,
        ),
      ],
    );

    blocTest<HomeController, HomeState>(
      'onItemTapped sets grouped view when moving to other tabs',
      build: buildController,
      act: (cubit) {
        cubit.onItemTapped(1);
        cubit.onItemTapped(2);
      },
      expect: () => const [
        HomeState(
          currentTab: HomeTab.add,
          selectedIndex: 1,
          viewMode: ListViewEnum.grouped,
        ),
        HomeState(
          currentTab: HomeTab.config,
          selectedIndex: 2,
          viewMode: ListViewEnum.grouped,
        ),
      ],
    );

    test('setHideCreatePinInfo delegates to use case', () async {
      final controller = buildController();
      addTearDown(controller.close);

      when(() => setHideCreatePinAlertUseCase.call(true))
          .thenAnswer((_) async {});

      await controller.setHideCreatePinInfo(true);

      verify(() => setHideCreatePinAlertUseCase.call(true)).called(1);
    });
  });
}

