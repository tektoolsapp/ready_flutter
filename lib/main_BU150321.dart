//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'auth/Auth.dart';
import 'models/Test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
//
/* Future main() async {
  // NOTE: The filename will default to .env and doesn't need to be defined in this case
  await DotEnv.load(fileName: ".env");
  //...runapp
//} */

/* void main() => runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider<Test>(create: (context) => Test()),
      ],
      child: MyApp(),
    ),
); */

Future main() async {
  await DotEnv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider<Test>(create: (context) => Test()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState(){
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>{
  final storage = new FlutterSecureStorage();

  //static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  //@override
   
  final PrimaryColor = const Color(0xFF27447E);

  void _tryToAuthenticate() async {
    String token = await storage.read(key: 'token');
    //String token = 'abc';
    
    Provider.of<Auth>(context, listen: false).attempt(
      token: token
    );
  
  }
  
  @override
  void initState(){
    //print("attempt");
    _tryToAuthenticate();
    //_initializeCamera(); 

    super.initState();

  }

  Widget build(BuildContext context) {
  
    //print("CAMERA $firstCamera");
    
    return MaterialApp(
      title: 'Flutter Ready',
      /* theme: ThemeData(
        primaryColor: PrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ), */
      theme: ThemeData(
        primaryColor: PrimaryColor,
        //primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryTextTheme: TextTheme(
          headline5: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.black,
          labelStyle: TextStyle(
            color: Colors.black54,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
        ),
      ),
      //home: Home(),
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder: (BuildContext context) => generateRoute(
            context: context,
            name: settings.name,
            arguments: settings.arguments
          )
            
        );
      }
    );
  }
}