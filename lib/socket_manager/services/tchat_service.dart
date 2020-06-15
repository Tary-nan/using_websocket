
import 'package:using_websocket/socket_manager/models/tchat_model.dart';

class ServiceTchat {

  static List<TchatModel> tchatList(List response){
    Iterable<TchatModel> data = List.from(response.map((e) => TchatModel.fromJson(e)));
    return data.toList();
  }
  
}