import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = new FlutterSecureStorage();

class MessageCounter extends ChangeNotifier {

  int messageCounter = 0;
  bool showStack = false;

  void _setStoredMessages (String numMessages) async {
    print("MC STORING MESSAGES: $numMessages");
    await storage.write(key: "numMessages", value: numMessages); 
  }

  storeMessages(numMessages){
    
    print("NUM MESSAGES TO STORE: $numMessages");
    
    numMessages = int.tryParse(numMessages);
    
    messageCounter = numMessages;

    if(messageCounter > 0){
      showStack = true;
    }

    print("SHOW STACK ON FETCH: $showStack");

    //msgStr = String.tryParse(numMessages);

    _setStoredMessages(messageCounter.toString());
  
    notifyListeners();

    return messageCounter;

  }

  increment(numMessages){
    
    print("NUM MESSAGES TO INCREMENT: $numMessages");
    
    numMessages = int.tryParse(numMessages);

    numMessages = numMessages + 1;
    
    messageCounter = numMessages;

    print("MESSAGE COUNTER INCREMENT: $messageCounter");

    print("NUM MESSAGES AFTER INCREMENT: $numMessages");

    if(messageCounter > 0){
      showStack = true;
    }

    print("SHOW STACK INCREMENT: $showStack");

    _setStoredMessages(messageCounter.toString());
    notifyListeners();

    return messageCounter;

  }

  decrement(numMessages){
    
    print("NUM MESSAGES TO DECREMENT: $numMessages");
    
    numMessages = int.tryParse(numMessages);

    numMessages = numMessages - 1;
    
    messageCounter = numMessages;

    if(messageCounter > 0){
      showStack = true;
    }

    print("MESSAGE COUNTER DECREMENT: $messageCounter");

    print("NUM MESSAGES AFTER DECREMENT: $numMessages");

    if(numMessages == 0){
      showStack = false;
    }

    print("SHOW STACK DECREMENT: $showStack");

    _setStoredMessages(messageCounter.toString());
    notifyListeners();

    return messageCounter;

  }
}