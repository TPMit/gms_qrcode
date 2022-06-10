import '../model/activity_model.dart';


abstract class ActivityState {
  void refreshData(ActivityModel activityModel);
  void onSuccess(String success);
  void onError(String error);
}
