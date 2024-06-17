import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nightview/models/location_helper.dart';

late LocationHelper locationHelper;
const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == fetchBackground) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
locationHelper.startBackgroundLocationService(); // TODO use globalprovider??
      // Perform your background task here (e.g., upload location to server)
      print("Background Location: ${position.latitude}, ${position.longitude}");
    }
    return Future.value(true);
  });
}

void initializeWorkManager() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false, // Change to false when releasing TODO
  );
}

void registerPeriodicTask() {
  Workmanager().registerPeriodicTask(
    "1",
    fetchBackground,
    frequency: const Duration(minutes:20), // Change the frequency as needed
  );
}
