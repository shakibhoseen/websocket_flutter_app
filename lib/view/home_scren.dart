import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:websocket_flutter_app/design/my_text_field.dart';
import 'package:websocket_flutter_app/view/component/connection_design.dart';
import 'package:websocket_flutter_app/view/component/drop_down_menu.dart';
import 'package:websocket_flutter_app/view_model/home_view_model.dart';

import '../model/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final idController = TextEditingController();
  final messageController = TextEditingController();
  final hideInputNotifier = ValueNotifier<int>(0);
  final deviceRegister = ValueNotifier('');
  var actionNumber = 0;

  var homeModel = HomeViewModel();

  void refresh(){
    homeModel.reInit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropDownMenu(onChanged: (int? value) {
                              actionNumber = value ?? 0;
                              hideInputNotifier.value = actionNumber;
                            }),
                            SizedBox(width: 12,),
                            ElevatedButton(onPressed: (){
                              refresh();
                            },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown
                                ),

                                child: Text('Refresh'),),
                            SizedBox(width: 10,),
                            StreamBuilder<bool>(
                              initialData: false,
                              stream: homeModel.isConnected(),

                              builder: (context, snapshot) {
                                print(snapshot.data);
                                return ConnectionDesign(color: snapshot.data! ? Colors.green: Colors.brown);
                              }
                            ),

                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: deviceRegister,
                          builder: (context, value, child) {
                            if(value.isEmpty){
                              return const SizedBox(
                                height: 30,
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(value),
                            );
                          }
                        ),
                        ValueListenableBuilder(
                          valueListenable: hideInputNotifier,
                          builder: (context, value, child) {
                            if(value==2){
                              return Container();
                            }
                            return MyTextField(
                                controller: idController,
                                hintText: value==0? 'enter your id' : 'enter the otherId',
                                obsecureText: false,
                                keyboardType: TextInputType.text);
                          }
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                            controller: messageController,
                            hintText: 'message',
                            obsecureText: false,
                            keyboardType: TextInputType.text),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                              foregroundColor: Colors.deepPurple.shade50,
                              shadowColor: Colors.deepPurple,
                              elevation: 3,
                            ),
                            onPressed: () {
                              homeModel.sendData(
                                  id: idController,
                                  message: messageController,
                                  actionNumber: actionNumber,
                                  context: context);
                              if(actionNumber==0){
                                deviceRegister.value = 'Your device Register as ${messageController.text} and id ${idController.text}';
                              }
                            },
                            child: const Text('Send to WebSocket')),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text('Server response', style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Expanded(
                        child: StreamBuilder<List<User>>
                          (stream: homeModel.getMessageState(),
                           initialData: [],
                           builder: (context, snapshot) {

                             return ListView.builder(

                               itemCount: snapshot.data?.length ??0,
                               itemBuilder: (context, index) {
                                 final user = snapshot.data?[index];
                               return Expanded(

                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Align(
                                     alignment: Alignment.centerLeft,
                                     child: Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                       child: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                         Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                           child: Text(user?.device ??'', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                         ),
                                           Container(

                                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                               decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(12),
                                                 color: Colors.brown.shade200,
                                                 boxShadow: [
                                                   BoxShadow(blurRadius: 12, color: Colors.grey.shade900, offset: Offset(6,6))
                                                 ]
                                               ),
                                               child: Text(user?.message ??'',)),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               );
                             },);
                           },
                        ),
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
