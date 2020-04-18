import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'services/calendar/event_item.dart';

class CalendarEventsPage extends StatefulWidget {
  final List<Event> _events;
  final Calendar _selectedCalendar;

  CalendarEventsPage(this._events, this._selectedCalendar, {Key key})
      : super(key: key);

  @override
  _CalendarEventsPageState createState() {
    return _CalendarEventsPageState(_events, _selectedCalendar);
  }
}

class _CalendarEventsPageState extends State<CalendarEventsPage> {
  final List<Event> _calendarEvents;
  final Calendar _calendar;
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();

  DeviceCalendarPlugin _deviceCalendarPlugin;

  _CalendarEventsPageState(this._calendarEvents, this._calendar) {
    _deviceCalendarPlugin = DeviceCalendarPlugin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      body: (_calendarEvents?.isNotEmpty ?? false)
          ? Stack(
              children: [
                ListView.builder(
                  itemCount: _calendarEvents?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return EventItem(_calendarEvents[index],
                        _deviceCalendarPlugin, _onTapped, _calendar.isReadOnly);
                  },
                ),
              ],
            )
          : Center(child: Text('No events found')),
    );
  }

  Future _onTapped(Event event) async {}
}
