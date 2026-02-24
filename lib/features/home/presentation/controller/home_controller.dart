import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/security/vault/vault_service.dart';
import 'package:lockpass/core/services/pin_service.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/home/presentation/enums/home_tab_enum.dart';
import 'package:lockpass/features/home/presentation/state/home_event.dart';
import 'package:lockpass/features/home/presentation/state/home_state.dart';
import 'package:lockpass/features/home/presentation/state/home_status.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_enum.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';
import 'package:lockpass/core/services/auth_service.dart';

class HomeController extends Cubit<HomeState> {
  final VaultService _vaultService;
  final AuthService _authService;
  final PinService _pinService;
  final ItensRepository _itensRepository;
  final SharedPreferencesDatasource _prefs;

  HomeController({
    required VaultService vaultService,
    required AuthService authService,
    required PinService pinService,
    required ItensRepository itensRepository,
    required SharedPreferencesDatasource prefs,
  })  : _vaultService = vaultService,
        _authService = authService,
        _pinService = pinService,
        _itensRepository = itensRepository,
        _prefs = prefs,
        super(const HomeState());

  Future<void> init() async {
    emit(state.copyWith(
      status: const HomeLoading(),
      userEmail: _authService.currentUserEmail,
    ));

    await Future.wait([
      checkIfShouldShowPinAlert(),
      createAutomaticBackup(),
    ]);
    
    emit(state.copyWith(status: const HomeSuccess()));
  }

  String get _uid => _authService.currentUserId;

  Future<void> createAutomaticBackup() async {
    final itens = await _itensRepository.getActiveItensByUser(_uid);

    if (itens.isEmpty) {
      return;
    }

    await _vaultService.createAutomaticBackup();
  }

  Future<void> checkIfShouldShowPinAlert() async {
    final hideAlert = _prefs.getHideCreatePinAlert();

    if (hideAlert) return;

    final hasPin = await _pinService.hasPin(_uid);

    if (!hasPin) {
      emit(state.copyWith(event: const ShowPinDialogEvent()));
    }
  }

  Future<void> setHideCreatePinInfo(bool check) async {
    await _prefs.setHideCreatePinAlert(check);
  }

  void clearEvent() {
    emit(state.copyWith(event: null));
  }

  void onItemTapped(int index) {
    final tab = _mapIndexToTab(index);
    if (tab == HomeTab.list) {
      final nextView = state.viewMode == ListViewEnum.list
          ? ListViewEnum.grouped
          : ListViewEnum.list;
      // getData();
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

    return groupedItems.keys
        .map((group) => GroupsEntity(groupName: group))
        .toList();
  }
}
