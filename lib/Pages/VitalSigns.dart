import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icare/Pages/add_symptoms.dart';
import 'package:icare/Pages/select_vitalsigns.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import '../Widgets/indicator.dart';
import 'package:icare/Pages/review_vitalsigns.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';


class VitalSignsPage extends StatefulWidget {
  final VitalSignsStorage storage;

  VitalSignsPage({Key? key, required this.storage}) : super(key: key);
  @override
  _VitalSignsPageState createState() => _VitalSignsPageState();
}

class _VitalSignsPageState extends State<VitalSignsPage>  {

  int touchedIndex = -1;

  final verticalScroll = ScrollController();
  var LanguageData =0;
  var Title = ["Vital Signs","العلامات الحيوية",""];
  var SelectTitle = ["Select Vital Signs","حدد العلامات الحيوية",""];
  var LeastOneTitle = ["Select at least one vital sign","حدد علامة حيوية واحدة على الأقل",""];
  var Sign1Title = ["Vital Sign 1","علامة حيوية 1",""];
  var Sign2Title = ["Vital Sign 2","علامة حيوية 2",""];
  var Sign3Title = ["Vital Sign 3","علامة حيوية 3",""];
  var VitalTitle = ["Vital Sign","العلامة الحيوية",""];
  var RateTitle = ["Rate","المعدل",""];
  var SaveBtnTitle = ["Save","حفظ",""];
  var NoSelectedTitle = ["Save Failed,\nSelect at least one vital sign.","فشل الحفظ ,"+"\n"+"حدد علامة حيوية واحدة على الأقل.",""];
  var SaveFailedTitle = ["Save Failed, Check Required Info.","فشل الحفظ ، تحقق من المعلومات المطلوبة.",""];
  var SaveSuccessTitle = ["Successfully Saved \n Review selected vital signs","تم الحفظ بنجاح "+"\n"+"راجع العلامات الحيوية المحددة",""];
  var AddNewTitle = ["+ Add new","+ اضافة",""];


  // BarChart
  final Color dark = const Color(0xff3b8c75);
  final Color normal = const Color(0xff64caad);
  final Color light = const Color(0xff73e8c9);

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff939393), fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = '01/05';
        break;
      case 1:
        text = '02/05';
        break;
      case 2:
        text = '04/05';
        break;
      case 3:
        text = '05/05';
        break;
      case 4:
        text = '06/05';
        break;
      default:
        text = '';
        break;
    }
    return Center(child: Text(text, style: style));
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      color: Color(
        0xff939393,
      ),
      fontSize: 10,
    );
    return Padding(
      child: Text(meta.formattedValue, style: style),
      padding: const EdgeInsets.only(left: 8),
    );
  }



  // LineChart
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;
  var VitalData, VitalSignsData, VitalReviewed, VitalSignsReviewed;

  @override
  void initState() {
    // TODO: implement initState
    widget.storage._readSettingsData("icare_Language").then((String value) async{
      if(value != "No Data" && value != "")
      {

        setState(() {
          LanguageData = int.parse(value);
        });

      }
      else
      {
        setState(() {
          LanguageData = 0;
        });
      }

    });

    widget.storage._readData("icare_vital_signs").then((String VitalValue) async{
      if(VitalValue != "No Data" && VitalValue != "")
      {
        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(VitalValue);
        if(lines.isNotEmpty) {
          int row = lines.length;
          int col = 7;
          VitalData = List.generate(
              row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result = lines[i].split('#');
            for (var j = 0; j < result.length; j++) {
              VitalData[i][j] = result[j];
            }
          }
          widget.storage._readData("icare_vital_review").then((String ReviewValue) async{
            if(ReviewValue != "No Data" && ReviewValue != "")
            {
              VitalReviewed = ReviewValue;
              if(ReviewValue == "false")
              {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) =>
                    Directionality( // use this
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                        child: ReviewVitalSigns(storage: ReviewVitalSignsStorage(),)),
                    )
                );
              }

            }
          });

          setState(() {
            VitalSignsData = VitalData;
            VitalSignsReviewed = VitalReviewed;
          });
          super.initState();
        }
      }
      else
      {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
            Directionality( // use this
                textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                child: SelectVitalSigns(storage: SelectVitalSignsStorage(),)),
            )
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      drawer: MainMenu(storage: MainMenuStorage()),
      appBar: AppBar(
        title: Text(Title[LanguageData],
          style: const TextStyle(
            color: Colors.white,),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color.fromRGBO(47, 150, 185, 1), Color.fromRGBO(84, 199, 212, 1),Color.fromRGBO(47, 150, 185, 1)])
          ),
        ),
        elevation: 0,

      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/grmain.png'),
                fit: BoxFit.fill
            )
        ),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),

        child: Scrollbar(
          isAlwaysShown: false,
          thickness: 0.0,
          //scrollbarOrientation: ScrollbarOrientation.bottom,
          controller: verticalScroll,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  scrollDirection: Axis.vertical,
                  controller: verticalScroll,
            child: VitalSignsData != null
              ?Column(
                children: [



        // Form Icon
        Container(
        padding: const EdgeInsets.only(top: 0.0),
        child: Container(
          height: 80,
          width: 80,
          color: Colors.transparent,
          child: SvgPicture.asset(
            'assets/svg/vitals.svg',
            width: 50,
            height: 50,
            alignment: AlignmentDirectional.center,
            // color: Colors.white,
            allowDrawingOutsideViewBox: false,
            // fit: BoxFit.cover,
          ),
        ),
      ),

              // VitalSigns Title and Add New
                  VitalSignsData[0][1].toString() != "" 
                      ?Card(
                color: const Color.fromRGBO(32, 116, 150, 1.0),
                shadowColor: Colors.grey,
                elevation: 4.0,
                margin: const EdgeInsets.only(top:15.0,left:0.0,bottom:0.0,right:0.0),
                child: ListTile(
                  title:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const SizedBox(width: 5.0),
                      Expanded(
                        // optional flex property if flex is 1 because the default flex is 1
                        flex: 2,
                        child:  Text("${VitalSignsData[0][1]}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,
                            // Color.fromRGBO(248, 95, 106, 1.0),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            //decoration: TextDecoration.underline,
                          ),
                        ) ,
                      ),
                      const SizedBox(width: 10.0),
                      // Profile Picture
                      Expanded(
                        // optional flex property if flex is 1 because the default flex is 1
                        flex: 1,
                        child:  Text(AddNewTitle[LanguageData],
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,
                            // Color.fromRGBO(248, 95, 106, 1.0),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            //decoration: TextDecoration.underline,
                          ),
                        ) ,
                      ),
                      const SizedBox(width: 5.0),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Directionality( // use this
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                        child: AddSymptoms(storage: AddSymptomsStorage(),)),),
                    );
                  },
                ),
              )
                      :const SizedBox(
                    height: 0.0,
                  ),

              // VitalSign PieChart
                  VitalSignsData[0][1].toString() != "" 
                      ?Container(
                margin: const EdgeInsets.only(top:5.0),
                padding: const EdgeInsets.only(top: 0.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.white,
                        Colors.white,
                      ]
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:   Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                ),

                child:AspectRatio(
                  aspectRatio: 1.3,

                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          height: 18,
                        ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                  pieTouchData: PieTouchData(touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection == null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  }),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingSections()),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Indicator(
                              color: Color(0xff0293ee),
                              text: '01/05',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Color(0xfff8b250),
                              text: '02/05',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Color(0xff845bef),
                              text: '04/05',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Color(0xff13d38e),
                              text: '05/05',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              )
                      :const SizedBox(
                    height: 0.0,
                  ),



              // VitalSigns Title and Add New
                  VitalSignsData[0][3].toString() != "" 
                      ?Card(
                color: const Color.fromRGBO(32, 116, 150, 1.0),
                shadowColor: Colors.grey,
                elevation: 4.0,
                margin: const EdgeInsets.only(top:15.0,left:0.0,bottom:0.0,right:0.0),
                child: ListTile(
                  title:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const SizedBox(width: 5.0),
                      Expanded(
                        // optional flex property if flex is 1 because the default flex is 1
                        flex: 2,
                        child:  Text("${VitalSignsData[0][3]}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,
                            // Color.fromRGBO(248, 95, 106, 1.0),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            //decoration: TextDecoration.underline,
                          ),
                        ) ,
                      ),
                      const SizedBox(width: 10.0),
                      // Profile Picture
                      Expanded(
                        // optional flex property if flex is 1 because the default flex is 1
                        flex: 1,
                        child:  Text(AddNewTitle[LanguageData],
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,
                            // Color.fromRGBO(248, 95, 106, 1.0),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            //decoration: TextDecoration.underline,
                          ),
                        ) ,
                      ),
                      const SizedBox(width: 5.0),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Directionality( // use this
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                        child: AddSymptoms(storage: AddSymptomsStorage(),)),),
                    );
                  },
                ),
              )
                      :const SizedBox(
                    height: 0.0,
                  ),

              // VitalSign LineChart
                  VitalSignsData[0][3].toString() != "" 
                      ?Container(
                margin: const EdgeInsets.only(top:5.0),
                padding: const EdgeInsets.only(top: 0.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.white,
                        Colors.white,
                      ]
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:   Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                ),

                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        //color: Color(0xff232d37)),
                      color: Colors.white),

                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 18.0, left: 12.0, top: 24, bottom: 12),
                      child: LineChart(
                        showAvg ? avgData() : mainData(),
                      ),
                    ),
                  ),
                ),

              )
                  :const SizedBox(
                height: 0.0,
              ),


              // VitalSigns Title and Add New
                  VitalSignsData[0][5].toString() != "" 
                      ?Card(
                color: const Color.fromRGBO(32, 116, 150, 1.0),
                shadowColor: Colors.grey,
                elevation: 4.0,
                margin: const EdgeInsets.only(top:15.0,left:0.0,bottom:0.0,right:0.0),
                child: ListTile(
                  title:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const SizedBox(width: 5.0),
                      Expanded(
                        // optional flex property if flex is 1 because the default flex is 1
                        flex: 2,
                        child:  Text("${VitalSignsData[0][5]}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,
                            // Color.fromRGBO(248, 95, 106, 1.0),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            //decoration: TextDecoration.underline,
                          ),
                        ) ,
                      ),
                      const SizedBox(width: 10.0),
                      // Profile Picture
                      Expanded(
                        // optional flex property if flex is 1 because the default flex is 1
                        flex: 1,
                        child:  Text(AddNewTitle[LanguageData],
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white,
                            // Color.fromRGBO(248, 95, 106, 1.0),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            //decoration: TextDecoration.underline,
                          ),
                        ) ,
                      ),
                      const SizedBox(width: 5.0),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Directionality( // use this
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                        child: AddSymptoms(storage: AddSymptomsStorage(),)),),
                    );
                  },
                ),
              )
                  :const SizedBox(
                    height: 0.0,
                  ),

              // VitalSign BarChart
                  VitalSignsData[0][5].toString() != "" 
                      ?Container(
                margin: const EdgeInsets.only(top:5.0),
                padding: const EdgeInsets.only(top: 0.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.white,
                        Colors.white,
                      ]
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:   Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                ),

                child:AspectRatio(
                  aspectRatio: 1.3,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.center,
                          barTouchData: BarTouchData(
                            enabled: false,
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: bottomTitles,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: leftTitles,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            checkToShowHorizontalLine: (value) => value % 10 == 0,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: const Color(0xffe7e8ec),
                              strokeWidth: 1,
                            ),
                            drawVerticalLine: false,
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          groupsSpace: 50,
                          barGroups: getData(),
                        ),
                      ),
                    ),
                  ),
                ),
              )
                      :const SizedBox(
                    height: 0.0,
                  ),


          ],
        )
                :Column(
                children: [
                  // Form Icon
                  Container(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        'assets/svg/vitals.svg',
                        width: 50,
                        height: 50,
                        alignment: AlignmentDirectional.center,
                        // color: Colors.white,
                        allowDrawingOutsideViewBox: false,
                        // fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // VitalSigns Title and Add New
                  Card(
                    color: const Color.fromRGBO(32, 116, 150, 1.0),
                    shadowColor: Colors.grey,
                    elevation: 4.0,
                    margin: const EdgeInsets.only(top:15.0,left:0.0,bottom:0.0,right:0.0),
                    child: ListTile(
                      title:const Text("Blood Glucose                   + Add new",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white,
                          // Color.fromRGBO(248, 95, 106, 1.0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          //decoration: TextDecoration.underline,
                        ),
                      ) ,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Directionality( // use this
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            child: AddSymptoms(storage: AddSymptomsStorage(),)),),
                        );
                      },
                    ),
                  ),

                  // VitalSign PieChart
                  Container(
                    margin: const EdgeInsets.only(top:5.0),
                    padding: const EdgeInsets.only(top: 0.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white,
                            Colors.white,
                          ]
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:   Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),

                    child:AspectRatio(
                      aspectRatio: 1.3,

                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              height: 18,
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                      pieTouchData: PieTouchData(touchCallback:
                                          (FlTouchEvent event, pieTouchResponse) {
                                        setState(() {
                                          if (!event.isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection == null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!.touchedSectionIndex;
                                        });
                                      }),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections: showingSections()),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Indicator(
                                  color: Color(0xff0293ee),
                                  text: '01/05',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: Color(0xfff8b250),
                                  text: '02/05',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: Color(0xff845bef),
                                  text: '04/05',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: Color(0xff13d38e),
                                  text: '05/05',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),



                  // VitalSigns Title and Add New
                  Card(
                    color: const Color.fromRGBO(32, 116, 150, 1.0),
                    shadowColor: Colors.grey,
                    elevation: 4.0,
                    margin: const EdgeInsets.only(top:15.0,left:0.0,bottom:0.0,right:0.0),
                    child: ListTile(
                      title:const Text("Pulse Rate                         + Add new",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white,
                          // Color.fromRGBO(248, 95, 106, 1.0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          //decoration: TextDecoration.underline,
                        ),
                      ) ,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Directionality( // use this
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            child: AddSymptoms(storage: AddSymptomsStorage(),)),),
                        );
                      },
                    ),
                  ),

                  // VitalSign LineChart
                  Container(
                    margin: const EdgeInsets.only(top:5.0),
                    padding: const EdgeInsets.only(top: 0.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white,
                            Colors.white,
                          ]
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:   Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),

                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            //color: Color(0xff232d37)),
                            color: Colors.white),

                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 18.0, left: 12.0, top: 24, bottom: 12),
                          child: LineChart(
                            showAvg ? avgData() : mainData(),
                          ),
                        ),
                      ),
                    ),

                  ),


                  // VitalSigns Title and Add New
                  Card(
                    color: const Color.fromRGBO(32, 116, 150, 1.0),
                    shadowColor: Colors.grey,
                    elevation: 4.0,
                    margin: const EdgeInsets.only(top:15.0,left:0.0,bottom:0.0,right:0.0),
                    child: ListTile(
                      title:const Text("Blood Pressure                  + Add new",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white,
                          // Color.fromRGBO(248, 95, 106, 1.0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          //decoration: TextDecoration.underline,
                        ),
                      ) ,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Directionality( // use this
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            child: AddSymptoms(storage: AddSymptomsStorage(),)),),
                        );
                      },
                    ),
                  ),

                  // VitalSign BarChart
                  Container(
                    margin: const EdgeInsets.only(top:5.0),
                    padding: const EdgeInsets.only(top: 0.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white,
                            Colors.white,
                          ]
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:   Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),

                    child:AspectRatio(
                      aspectRatio: 1.3,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.center,
                              barTouchData: BarTouchData(
                                enabled: false,
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    getTitlesWidget: bottomTitles,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: leftTitles,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                checkToShowHorizontalLine: (value) => value % 10 == 0,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: const Color(0xffe7e8ec),
                                  strokeWidth: 1,
                                ),
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              groupsSpace: 50,
                              barGroups: getData(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
            ),

      ),
      )
      ),
    );
  }



  //Pie Chart
  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 25,
            title: '25',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }




  //Bar Chart
  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              toY: 130,
              rodStackItems: [
                BarChartRodStackItem(0, 90, dark),
                // BarChartRodStackItem(200, 1200, normal),
                // BarChartRodStackItem(1200, 1700, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              toY: 170,
              rodStackItems: [
                BarChartRodStackItem(0, 110, dark),
                // BarChartRodStackItem(200, 1200, normal),
                // BarChartRodStackItem(1200, 1700, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              toY: 110,
              rodStackItems: [
                BarChartRodStackItem(0, 70, dark),
                // BarChartRodStackItem(200, 1200, normal),
                // BarChartRodStackItem(1200, 1700, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              toY: 120,
              rodStackItems: [
                BarChartRodStackItem(0, 80, dark),
                // BarChartRodStackItem(200, 1200, normal),
                // BarChartRodStackItem(1200, 1700, light),
              ],
              borderRadius: const BorderRadius.all(Radius.zero)),
        ],
      ),
    ];
  }





  // Line Chart

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(32, 116, 150, 1.0),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('01/05', style: style);
        break;
      case 5:
        text = const Text('03/05', style: style);
        break;
      case 8:
        text = const Text('04/05', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 8.0));
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(32, 116, 150, 1.0),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10';
        break;
      case 3:
        text = '50';
        break;
      case 5:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white, width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white, width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }





}



class VitalSignsStorage
{
  Future<String> createSettingsFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/Settings');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  // This function is triggered when the "Read" button is pressed
  Future<String> _readSettingsData(String Filename) async {
    final dirPath =  await createSettingsFolder();
    final myFile = await File('$dirPath/'+Filename+'.txt');

    if(await myFile.exists())
    {
      String data = await myFile.readAsString();
      return  data;
    }
    else
    {
      return "No Data";
    }

  }
// Find the Documents path
  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> createFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/VitalSigns');
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

// This function is triggered when the "Read" button is pressed
  Future<String> _readData(String Filename) async {
    final dirPath =  await createFolder();
    final myFile = await File('$dirPath/'+Filename+'.txt');

    if(await myFile.exists())
    {
      String data = await myFile.readAsString();
      return  data;
    }
    else
    {
      return "No Data";
    }

  }



// This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData(String Data, String Filename) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/'+Filename+'.txt');
// If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(Data);
  }

}