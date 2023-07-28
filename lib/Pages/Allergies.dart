import 'dart:io';
import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icare/Pages/add_allergies.dart';
import 'package:icare/Widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Widgets/ImageFromGalleryEx.dart';
import 'package:share_plus/share_plus.dart';

import 'DeleteItemList.dart';


class AllergiesPage extends StatefulWidget {
  final AllergiesStorage storage;

  AllergiesPage({Key? key, required this.storage}) : super(key: key);
  @override
  _AllergiesPageState createState() => _AllergiesPageState();
}
class _AllergiesPageState extends State<AllergiesPage>  {


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

  var AllergiesTitle = ["Allergies","الحساسية",""];
  var AddNewTitle = [" + Add new"," + اضافة جديد",""];
  var NoAddedAllergiesTitle = ["No added Allergies, Please Add new","لا توجد حساسية مضافة ، الرجاء إضافة جديد",""];


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

    widget.storage._readData("icare_allergies").then((String value) async{
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
            List<String> result =  lines[i].split('#');
            for(var j = 0; j<2; j++){
              LisData[i][j] =  result[j];
            }
          }
          widget.storage._readData("icare_pictures").then((String value) async{
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

      }
      else
      {
        Fluttertoast.showToast(
            msg: "No added Allergies, Please Add now.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            fontSize: 14.0);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
            Directionality( // use this
                textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                child: AddAllergies(storage: AddAllergiesStorage(),)
            )),
        );
      }

    });



    super.initState();

  }


  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Directionality( // use this
        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
        child: ImageFromGalleryEx("/Allergies", type,storage: ImageStorage(),)),));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //extendBodyBehindAppBar: true,
        drawer: MainMenu(storage: MainMenuStorage()),
        appBar: AppBar(
          title: Text(AllergiesTitle[LanguageData],
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
                      'assets/svg/allergies.svg',
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
                    title:Text(AddNewTitle[LanguageData],
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Colors.white,
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
                          child: AddAllergies(storage: AddAllergiesStorage(),)),),
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
                          title: Text(AddNewTitle[LanguageData],
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.white,
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
                                child: AddAllergies(storage: AddAllergiesStorage(),)),),
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
                      Card(
                        margin: const EdgeInsets.only(top:0.0,left:0.0,bottom:5.0,right:0.0),
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        child: ListTile(
                          title: Text(NoAddedAllergiesTitle[LanguageData],
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color.fromRGBO(248, 95, 106, 1.0),
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





class AllergiesStorage
{

// Find the Documents path
  Future<String> _getDirPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> createFolder() async {
    var dir = await getApplicationDocumentsDirectory();
    final path = Directory('${dir.path}/ICare/Allergies');
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

// This function is triggered when the "Write" buttion is pressed
  Future<void> _writeData(String Data, String Filename) async {
    final _dirPath = await createFolder();

    final _myFile = File('$_dirPath/'+Filename+'.txt');
// If data.txt doesn't exist, it will be created automatically

    await _myFile.writeAsString(Data);
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
                    Share.share("Allergy\nDate:"+DataTitle+"\n"+"Details:"+DataSubTitle+"\n"+"\n\nProvided by ICare,(https://play.google.com/store/apps/details?id=com.icareapp.medical.icare)");
                  }
              ),
              const SizedBox(width: 10),
              imageURL !=""
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
                  'assets/svg/allergies.svg',
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                      (context) => Directionality( // use this
                  textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                  child: AddAllergies(storage: AddAllergiesStorage(),)
                  )),
              );
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder:
                            (context) => Directionality( // use this
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                        child: AddAllergies(storage: AddAllergiesStorage(),)
                        )),
                    );
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
                            (context) => Directionality( // use this
                        textDirection: LanguageData == 1 ?TextDirection.rtl :TextDirection.ltr ,
                        child: DeleteItemListPage(DirName: 'Allergies', FileName: 'icare_Allergies', DataIndex: DataIndex, DataTitle: DataSubTitle, DataLines: DataLines, DataImage: "allergies")
                        )),
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