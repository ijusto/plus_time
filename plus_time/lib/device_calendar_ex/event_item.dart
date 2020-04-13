import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:plus_time/generate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import 'RecurringEventDialog.dart';

class EventItem extends StatelessWidget {
  final Event _calendarEvent;
  final DeviceCalendarPlugin _deviceCalendarPlugin;
  final bool _isReadOnly;

  final Function(Event) _onTapped;
  final VoidCallback _onLoadingStarted;
  final Function(bool) _onDeleteFinished;

  final double _eventFieldNameWidth = 75.0;

  EventItem(
      this._calendarEvent,
      this._deviceCalendarPlugin,
      this._onLoadingStarted,
      this._onDeleteFinished,
      this._onTapped,
      this._isReadOnly);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onTapped(_calendarEvent);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            ListTile(
                title: Text(_calendarEvent.title ?? ''),
                subtitle: Text(_calendarEvent.description ?? '')),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('Starts'),
                        ),
                        Text(_calendarEvent == null
                            ? ''
                            : DateFormat.yMd()
                                .add_jm()
                                .format(_calendarEvent.start)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('Ends'),
                        ),
                        Text(_calendarEvent.end == null
                            ? ''
                            : DateFormat.yMd()
                                .add_jm()
                                .format(_calendarEvent.end)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('All day?'),
                        ),
                        Text(_calendarEvent.allDay != null &&
                                _calendarEvent.allDay
                            ? 'Yes'
                            : 'No')
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('Location'),
                        ),
                        Expanded(
                          child: Text(
                            _calendarEvent?.location ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('URL'),
                        ),
                        Expanded(
                          child: Text(
                            _calendarEvent?.url?.data?.contentText ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: _eventFieldNameWidth,
                          child: Text('Attendees'),
                        ),
                        Expanded(
                          child: Text(
                            _calendarEvent?.attendees
                                    ?.where((a) => a.name?.isNotEmpty ?? false)
                                    ?.map((a) => a.name)
                                    ?.join(', ') ??
                                '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ButtonBar(
              children: [
                IconButton(
                    onPressed: () {
                      createAlertDialog(context);
                    },
                    icon: Icon(Icons.share)),
                /*if (!_isReadOnly) ...[
                  IconButton(
                    onPressed: () {
                      _onTapped(_calendarEvent);
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () async {
                      await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            if (_calendarEvent.recurrenceRule == null) {
                              return AlertDialog(
                                title: Text(
                                    'Are you sure you want to delete this event?'),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      _onLoadingStarted();
                                      final deleteResult =
                                          await _deviceCalendarPlugin
                                              .deleteEvent(
                                                  _calendarEvent.calendarId,
                                                  _calendarEvent.eventId);
                                      _onDeleteFinished(
                                          deleteResult.isSuccess &&
                                              deleteResult.data);
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            } else {
                              return RecurringEventDialog(
                                  _deviceCalendarPlugin,
                                  _calendarEvent,
                                  _onLoadingStarted,
                                  _onDeleteFinished);
                            }
                          });
                    },
                    icon: Icon(Icons.delete),
                  ),
                ] else ...[
                  IconButton(
                    onPressed: () {
                      _onTapped(_calendarEvent);
                    },
                    icon: Icon(Icons.remove_red_eye),
                  ),
                ]*/
              ],
            )
          ],
        ),
      ),
    );
  }

  Future createAlertDialog(BuildContext context) {
    var eventData = {};
    eventData["allDay"] = _calendarEvent.allDay;
    eventData["attendees"] = _calendarEvent.attendees;
    eventData["calendarId"] = _calendarEvent.calendarId;
    eventData["description"] = _calendarEvent.description;
    eventData["end"] = _calendarEvent.end.toIso8601String();
    eventData["eventId"] = _calendarEvent.eventId;
    eventData["location"] = _calendarEvent.location;
    eventData["recurrenceRule"] = _calendarEvent.recurrenceRule;
    eventData["reminders"] = _calendarEvent.reminders;
    eventData["start"] = _calendarEvent.start.toIso8601String();
    eventData["title"] = _calendarEvent.title;
    eventData["url"] = _calendarEvent.url;
    String jsonEventData = json.encode(eventData);
    print("\nEncode JSON:\n");
    print(jsonEventData);

    print("\nDecode JSON:\n");
    print(json.decode(jsonEventData));
    return showDialog(
        context: context,
        builder: (context) {
          GlobalKey globalKey = new GlobalKey();
          return AlertDialog(
              title: Text("Do you want to share this event?"),
              content: _contentWidget(context, globalKey, jsonEventData),
              actions: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  onPressed: () async {
                    await _captureAndSharePng(globalKey);
                  },
                  child: Text("Yes"),
                ),
                MaterialButton(
                    elevation: 5.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"))
              ]);
        });
  }

  //------------------------------------------------------------------------

  Future<void> _captureAndSharePng(GlobalKey globalKey) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      //Uint8List pngBytes = byteData.buffer.asUint8List();
      String fp = await _writeByteToImageFile(byteData);
      ShareExtend.share(fp, "image");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> _writeByteToImageFile(ByteData byteData) async {
    Directory dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    File imageFile = new File(
        "${dir.path}/flutter/${DateTime.now().millisecondsSinceEpoch}.png");
    imageFile.createSync(recursive: true);
    imageFile.writeAsBytesSync(byteData.buffer.asUint8List(0));
    return imageFile.path;
  }

  _contentWidget(BuildContext context, GlobalKey globalKey, String eventData) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      width: 100,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: eventData,
                  size: 0.5 * bodyHeight,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
