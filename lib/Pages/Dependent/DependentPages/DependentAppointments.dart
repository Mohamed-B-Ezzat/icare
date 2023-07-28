import 'dart:io';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../DependentWidgets/DependentImageFromGalleryEx.dart';
import '../DependentWidgets/Dependentmain_menu.dart';
import 'DependentDeleteItemList.dart';
import 'Dependentadd_appointments.dart';


class DependentAppointmentsPage extends StatefulWidget {
  final DependentAppointmentsStorage storage;

  final String DirName;
  final String DataTitle;
  final String DataImage;
  DependentAppointmentsPage({Key? key,required this.DataTitle, required this.DataImage, required this.DirName, required this.storage}) : super(key: key);

  @override
  _DependentAppointmentsPageState createState() => _DependentAppointmentsPageState(this.DataTitle, this.DataImage,this.DirName);
}

class _DependentAppointmentsPageState extends State<DependentAppointmentsPage> {

  var DirName;
  var DataTitle;
  var DataImage;

  _DependentAppointmentsPageState(this.DataTitle, this.DataImage,this.DirName);




  var LisData;
  var Data;
  var DataLines;
  var ImageListData;
  var ImageList;
  final verticalScroll = ScrollController();

  String description = "";
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String? _content;
  XFile? _image = null;
  final picker = ImagePicker();


  var LanguageData =0;


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

    widget.storage._readData(DirName.toString(),"icare_appointments").then((String value) async{
      if(value != "No Data" && value != "")
      {

        LineSplitter ls = new LineSplitter();
        List<String> lines = ls.convert(value);
        if(lines.isNotEmpty)
        {
          int row = lines.length;
          int col = 2;
          LisData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

          for (var i = 0; i < lines.length; i++) {
            List<String> result =  lines[i].split(',');
            for(var j = 0; j<2; j++){
              LisData[i][j] =  result[j];
            }
          }

          widget.storage._readData(DirName.toString(),"icare_pictures").then((String value) async{
            if(value != "No Data" && value != "")
            {

              LineSplitter ls = new LineSplitter();
              List<String> lines = ls.convert(value);

              if(lines.isNotEmpty)
              {
                int row = LisData.length;
                int col = 1;
                ImageListData = List.generate(row, (s) => List.filled(col, "", growable: false), growable: false);

                for (var i = 0; i < lines.length; i++) {

                  ImageListData[i][0] =  lines[i];

                }
                setState(() {
                  ImageList = ImageListData;
                });
              }
            }
            else
            {
              setState(() {
                ImageList = "";
              });
            }

          });
        }
        setState(() {
          DataLines = lines;
          Data = LisData;
        });

        super.initState();

      }
      else
      {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
            Directionality( // use this
                textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                child: DependentAddAppointments(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString() ,storage:DependentAddAppointmentsStorage())
            )
            )
        );
      }

    });





  }





  @override
  Widget build(BuildContext context) {

    double edge = 120.0;
    double padding = edge / 10.0;


    return Scaffold(
      //extendBodyBehindAppBar: true,
        drawer: DependentMainMenu(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),storage: DependentMainMenuStorage(), DirName: DirName.toString(),),
        appBar: AppBar(
          title: const Text('Family Member Appointments',
            style: TextStyle(
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
            // child:Scrollbar(
            //   isAlwaysShown: false,
            //   thickness: 0.0,
            //   //scrollbarOrientation: ScrollbarOrientation.bottom,
            //   controller: verticalScroll,
            //   child: SingleChildScrollView(
            //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            //       scrollDirection: Axis.vertical,
            //       controller: verticalScroll,
            child: Stack(
              alignment: Alignment.topCenter,

              children: [

                // Form Title
                Container(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      'assets/svg/appointments.svg',
                      width: 50,
                      height: 50,
                      alignment: AlignmentDirectional.center,
                      // color: Colors.white,
                      allowDrawingOutsideViewBox: false,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Dependents Title and Add New
                Card(
                  color: const Color.fromRGBO(32, 116, 150, 1.0),
                  shadowColor: Colors.grey,
                  elevation: 4.0,
                  margin: const EdgeInsets.only(top:90.0,left:0.0,bottom:10.0,right:0.0),
                  child: ListTile(
                    title:const Text(" + Add new",
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
                            builder: (context) =>
                          Directionality( // use this
                              textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                              child: DependentAddAppointments(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString() ,storage:DependentAddAppointmentsStorage())
                        ),
                        ),
                      );
                    },
                  ),
                ),


                // Dependents
                Container(
                  margin: const EdgeInsets.only(top:150.0),
                  padding: const EdgeInsets.only(top: 10.0),
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

                  child: Data != null && ImageList != null
                      ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return DataListViewWidget(
                        DataTitle: Data[index][0],
                        DataSubTitle: Data[index][1], key: null,
                        DataIndex: index,
                        DataLines: DataLines,
                        imageURL: ImageList!="" ? ImageList[index][0] : "",
                        LanguageData: LanguageData,
                      );
                    },
                    itemCount: Data.length,
                  )
                      :ListView(
                    children: [

                      // Dependents Title and Add New
                      Card(
                        color: const Color.fromRGBO(32, 116, 150, 1.0),
                        shadowColor: Colors.grey,
                        elevation: 4.0,
                        margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:10.0,right:0.0),
                        child: ListTile(
                          title:const Text(" + Add new",
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
                                  builder: (context) =>
                                Directionality( // use this
                                    textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                                    child: DependentAddAppointments(DataImage: DataImage.toString(),DataTitle: DataTitle.toString(),DirName: DirName.toString() ,storage:DependentAddAppointmentsStorage())
                              ),
                              ),
                            );
                          },
                        ),
                      ),

                      // First Dependent
                      Container(
                          margin: const EdgeInsets.only(top:5.0,left:10.0,bottom:5.0,right:10.0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.white,
                                  Colors.white,
                                ]
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1,
                                offset: Offset(0, 0), // Shadow position
                              ),
                            ],
                          ),
                          child:const ListTile(
                            title: const Text(""),
                            subtitle: const Text(""),
                          )

                      ),

                      // Second Dependent
                      Container(
                          margin: const EdgeInsets.only(top:5.0,left:10.0,bottom:5.0,right:10.0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.white,
                                  Colors.white,
                                ]
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1,
                                offset: Offset(0, 0), // Shadow position
                              ),
                            ],
                          ),
                          child:const ListTile(
                            title: const Text(""),
                            subtitle: const Text(""),
                          )

                      ),

                      // See All Tab
                      const Card(
                        margin: EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        child: ListTile(
                          title: Text("No added Appointments, Please Add new",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color.fromRGBO(248, 95, 106, 1.0),
                              // Color.fromRGBO(248, 95, 106, 1.0),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              //decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                    //padding: EdgeInsets.all(10),
                  ),

                ),

              ],
            )
          //   ),
          // ),
        )
    );
  }




}



class DependentAppointmentsStorage
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

  Future<String> createFolder(String DirName) async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/'+DirName+'/Appointments');
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
  Future<String> _readData(String DirName, String Filename) async {
    final dirPath =  await createFolder(DirName);
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
  Future<void> _writeData(String DirName, String Data, String Filename) async {
    final _dirPath = await createFolder(DirName);

    final _myFile = File('$_dirPath/'+Filename+'.txt');
    // If data.txt doesn't exist, it will be created automatically
    if ((await _myFile.exists())) {
      await _myFile.writeAsString(Data,  mode: FileMode.append);
    } else {
      await _myFile.writeAsString(Data);

    }
  }

}



class DataListViewWidget extends StatelessWidget {
  final String DataTitle;
  final String DataSubTitle;
  final String imageURL;
  final int DataIndex;
  final List DataLines;
  final int LanguageData;

  // const DataListViewWidget({required Key key, required this.DataTitle, required this.DataSubTitle, required this.imageURL}) : super(key: key);
  const DataListViewWidget({required Key? key, required this.LanguageData, required this.DataTitle, required this.DataSubTitle,required this.DataIndex, required this.DataLines, required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:5.0,left:10.0,bottom:5.0,right:10.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.white,
              Colors.white,
            ]
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1,
            offset: Offset(0, 0), // Shadow position
          ),
        ],
      ),
      child: ListTile(
        leading: FittedBox(
          fit: BoxFit.fill,
          child: Row(
            children: [
              GestureDetector(
                  child: const Icon(
                    Icons.share,color: Colors.teal,size: 30.0,
                  ),
                  onTap: () async {
                    Share.share("Appointment\nDate:"+DataTitle+"\n"+"Details:"+DataSubTitle+"\n"+"\n\nProvided by ICare,(https://play.google.com/store/apps/details?id=com.icareapp.medical.icare)");
                  }
              ),
              const SizedBox(width: 10),
              imageURL!=""
                  ?ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 64,
                  maxHeight: 64,
                ),
                child: Image.file(
                  File(imageURL),
                  width: 50,
                  height: 50,
                  alignment: AlignmentDirectional.center,
                ),
              )
                  :ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 64,
                  maxHeight: 64,
                ),
                child: SvgPicture.asset(
                  'assets/svg/appointments.svg',
                  width: 50,
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  // color: Colors.white,
                  allowDrawingOutsideViewBox: false,
                ),
              ),
            ],
          ),
        ),
        title: GestureDetector(
            child: Text(DataTitle,
                style: const TextStyle(color: Color.fromRGBO(32, 116, 150, 1.0),)),
            onTap: (){
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder:
              //         (context) =>
              //             DependentEditViewScansPage(type: true, Data: DataTitle+"\n"+DataSubTitle+"\n"+Description)
              //     )
              // );
            }
        ),
        subtitle: Text(DataSubTitle),

        trailing: FittedBox(
          fit: BoxFit.fill,
          child: Column(
            children: [
              GestureDetector(
                  child: const Icon(
                    Icons.edit,color: Color.fromRGBO(32, 116, 150, 1.0),size: 30.0,
                  ),
                  onTap: (){
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder:
                    //         (context) =>
                    //             DependentEditViewScansPage(type: true, Data: DataTitle+"\n"+DataSubTitle+"\n"+Description)
                    //
                    // )
                    // );
                  }
              ),
              const SizedBox(height: 5),
              GestureDetector(
                  child: const Icon(
                    Icons.delete_forever,color: Colors.redAccent,size: 30.0,
                  ),
                  onTap: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder:
                            (context) =>
                        Directionality( // use this
                            textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                            child: DependentDeleteItemListPage(DirName: 'DependentAppointments', FileName: 'icare_DependentAppointments', DataIndex: DataIndex, DataTitle: DataSubTitle, DataLines: DataLines, DataImage: "DependentAppointments")
                        ))
                    );
                  }
              ),
              // Icon(Icons.share,color: Color.fromRGBO(32, 116, 150, 1.0),),
              // SizedBox(height: 15),
              // Icon(Icons.edit,color: Colors.teal,)
            ],
          ),
        ),
      ),
    );
  }
}