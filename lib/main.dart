import 'package:flutter/material.dart';
import 'package:sprinkle/Overseer.dart';
import 'package:sprinkle/Provider.dart';
import 'package:using_websocket/socket_manager/ChatCommunication.dart';
import 'package:sprinkle/SprinkleExtension.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      data: Overseer()
      .register<TchatCommunication>(()=> TchatCommunication())
      ,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final TextEditingController _name = new TextEditingController();
  String playerName;
  List<dynamic> playersList = <dynamic>[];
  TchatCommunication manager;

  @override
  void initState() {
    super.initState();
    ///
    /// Demandons d'être notifié pour chaque message
    /// envoyé par le serveur
    ///
    Future.delayed(Duration.zero,(){
       manager = context.fetch<TchatCommunication>();
       manager.addListener(_onGameDataReceived);
    });
    //tchat.addListener(_onGameDataReceived);
  }

  @override
  void dispose() {
    manager.removeListener(_onGameDataReceived);
    super.dispose();
  }

  /// -------------------------------------------------------------------
  /// Cette routine gère tous les messages envoyés par le serveur.
  /// Seules les 2 actions suivantes, sont d'utilité dans cette page
  ///  - players_list
  ///  - new_game
  /// -------------------------------------------------------------------
  _onGameDataReceived(message) {
    switch (message["type"]) {
      ///
      /// A chaque fois qu'un utilisateur rejoint, nous devons
      ///   * enregistrer la nouvelle liste de joueurs
      ///   * rafraîchir la liste des joueurs
      ///
      case "newConnection":
        print('newConnection: A la nouvelle collection je recupere les group de tchat ququel un user est affecter');
        break;

      case 'getMessages':
        if(message["chatType"] == 'groupe'){
          print('push vers la page de tchat for groupe');
        }else if(message["chatType"] == 'chat'){
          print('push vers la page de tchat for Chat');
        }
        break;

      case "initChat":
        print('newConnection: A la nouvelle collection je recupere les group de tchat ququel un user est affecter');
        break;
    }
  }

  /// -----------------------------------------------------------
  /// Lorsque l'utilisateur n'a pas encore rejoint, nous le 
  /// laissons introduire son nom et rejoindre la liste des
  /// joueurs
  /// -----------------------------------------------------------
  Widget _buildJoin() {
    if (false) {
      return new Container();
    }
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TextField(
            controller: _name,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              hintText: 'Enter your name',
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(32.0),
              ),
              icon: const Icon(Icons.person),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new RaisedButton(
              onPressed: _onGameJoin,
              child: new Text('Join...'),
            ),
          ),
        ],
      ),
    );
  }

  /// ------------------------------------------------------
  /// L'utilisateur veut rejoindre.  Envoyons son nom.
  /// Maintenant que nous avons le nom du joueur, nous 
  /// pouvons afficher la liste des tous les joueurs.
  /// ------------------------------------------------------
  _onGameJoin() {
    //manager.sendNewConnection(action: "newConnection", idClient: "1");
    //manager.sendGetMessagesGroup(action: "getMessages", chatType: "groupe", idClient: "1", idArticle: "1");
    // manager.sendInitSingleChat(action: "initChat", peerNumber: "88482118", initiatorId: "1", peerId: "2");
    // manager.sendAddGroup(action: "addGroup", idClient: "1", nameClient: "koffi", idArticle: "2", nomArticle: "Flutter to developpe Application", image: "kofii.png");
    // manager.sendGetMessagesSingleTchat(action: "getMessages", chatType: "chat", initiatorId: "1", peerId: "2");
    // manager.sendAddGroupMessage(action: "addGroupMessage", idClient: "1", idArticle: "2", content: "Course for beginer in flutter");
    // manager.sendAddChatMessage(action: "addChatMessage", commentatorId: "1", peerId: "2", content: "Course for beginer in flutter");
    
    /// Forcer un rafraîchissement 
    setState(() {});
  }

  /// ------------------------------------------------------
  /// Construction de la liste des joueurs
  /// ------------------------------------------------------
  

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('TicTacToe'),
        ),
        body: SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildJoin(),
              new Text('List of players:'),
              //_playersList(),
            ],
          ),
        ),
      ),
    );
  }
}
