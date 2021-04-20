import 'package:flutter/material.dart';
//import 'package:flutter_ready_prod/models/Message.dart';
import 'package:flutter_ready_prod/Message2.dart';
import 'package:flutter_ready_prod/models/Shift.dart';
import 'package:flutter_ready_prod/models/Todo.dart';
import 'package:flutter_ready_prod/screens/ContactsScreen.dart';
import 'package:flutter_ready_prod/screens/DetailScreen.dart';
import 'package:flutter_ready_prod/screens/ErrorHandling.dart';
import 'package:flutter_ready_prod/screens/HomeScreen.dart';
import 'package:flutter_ready_prod/screens/MessagesScreen.dart';
//import 'package:flutter_ready_prod/screens/HomeScreen.dart';
//import 'package:flutter_ready_prod/screens/LoggedOutScreen.dart';
import 'package:flutter_ready_prod/screens/MessagesScreen2.dart';
import 'package:flutter_ready_prod/screens/PhotosScreen.dart';
import 'package:flutter_ready_prod/screens/ShiftConfirmScreen.dart';
import 'package:flutter_ready_prod/screens/ShiftDetailsMessageScreen.dart';
import 'package:flutter_ready_prod/screens/ShiftDetailsScreen.dart';
import 'package:flutter_ready_prod/screens/ShiftsScreen.dart';
import 'package:flutter_ready_prod/screens/TestErrorScreen.dart';
import 'package:flutter_ready_prod/screens/TravelDocsScreen.dart';
import 'package:flutter_ready_prod/screens/ViewPdf.dart';
import 'package:flutter_ready_prod/screens/auth/PinCode.dart';
import 'package:flutter_ready_prod/screens/home_material.dart';
import 'package:flutter_ready_prod/screens/messagesList.dart';
import 'package:flutter_ready_prod/screens/newsList.dart';

generateRoute({BuildContext context, String name, Object arguments}){
  switch (name){
    case '/':
      return PinCodeVerificationScreen('');
      break;
    case '/shifts':
      return ShiftsScreen();
      break;
    case '/shiftMessageDetails':
      return ShiftDetailsMessageScreen(
        message: arguments as Message2
        //myInt: arguments
        /* if (arguments is String) {
          return MaterialPageRoute(
            builder: (_) => ShiftDetailsMessageScreen(
                  myInt: arguments
                ),
          );
        } */
      );
      break;
    case '/shiftDetails':
      return ShiftDetailsScreen(
      //return MyForm(
      //return ShiftConfirmScreen(
        shift: arguments as Shift
      );
      break;
    case '/travelDocs':
      //return MessagesScreen(
      return TravelDocsScreen(
        //shift: arguments as Shift
      );
      break; 
    case '/messages':
      //return MessagesScreen(
      return MessagesList(
        //auth: arguments as Auth
      );
      break;     
    case '/test':
      return TestErrorScreen(
        //auth: arguments as Auth
      );
      case '/errors':
      return ErrorHandling(
        //auth: arguments as Auth
      );
      break;
    case '/photos':
      return PhotoScreen(
        //auth: arguments as Auth
      );
      break;
    case '/viewPdf':
      return ViewPdf(
        //auth: arguments as Auth
      );
      break;
    case '/contacts':
      return ContactsPage(
      );
      break;
    case '/old_messages':
      return MessagesScreen(
      );
      break;
    case '/new_messages':
      return MessagesScreen2(
      );
      break;
    case '/news_articles':
      return NewsList(
      );
      break;
    case '/logged_in':
      return HomeScreen();
      break;
    case '/logged_out':
      return PinCodeVerificationScreen('');
      break;
    case '/details':
      return DetailScreen(
        todo: arguments as Todo
      );
      break;
  }
}