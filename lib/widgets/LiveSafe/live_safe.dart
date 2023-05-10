import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lady_rakshak/widgets/HomeWidgets/Live_safe/HospitalCard.dart';
import 'package:url_launcher/url_launcher.dart';
import '../HomeWidgets/Live_safe/BusStationCard.dart';
import '../HomeWidgets/Live_safe/PharmacyCard.dart';
import '../HomeWidgets/Live_safe/PoliceStationCard.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({Key? key}) : super(key: key);

  static Future<void> getMap(String location) async {
    String googleUrl = 'https://www.google.com/maps/search/$location';
    final Uri _url = Uri.parse(googleUrl);
    try {
      await launchUrl(_url);
    } catch (e) {
      Fluttertoast.showToast(msg: "some error, pls try later");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceStationCard(onMapFunction: getMap),
          HospitalCard(onMapFunction: getMap),
          BusStationCard(onMapFunction: getMap),
          PharmacyCard(onMapFunction: getMap),
        ],
      ),
    );
  }
}
