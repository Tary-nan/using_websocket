
import 'package:using_websocket/socket_manager/models/get_message_model.dart';
import 'package:using_websocket/socket_manager/models/get_message_tchat_model.dart';
import 'package:using_websocket/socket_manager/models/message_tchatSingle.dart';
import 'package:using_websocket/socket_manager/models/tchat_model.dart';

class ServiceTchat {

  static List<TchatModel> tchatList(List response){
    Iterable<TchatModel> data = List.from(response.map((e) => TchatModel.fromJson(e)));
    return data.toList();
  }

  static GetMessageInGroup getMessageInGroup (Map response){
    return GetMessageInGroup.fromJson(response);
  }

  static GetMessageInChat getMessageInChat (Map response){
    return GetMessageInChat.fromJson(response);
  }
   static InitChatModel initChat (Map response){
    return InitChatModel.fromJson(response);
  }
  
  
}