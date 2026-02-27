import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/features/home/domain/usecases/check_if_should_show_pin_alert_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/create_automatic_backup_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/get_current_user_usecase.dart';
import 'package:lockpass/features/home/domain/usecases/set_hide_create_pin_usecase.dart';
import 'package:lockpass/features/home/presentation/enums/home_tab_enum.dart';
import 'package:lockpass/features/home/presentation/state/home_event.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/features/home/presentation/state/home_status.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_enum.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';

class HomeController extends Cubit<HomeState> {
  final CheckIfShouldShowPinAlertUseCase _checkIfShouldShowPinAlertUseCase;
  final CreateAutomaticBackupUseCase _createAutomaticBackupUseCase;
  final SetHideCreatePinAlertUseCase _setHideCreatePinAlertUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  HomeController({
    required CheckIfShouldShowPinAlertUseCase checkIfShouldShowPinAlertUseCase,
    required CreateAutomaticBackupUseCase createAutomaticBackupUseCase,
    required SetHideCreatePinAlertUseCase setHideCreatePinAlertUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  :_checkIfShouldShowPinAlertUseCase = checkIfShouldShowPinAlertUseCase,
        _createAutomaticBackupUseCase = createAutomaticBackupUseCase,
        _setHideCreatePinAlertUseCase = setHideCreatePinAlertUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(const HomeState());

  Future<void> init() async {
    emit(state.copyWith(
      status: const HomeLoading(),
      userEmail: _getCurrentUserUseCase.email,
    ));

    final uid = _getCurrentUserUseCase.uid;

    await Future.wait([
      checkIfShouldShowPinAlert(uid),
      createAutomaticBackup(),
    ]);

    emit(state.copyWith(status: const HomeSuccess()));
  }

  Future<void> createAutomaticBackup() async {
    final uid = _getCurrentUserUseCase.uid;
    await _createAutomaticBackupUseCase(uid);
  }

  Future<void> checkIfShouldShowPinAlert(String uid) async {
    final shouldShow = await _checkIfShouldShowPinAlertUseCase(uid);

    if (shouldShow) {
      emit(state.copyWith(event: const ShowPinDialogEvent()));
    }
  }

  Future<void> setHideCreatePinInfo(bool check) async {
    await _setHideCreatePinAlertUseCase(check);
  }

  void clearEvent() {
    emit(state.copyWith(event: null));
  }

  void onItemTapped(int index) {
    final tab = _mapIndexToTab(index);
    if (tab == HomeTab.list) {
      final nextView = state.viewMode == ListViewEnum.list ? ListViewEnum.grouped : ListViewEnum.list;
      emit(state.copyWith(
        currentTab: tab,
        selectedIndex: index,
        viewMode: nextView,
      ));
    } else {
      final view = ListViewEnum.grouped;
      emit(state.copyWith(
        currentTab: tab,
        selectedIndex: index,
        viewMode: view,
      ));
    }
  }

  HomeTab _mapIndexToTab(int index) {
    switch (index) {
      case 0:
        return HomeTab.list;
      case 1:
        return HomeTab.add;
      case 2:
        return HomeTab.config;
      default:
        return HomeTab.list;
    }
  }

  List<GroupsEntity> buildTypesFromFiltered(List<ItensEntity> items) {
    final groupedItems = <String, List<ItensEntity>>{};

    for (final item in items) {
      final key = item.group;
      groupedItems.putIfAbsent(key, () => []).add(item);
    }

    return groupedItems.keys.map((group) => GroupsEntity(groupName: group)).toList();
  }
}
