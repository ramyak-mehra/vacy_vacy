import 'dart:convert';
import 'dart:developer';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class CalendarClient {
  static const _scopes = const [CalendarApi.calendarScope];
  http.Client client;

  AuthClient calendarClient;
  AccessCredentials credentials;
  Future<void> singIn() async {
    var _clientId = ClientId(
        "717000687325-0amcnkd1eufjcb80maohl91bau8o385o.apps.googleusercontent.com",
        "");
    if (kIsWeb) {
      var _clientID = ClientId(
          "717000687325-4e5co1nb94r4dca0hldse3jlu79jp9ru.apps.googleusercontent.com",
          null);

      final flow = await createImplicitBrowserFlow(_clientID, _scopes);
      credentials = await flow.obtainAccessCredentialsViaUserConsent();
    } else {
      credentials = await obtainAccessCredentialsViaUserConsent(
          _clientId, _scopes, client, prompt);
    }
  }

  CalendarClient() {
    client = http.Client();
  }
  Future getFreeData(String startTime, String endTime) async {
    calendarClient = authenticatedClient(client, credentials);
    var calendar = CalendarApi(calendarClient);

    var result = await calendar.freebusy.query(FreeBusyRequest.fromJson({
      "timeMin": startTime,
      "timeMax": endTime,
      "groupExpansionMax": 50,
      "calendarExpansionMax": 50,
      "items": [
        {"id": "primary"}
      ]
    }));
    return result.calendars['primary'].toJson();
  }

  Future<bool> addEvent(
      String title, DateTime startTime, DateTime endTime) async {
    calendarClient = authenticatedClient(client, credentials);

    var calendar = CalendarApi(calendarClient);
    calendar.calendarList.list();
    String calendarId = "primary";
    Event event = Event(); // Create object of event

    event.summary = title;

    EventDateTime start = new EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:00";
    event.start = start;

    EventDateTime end = new EventDateTime();
    end.timeZone = "GMT+05:00";
    end.dateTime = endTime;
    event.end = end;
    try {
      final value = await calendar.events.insert(event, calendarId);
      if (value.status == "confirmed") {
        log('Event added in google calendar');
        return true;
      } else {
        log("Unable to add event in google calendar");
        return false;
      }
    } catch (e) {
      log('Error creating event $e');
    }
    return Future.value(false);
  }

  void prompt(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
