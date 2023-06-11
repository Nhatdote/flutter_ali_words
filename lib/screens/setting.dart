import 'package:flutter/material.dart';
import 'package:flutter_ali_words/utils/db.dart';
import 'package:flutter_ali_words/utils/style.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  late double slideValue = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int value = DB.prefs.getInt(DB.perPage) ?? 5;
    
    setState(() {
      slideValue = value.toDouble();
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppStyle.secondColor,
      appBar: AppBar(
        backgroundColor: AppStyle.secondColor,
        elevation: 0,
        leading: InkWell(
          onTap: () async {
            await DB.prefs.setInt(DB.perPage, slideValue.toInt());
            Navigator.pop(scaffoldKey.currentContext ?? context, slideValue);
          },
          child: const Icon(Icons.navigate_before_rounded,
            color: AppStyle.textColor, size: 38
          ),
        ),
        title: Text('Settings',
            textAlign: TextAlign.left,
            style: AppStyle.h3.copyWith(
              color: AppStyle.textColor,
        )),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text('How much a number word at once?', 
                style: AppStyle.h5.copyWith(color: AppStyle.textGrey)
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text('${slideValue.toInt()}', style: AppStyle.h1.copyWith(color: AppStyle.primaryColor, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    onChanged: (double value) { 
                      setState(() {
                        slideValue = value.ceil().toDouble();
                      });
                    },
                    activeColor: AppStyle.primaryColor,
                    inactiveColor: AppStyle.primaryColor,
                    thumbColor: Colors.white,
                    label: slideValue.toInt().toString(),
                    divisions: 4,
                    value: slideValue,
                    max: 25,
                    min: 5,
                  ),
                  const Padding(
                    padding:  EdgeInsets.only(left: 24),
                    child:  Text('Slide to set', style: TextStyle(color: AppStyle.textGrey),),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}