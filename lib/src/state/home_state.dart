import '../model/home_model.dart';

abstract class HomeState {
  void refreshData(HomeModel homeModel);
  void onSuccess(String success);
  void onError(String error);
}
