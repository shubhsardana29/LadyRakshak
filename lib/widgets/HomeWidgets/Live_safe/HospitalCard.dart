import 'package:flutter/material.dart';

class HospitalCard extends StatelessWidget {
  final Function? onMapFunction;
  const HospitalCard({Key? key,this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:25.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onMapFunction!("Hospitals near Me");
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height:50,
                width:50,
                child:Center(
                  child: Image.asset('assets/hospital.png',height: 32,),
                ),
              ),
            ),
          ),
          Text("Hospitals")
        ],
      ),
    );
  }
}