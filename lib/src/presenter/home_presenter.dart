import '../model/home_model.dart';
import '../state/home_state.dart';

abstract class HomePresenterAbstract {
  set view(HomeState view) {}
}

class HomePresenter implements HomePresenterAbstract {
  final HomeModel _homeModel = HomeModel();
  late HomeState _homeState;
  
  @override
  set view(HomeState view) {
    _homeState = view;
    _homeState.refreshData(_homeModel);
  }
  
}
