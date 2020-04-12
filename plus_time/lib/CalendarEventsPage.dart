import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'device_calendar_ex/event_item.dart';

import 'CalendarEventPage.dart';
import 'device_calendar_ex/RecurringEventDialog.dart';

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
  bool _isLoading = true;

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
                      return EventItem(
                          _calendarEvents[index],
                          _deviceCalendarPlugin,
                          _onLoading,
                          _onDeletedFinished,
                          _onTapped,
                          _calendar.isReadOnly);
                    },
                  ),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              )
            : Center(child: Text('No events found')),
        floatingActionButton: _getAddEventButton(context));
  }

  Widget _getAddEventButton(BuildContext context) {
    if (!_calendar.isReadOnly) {
      return FloatingActionButton(
        key: Key('addEventButton'),
        onPressed: () async {
          final refreshEvents = await Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return CalendarEventPage(_calendar);
          }));
          //if (refreshEvents == true) {
          //  await _retrieveCalendarEvents();
          //}
        },
        child: Icon(Icons.add),
      );
    } else {
      return null;
    }
  }

  void _onLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  Future _onDeletedFinished(bool deleteSucceeded) async {
    if (deleteSucceeded) {
      //await _retrieveCalendarEvents();
    } else {
      _scaffoldstate.currentState.showSnackBar(SnackBar(
        content: Text('Oops, we ran into an issue deleting the event'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _onTapped(Event event) async {}
}
