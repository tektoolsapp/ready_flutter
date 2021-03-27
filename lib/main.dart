//import 'dart:html';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/models/Message.dart';
import 'package:flutter_ready_prod/Message2.dart';
import 'package:flutter_ready_prod/models/Todo.dart';
import 'package:flutter_ready_prod/models/messageCounter.dart';
import 'package:flutter_ready_prod/routes.dart';
import 'package:flutter_ready_prod/screens/DetailScreen.dart';
import 'package:flutter_ready_prod/screens/MessagesScreen.dart';
import 'package:flutter_ready_prod/screens/MessagesScreen2.dart';
import 'package:flutter_ready_prod/screens/ShiftDetailsMessageScreen.dart';
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
  
  WidgetsFlutterBinding.ensureInitialized(); //imp line need to be added first
    FlutterError.onError = (FlutterErrorDetails details) {
    //this line prints the default flutter gesture caught exception in console
    //FlutterError.dumpErrorToConsole(details);
    print("Error From INSIDE FRAME_WORK");
    print("----------------------");
    print("Error :  ${details.exception}");
    print("StackTrace :  ${details.stack}");
    };
  
  
  //runZoned(() async {
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider<Test>(create: (context) => Test()),
        ChangeNotifierProvider<Message>(create: (context) => Message()),
        ChangeNotifierProvider<Message2>(create: (context) => Message2()),
        ChangeNotifierProvider<MessageCounter>(create: (context) => MessageCounter()),
        //ChangeNotifierProvider<Contact>(create: (context) => Contact()),
      ],
      child: MyApp(),
    )
  );

  /* }, onError: (error, stackTrace) {
      print("Error FROM OUT_SIDE FRAMEWORK ");
      print("--------------------------------");
      print("Error :  $error");
      print("StackTrace :  $stackTrace");
  
  
  }); */
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState(){
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>{

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
  
  final storage = new FlutterSecureStorage();

  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  bool showStack = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //@override
   
  final PrimaryColor = const Color(0xFF27447E);

  void _initMessageCount() async {
    
    final counter = Provider.of<MessageCounter>(context, listen: false );
    
    String numMessages = await storage.read(key: 'numMessages');    
    print("INITIALISING! $numMessages");
    
    var newCount = int.tryParse(numMessages);

    if(newCount > 0){
      showStack = true;
    }
    
    setState(() => {
      counter.messageCounter = newCount,
      counter.showStack = showStack
    }); 

  }

  void _increment() async {
    
    String numMessages = await storage.read(key: 'numMessages');    
    print("COUNTING! $numMessages");

    final counter = Provider.of<MessageCounter>(context, listen: false );
    int newCount = counter.increment(numMessages);

    setState(() => {
        counter.messageCounter = newCount
      });  
  }
  
  void _tryToAuthenticate() async {
    String token = await storage.read(key: 'token');
    //String token = 'abc';
    
    Provider.of<Auth>(context, listen: false).attempt(
      token: token
    );
  
  }

  @override
  void initState(){
   
    _tryToAuthenticate();

    print("INIT:"); 
    _initMessageCount();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("INCREMENT");
        _increment();
        setState(() {
          _messageText = "PushXXXXX Messaging message: $message";
        });
        print("onMessageXXXXXX: $message");
        
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "PushYYYY Messaging message: $message";
        });
        print("onLaunch: $message");
      },
      /* onResume: (Map<String, dynamic> message) async {
        navigatorKey.currentState.push(
          MaterialPageRoute(builder: (_) => MessagesScreen2())
        );
      }, */
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "PushZZZZZ Messaging message: $message";
        });
        print("XXonResume: $message");
        print("SCREEN ${message['screen']}");
        print("NAV KEY: $navigatorKey");
        
        switch (message['screen']) {
          case "new_messages":
            print("NAVIGATE");

            print("TITLE: ${message['aps']['alert']['title']}");
            
            //String nextPageData = "6";

            /* var todo = Todo(
              'Todo TOMORROW',
              'A description of what needs to be done for Todo TOMORROW',
            ); */

            var todo = Todo(
              message['id'],
              message['aps']['alert']['title'],
              message['aps']['alert']['body'],
            );

            navigatorKey.currentState.push(
              MaterialPageRoute(builder: (_) => MessagesScreen())
              //MaterialPageRoute(builder: (_) => DetailScreen(todo: todo))
            );
            
            break;
          
        }

      },

    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });

    super.initState();

  }

  Widget build(BuildContext context) {
      
    return MaterialApp(
      navigatorKey: navigatorKey,
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
      },
      //navigatorKey: navigatorKey,
    );
  }
}