import 'package:background_fetch/background_fetch.dart';
import 'package:nightview/constants/values.dart';

class BackgroundServiceHelper {
  final GeneralAsyncCallback<String> onReceive;
  final GeneralAsyncCallback<String> onTimeout;

  BackgroundServiceHelper({
    required this.onReceive,
    required this.onTimeout,
  }) {
    print('INITIALIZING BACKGROUND SERVICE');

    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: true,
          enableHeadless: false,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ), (String taskId) async {
      // EVENT HANDLER
      print('BACKGROUND EVENT: $taskId');
      await onReceive(taskId);
      BackgroundFetch.finish(taskId);

    }, (String taskId) async {
      // TIMEOUT HANDLER
      print('BACKGROUND EVENT TIMEOUT: $taskId');
      await onTimeout(taskId);
      BackgroundFetch.finish(taskId);

    });
  }
}
