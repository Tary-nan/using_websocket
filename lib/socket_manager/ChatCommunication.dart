import 'dart:convert';
import 'package:rxdart/rxdart.dart';

import 'package:flutter/foundation.dart';
import 'package:sprinkle/Manager.dart';
import 'package:using_websocket/socket_manager/models/get_message_model.dart';
import 'package:using_websocket/socket_manager/models/get_message_tchat_model.dart';
import 'package:using_websocket/socket_manager/models/message_tchatSingle.dart';
import 'package:using_websocket/socket_manager/models/tchat_model.dart';
import 'package:using_websocket/socket_manager/services/tchat_service.dart';
import 'package:using_websocket/socket_manager/websocket_helper.dart';

///
/// A nouveau, variable globale
///
//TchatCommunication tchat = new TchatCommunication();

class TchatCommunication  implements Manager{

  
  ///
  /// Stream Object 
  ///
  
  BehaviorSubject<List<TchatModel>> _subjectTchatModel = BehaviorSubject<List<TchatModel>>();
  Stream<List<TchatModel>> get collectionTchatModel$ => _subjectTchatModel.stream;

  BehaviorSubject<GetMessageInGroup> _subjectgetMessageGroup = BehaviorSubject<GetMessageInGroup>();
  Stream<GetMessageInGroup> get collectiongetMessageGroup$ => _subjectgetMessageGroup.stream;

  BehaviorSubject<GetMessageInChat> _subjectgetMessageChat = BehaviorSubject<GetMessageInChat>();
  Stream<GetMessageInChat> get collectiongetMessageChat$ => _subjectgetMessageChat.stream;
    

  String _chatType = "";

  ///
  /// Avant d'émettre l'action "join", le joueur n'a pas encore d'identifiant unique
  ///
  String _clientID = "";

 TchatCommunication(){
    ///
    /// Initialisons la communication WebSockets
    ///
    sockets.initCommunication();

    ///
    /// et demandons d'être notifié à chaque fois qu'un message est envoyé par le serveur
    /// 
    sockets.addListener(_onMessageReceived);
  }

  ///
  /// Retourne le Type de Tchat
  ///
  String get chatType => _chatType;



  /// ----------------------------------------------------------
  /// Gestion de tous les messages en provenance du serveur
  /// ----------------------------------------------------------
  _onMessageReceived(serverMessage){
    ///
    /// Comme les messages sont envoyés sous forme de chaîne de caractères
    /// récupérons l'objet JSON correspondant
    ///
    Map message = json.decode(serverMessage);
    print(message);
    switch(message["type"]){
      ///
      /// Quand la communication est établie, le serveur
      /// Nous cablons les differents events
    ///
    
    /// 
      case 'newConnection':
        {
          if(message['status']){
            List response = message['tableau'];
            List<TchatModel> data =  ServiceTchat.tchatList(response);
            _subjectTchatModel.add(data);
          }
        }
        break;
      
      case 'getMessages':
        {
          _chatType = message['chatType'];
          if(message['status'] && message['chatType'] == 'groupe'){
            GetMessageInGroup messageGroup = ServiceTchat.getMessageInGroup(message);
            _subjectgetMessageGroup.add(messageGroup);
          }else if(message['status'] && message['chatType'] == 'chat'){
            GetMessageInChat messageChat = ServiceTchat.getMessageInChat(message);
            _subjectgetMessageChat.add(messageChat);
          }
        }
        break;

        case 'initChat':
        {
          // Sans la vue update the list to group
          if(message['status'] && message['setChat']){//GetMessageInChat
          InitChatModel initChat = ServiceTchat.initChat(message);
          print(initChat);
          }else{
            

          }
        }
        break;

        case 'addGroup':
        {
          // Sans la vue update the list to group
          if(message['status']){
            List response = message['tableau'];
            List<TchatModel> data =  ServiceTchat.tchatList(response);
            _subjectTchatModel.add(data);
          }
        }
        break;


      ///
      /// Pour tout autre message entrant,
      /// envoyons-le à tous les "listeners".
      ///
      default:
        _listeners.forEach((Function callback){
          callback(message);
        });
        break;
    }
  }

  /// ----------------------------------------------------------
  /// Méthode d'envoi des messages au serveur
  /// ----------------------------------------------------------
  sendNewConnection({String action, String idClient}){
    ///
    /// Quand un joueur rejoint, nous devons mémoriser son nom
    ///
    if (action == 'newConnection'){
      _clientID = idClient;
    }

    ///
    /// Envoi d'une action au serveur
    /// Pour envoyer le message, nous transformons l'objet
    /// JSON en chaîne de caractères 
    ///
    sockets.send(json.encode({
      "type": action,
      "id_client": idClient
    }));
  }

  void sendGetMessagesGroup({String action, String chatType, String idClient, String idArticle}){
  
    ///
    /// Envoi d'une action au serveur
    /// Pour envoyer le message, nous transformons l'objet
    /// JSON en chaîne de caractères 
    ///
    sockets.send(json.encode({
      "type": action,
      "chatType": chatType,
      "id_client": idClient,
      "id_article": idArticle,
    }));
  }

  void sendGetMessagesSingleTchat({String action, String chatType, String initiatorId, String peerId}){
  
    ///
    /// Envoi d'une action au serveur
    /// Pour envoyer le message, nous transformons l'objet
    /// JSON en chaîne de caractères 
    ///
    sockets.send(json.encode({
      "type": action,
      "chatType": chatType,
      "initiator_id": initiatorId,
      "peer_id": peerId,
    }));
  }

  void sendInitSingleChat({String action, String initiatorId, String peerId, String peerNumber}){
  
    ///
    /// Envoi d'une action au serveur
    /// Pour envoyer le message, nous transformons l'objet
    /// JSON en chaîne de caractères 
    ///
    sockets.send(json.encode({
      "type": action,
      "initiator_id": initiatorId,
      "peer_id": peerId,
      "peer_number": peerNumber
    }));
  }

  void sendAddGroup({String action, String idClient, String nameClient, String idArticle, String nomArticle, String image}){
    sockets.send(json.encode({
      "type": action,
      "id_client": idClient,
      "name_client": nameClient,
      "id_article": idArticle,
      "nom_article": nomArticle,
      "image": image,
    }));
  }

void sendAddGroupMessage({String action, String idClient, String idArticle, String content}){
    sockets.send(json.encode({
      "type": action,
      "id_client": idClient,
      "id_article": idArticle,
      "content": content,
    }));
  }

void sendAddChatMessage({String action, String commentatorId, String peerId, String content}){
    sockets.send(json.encode({
      "type": action,
      "commentator_id": commentatorId,
      "peer_id": peerId,
      "content": content,
    }));
  }

  

  /// ==========================================================
  ///
  /// Listeners pour permettre aux différentes pages/écrans 
  /// d'être notifiés à chaque réception d'un message du serveur
  ///
  ObserverList<Function> _listeners = new ObserverList<Function>();

  addListener(Function callback){
    _listeners.add(callback);
  }
  removeListener(Function callback){
    _listeners.remove(callback);
  }

  @override
  void dispose() {
    _subjectTchatModel.close();
    _subjectgetMessageGroup.close();
    _subjectgetMessageChat.close();
  }
}