enum ActionType { join, sendSingle, sendAll }

class DataModel {
  final String senderId;
  final String? receiverId;
  final String data;
  final ActionType actionType;

  DataModel(
      {required this.senderId,
      this.receiverId,
      required this.data,
      required this.actionType});

  Map<String, String> toMap() {
    return {
      'sender': senderId,
      if (receiverId != null) 'receiver': receiverId!,
      'data': data,
      'action': ActionType.join == actionType
          ? 'join'
          : ActionType.sendAll == actionType
              ? 'all'
              : 'single',
    };
  }

  factory DataModel.setData({
     String ? receiver,
    required String sender,
    required int actionNumber,
    required String message,
  }){
     ActionType actionType = ActionType.join;
     switch(actionNumber){
       case 0:
         actionType = ActionType.join;
         case 1:
         actionType = ActionType.sendSingle;
         default:
         actionType = ActionType.sendAll;
     }
     return DataModel(senderId: sender, data: message, actionType: actionType,receiverId: receiver);
  }
}
