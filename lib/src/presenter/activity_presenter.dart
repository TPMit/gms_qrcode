import 'package:gms_mobile/src/model/activity_model.dart';
import 'package:gms_mobile/src/resources/activityApi.dart';

import '../state/activity_state.dart';

abstract class ActivityPresenterAbstract {
  set view(ActivityState view) {}
  void getData(){}
}

class ActivityPresenter implements ActivityPresenterAbstract {
  final ActivityModel _activityModel = ActivityModel();
  late ActivityState _activityState;
  final ActivityServices _activityServices = ActivityServices();

  @override
  set view(ActivityState view) {
    _activityState = view;
    _activityState.refreshData(_activityModel);
  }

  @override
  void getData() {
    _activityModel.isloading = true;
    _activityState.refreshData(_activityModel);
    _activityServices.getData().then((value) {
      value.dataActivity!.forEach((element) {
        _activityModel.activity.add(Activity(
          activity: element.activity!,
          dateTime: element.dateTime!,
          images: element.images!,
          name: element.name!
        ));
        _activityState.onSuccess("loading selesai");
        _activityModel.isloading = false;
        _activityState.refreshData(_activityModel);
       });
    }).catchError((error){
      _activityState.onError(error);
      _activityModel.isloading = false;
      _activityState.refreshData(_activityModel);
    });
  }

  
}