import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:websocket_flutter_app/data_model.dart';
import 'package:websocket_flutter_app/model/user.dart';
import 'package:websocket_flutter_app/utils/util.dart';
import 'package:web_socket_channel/status.dart' as status;

class HomeViewModel {
  WebSocketCustom? web ;
  HomeViewModel() {
    web = WebSocketCustom(model: this);
  }
  final data = <User>[];
  final controller = StreamController<List<User>>();
  final connectedController = StreamController<bool>();

  void reInit(){
    web?.closeWebSocket();
    web = WebSocketCustom(model: this);
  }
  void sendData(
      {required TextEditingController id,
      required TextEditingController message,
      required actionNumber,
      required BuildContext context}) {
    final idText = id.value.text;
    final messageText = message.value.text;

    if (actionNumber != 0) {
      if (messageText.isEmpty) {
        Utils.showFlashBarMessage(
            'give the sent message', FlasType.error, context);

        return;
      }
    }

    if (actionNumber == 1 || actionNumber == 0) {
      if (idText.isEmpty) {
        Utils.showFlashBarMessage(
            actionNumber == 1?'give the id that you sent particular' : 'please give your id', FlasType.error, context);
        return;
      }
    }

    final dataModel = DataModel.setData(
        sender: '112',
        actionNumber: actionNumber,
        message: messageText,
        receiver: idText);
    final map = dataModel.toMap();
    print(map);

    web?.sendMessage(jsonEncode(map));
  }


  void setMessageState(String message) {
    data.add(User.jsonToUser(jsonDecode(message)));
    controller.sink.add(data);
  }

  Stream<List<User>> getMessageState() {
    return controller.stream;
  }

  void setConnected(bool isConnection){
    print(isConnection);
    connectedController.sink.add(isConnection);
  }
  Stream<bool> isConnected() {
    return connectedController.stream;
  }

  void dispose() {
    controller.close();
    connectedController.close();
  }


}

class WebSocketCustom {
  Uri wsUrl = Uri.parse('ws://192.168.0.109:8080');
  late WebSocketChannel channel;
  late HomeViewModel _model;
  bool isConnected = true;
  WebSocketCustom( {required HomeViewModel model}) {
    _model = model;
    _setupWebSocket();

  }


  void _setupWebSocket() async {
    channel = WebSocketChannel.connect(wsUrl);
    // Future.delayed(const Duration(seconds: 1), ()async {
    //     await channel.ready;
    //     print(channel.protocol);
    //
    //     if(channel.protocol !=null){
    //
    //     }
    //
    // },);
    channel.ready.then((value) {
    isConnected = true;
        _model.setConnected(isConnected);
    });

    // Set up a listener for incoming messages
    channel.stream.listen((message) {
      print('Received: $message');
      print(channel.protocol);
      // You can choose to send a response here if needed
      _model.setMessageState(message);
    },
      onDone: () {
        debugPrint('ws channel closed');
        isConnected = false;
        _model.setConnected(isConnected);
      },
      onError: (error) {
        debugPrint('ws error $error');
        isConnected = false;
        _model.setConnected(isConnected);
      },
    );

    // You can also set up an error handler if needed
    channel.sink.done.then((void _) {
      print('WebSocket closed');
      isConnected= false;
      _model.setConnected(isConnected);

    });
  }

  // Check if the WebSocket is connected
  // bool isConnected() {
  //   return channel.sink.done == null && channel.stream.done == null;
  // }


  void sendMessage(String message) {
    // Check if the WebSocket is connected before sending a message
    if (isConnected) {
      channel.sink.add(message);
    } else {
      //print('WebSocket is not connected. Trying to reconnect...');
      Utils.showToastMessage('WebSocket is not connected. Trying to reconnect...');
      //reconnect();
    }
  }


  void closeWebSocket() {
    if (isConnected) {
      channel.sink.close();
    } else {
      print('WebSocket is not connected.');
      //Utils.showToastMessage('WebSocket is not connected.');
    }
  }


}


