import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:intl/intl.dart' as intl;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/PDFScreen.dart';
import 'DeleteFilePage.dart';
import 'dart:io';
import 'ReportsLayout.dart';
import 'ReportsTutorial.dart';


class ReportsHomePage extends StatefulWidget {
  final ReportsTutorialStorage ReportsTutorialStatus;

  ReportsHomePage({ required this.ReportsTutorialStatus });

  @override
  _ReportsHomePageState createState() => _ReportsHomePageState();
}

class _ReportsHomePageState extends State<ReportsHomePage>  {

  final verticalScroll = ScrollController();
  bool showProgress = false;
  TextEditingController FromDateController = TextEditingController();
  TextEditingController ToDateController = TextEditingController();

  List file = [];

  _ReportsHomePageState();
  var LanguageData =0;

  var ReportTitle = ["Reports","التقارير",""];
  var IcareReportTitle = ["Icare Report","التقارير",""];
  var NoFilesTitle = ["No Available Generated Reports\n Generate Now","لا توجد تقارير تم إنشاؤها متوفرة "+"\n "+" برجاء الإنشاء الآن",""];
  var FromDateTitle = ["From Date","التاريخ من",""];
  var ToDateTitle = ["To Date","التاريخ إلي",""];
  var GenerateBtnTitle = ["Generate","انشاء",""];
  var ReportSuccessMsg = ["Report is being Generated. It will take some time, Please be patient.","يتم إنشاء التقرير. سيستغرق الأمر بعض الوقت ، يرجى التحلي بالصبر.",""];
  var ReportFailMsg = ["Report Generation Failed, Check Required Dates.","فشل إنشاء التقرير ، تحقق من التواريخ المطلوبة.",""];


  @override
  void initState() {
    // TODO: implement initState
    widget.ReportsTutorialStatus._readSettingsData("icare_Language").then((String value) async{
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

    widget.ReportsTutorialStatus._readData().then((String value) async{
      if(value != "" && value != null)
      {
        if(value == "First")
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Directionality( // use this
              textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
              child: ReportsTutorialPage()),),
          );
        }
        else
        {
          widget.ReportsTutorialStatus._listofFiles().then((List value) async{
            setState(() {
              file = value;
            });
          });
          super.initState();

        }
      }

    });

  }



  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: MainMenu(storage: MainMenuStorage()),
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.analytics)),
                Tab(icon: Icon(Icons.picture_as_pdf)),
              ],
            ),
            title: Text(ReportTitle[LanguageData],
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
          body: TabBarView(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/grmain.png'),
                        fit: BoxFit.fill
                    )
                ),
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child:Scrollbar(
                  isAlwaysShown: true,
                  thickness: 0.0,
                  //scrollbarOrientation: ScrollbarOrientation.bottom,
                  controller: verticalScroll,
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      scrollDirection: Axis.vertical,
                      controller: verticalScroll,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          // Form Title
                          Container(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              height: 80,
                              width: 80,
                              color: Colors.transparent,
                              child: Image.asset('assets/img/whitelogo.png'),
                            ),
                          ),

                          // Add Form
                          Container(
                            margin: const EdgeInsets.only(top:5.0),
                            //padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Colors.white,
                                    Colors.white,
                                  ]
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4,
                                  offset: Offset(0, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: ModalProgressHUD(
                              inAsyncCall: showProgress,
                              child: Column(
                                children: <Widget>[

                                  Container(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Card(
                                        color: const Color.fromRGBO(32, 116, 150, 1.0),
                                        shadowColor: Colors.grey,
                                        elevation: 4.0,
                                        margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                                        child: ListTile(
                                          title: Text(IcareReportTitle[LanguageData],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Container(
                                        height: 80,
                                        width: 80,
                                        color: Colors.transparent,
                                        child: SvgPicture.asset(
                                          'assets/svg/reports.svg',
                                          width: 50,
                                          height: 50,
                                          alignment: AlignmentDirectional.center,
                                          // color: Colors.white,
                                          allowDrawingOutsideViewBox: false,
                                          // fit: BoxFit.cover,
                                        ),

                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child:TextField(
                                      controller: FromDateController, //editing controller of this TextField
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.date_range), //icon of text field
                                        labelText: FromDateTitle[LanguageData],
                                        labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                          fontSize: 16,
                                          //fontWeight: FontWeight.w500,
                                        ),  //label text of field
                                      ),
                                      readOnly: true,  //set it true, so that user will not able to edit text
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context, initialDate: DateTime.now(),
                                            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                            lastDate: DateTime(2101)
                                        );

                                        if(pickedDate != null ){
                                          //var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                                          var outputFormat = intl.DateFormat('MM/dd/yyyy');
                                          var outputDate = outputFormat.format(pickedDate);
                                          FromDateController.text =  outputDate.toString();
                                          setState(() {
                                            FromDateController.text = outputDate.toString(); //set output date to TextField value.
                                          });
                                        }else{
                                          print("Date is not selected");
                                        }
                                      },
                                      style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                        fontSize: 16,
                                        //fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child:TextField(
                                      controller: ToDateController, //editing controller of this TextField
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        prefixIcon: const Icon(Icons.date_range), //icon of text field
                                        labelText: ToDateTitle[LanguageData],
                                        labelStyle: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                          fontSize: 16,
                                          //fontWeight: FontWeight.w500,
                                        ),  //label text of field
                                      ),
                                      readOnly: true,  //set it true, so that user will not able to edit text
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context, initialDate: DateTime.now(),
                                            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                            lastDate: DateTime(2101)
                                        );

                                        if(pickedDate != null ){
                                          //var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                                          var outputFormat = intl.DateFormat('MM/dd/yyyy');
                                          var outputDate = outputFormat.format(pickedDate);
                                          ToDateController.text =  outputDate.toString();
                                          setState(() {
                                            ToDateController.text = outputDate.toString(); //set output date to TextField value.
                                          });
                                        }else{
                                          print("Date is not selected");
                                        }
                                      },
                                      style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                                        fontSize: 16,
                                        //fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20.0,
                                  ),

                                  Container(
                                      height: 50,
                                      width: 300.0,
                                      // color: Colors.teal,
                                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: ElevatedButton(
                                        // style: ElevatedButton.styleFrom(
                                        //     primary: Colors.teal,),
                                        child: Text(GenerateBtnTitle[LanguageData]),
                                        onPressed: ()  async {
                                          try {
                                            if(FromDateController.text != "" && ToDateController.text != "")
                                            {
                                              setState(() {
                                                showProgress = true;
                                              });

                                              Fluttertoast.showToast(
                                                  msg: ReportSuccessMsg[LanguageData],
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.teal,
                                                  textColor: Colors.white,
                                                  fontSize: 14.0);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Directionality( // use this
                                                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                                            child: ReportsLayoutPage(FromDate: FromDateController.text,ToDate: ToDateController.text,storage: ReportsStorage(),PrintPdf: ReportsPdfReport(),)),
                                                    ),);

                                              setState(() {
                                                showProgress = false;
                                              });
                                            }
                                          } catch (e) {
                                            setState(() {
                                              showProgress = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg: ReportFailMsg[LanguageData],
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.teal,
                                                textColor: Colors.white,
                                                fontSize: 14.0);
                                          }
                                        },
                                      )
                                  ),

                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      )
                  ),
                ),
              ),

              file.length == 0?
              Card(margin: const EdgeInsets.only(top: 200.0),
              child:ListTile(
              title: Text(NoFilesTitle[LanguageData],textAlign: TextAlign.center,
              style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
              fontSize: 24,
              fontWeight: FontWeight.w900,
              ),),
              )
              ):
              ListView.builder(  //if file/folder list is grabbed, then show here
                itemCount: file.length,
                itemBuilder: (context, index) {
                    return Card(
                        child:ListTile(
                          title: GestureDetector(
                            child:  Text(file[index].path.split('/').last,style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),),
                            onTap: ()
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                child: PDFScreen(pdfPath: file[index].path,FileTitle: file[index].path.split('/').last),
                                ),),
                              );
                            },
                          ),
                          leading: const Icon(Icons.picture_as_pdf, color: Colors.teal,),
                          trailing:GestureDetector(
                            child:  const Icon(Icons.delete, color: Colors.redAccent,),
                            onTap: ()
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality( // use this
                                textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr  ,
                                child: DeleteFilePage(FilePath: file[index].path,FileName: file[index].path.split('/').last, Module: "Reports"),
                                ),),
                              );
                            },
                          ),
                        )
                    );
                },
              ),

            ],
          ),
        ),
      );
  }


}


class ReportsTutorialStorage
{

  // Make New Function
  Future<List> _listofFiles() async {
    var dir = await getApplicationDocumentsDirectory();
    List file = Directory('${dir.path}/ICare/Reports').listSync();  //use your folder name insted of resume.
    return file;
  }


  Future<String> createFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare');
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
  Future<String> _readData() async {
    final dirPath = await createFolder();
    final myFile = File('$dirPath/ReportsTutorial.txt');
    if(await myFile.exists())
    {
      String data = await myFile.readAsString();
      return  data;
    }
    else
    {
      _writeData("First");
      return "First";
    }
  }

  // This function is triggered when the "Write" button is pressed
  Future<void> _writeData(String Data) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/ReportsTutorial.txt');
    // If data.txt doesn't exist, it will be created automatically
    if ((await _myFile.exists())) {
      await _myFile.writeAsString(Data,  mode: FileMode.append);
    } else {
      await _myFile.writeAsString(Data);

    }
  }
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

}