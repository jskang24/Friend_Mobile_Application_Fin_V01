import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeScreenStore = _HomeScreenStoreBase with _$HomeScreenStore;

abstract class _HomeScreenStoreBase with Store {
  @observable
  int homeIndex = 0;

  @action
  void updateHomeIndex(int _index) {
    homeIndex = _index;
  }
}
