import 'package:lockpass/features/home/presentation/enums/home_tab_enum.dart';
import 'package:lockpass/features/home/presentation/state/home_event.dart';
import 'package:lockpass/features/home/presentation/state/home_status.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_enum.dart';

class HomeState {
  final HomeStatus status;
  final HomeEvent? event;
  final HomeTab currentTab;
  final ListViewEnum viewMode;
  final int selectedIndex;
  final String? userEmail;

  const HomeState({
    this.status = const HomeInitial(),
    this.event,
    this.currentTab = HomeTab.list,
    this.viewMode = ListViewEnum.list,
    this.selectedIndex = 0,
    this.userEmail,
  });

  HomeState copyWith({
    HomeStatus? status,
    HomeEvent? event,
    HomeTab? currentTab,
    ListViewEnum? viewMode,
    int? selectedIndex,
    String? userEmail,
  }) {
    return HomeState(
      status: status ?? this.status,
      event: event,
      currentTab: currentTab ?? this.currentTab,
      viewMode: viewMode ?? this.viewMode,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}