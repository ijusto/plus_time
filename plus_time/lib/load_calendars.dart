import 'package:device_calendar/device_calendar.dart';

List<Calendar> calendars;
List<String> calendarsNames = [];

DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

retriveCalendars() async {
  try {
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();

    if (permissionsGranted.isSuccess && !permissionsGranted.data) {
      permissionsGranted = await _deviceCalendarPlugin.requestPermissions();

      if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
        return;
      }
    }

    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    calendars = calendarsResult?.data;

    for (int c = 0; c < calendars.length; c++) {
      calendarsNames.add(calendars[c].name);
    }

    print(calendarsNames);
  } catch (e) {
    print(e);
  }
}
