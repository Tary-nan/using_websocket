class TchatModel {
  final String tchatType;
  final String idClient;
  final String nameClient;
  final String idArticle;
  final String nomArticle;
  final String imageArticle;
  final String lastMessage;

  TchatModel({this.tchatType, this.idClient, this.nameClient, this.idArticle, this.nomArticle, this.imageArticle, this.lastMessage});
  factory TchatModel.fromJson(Map<String, dynamic>json){
    return TchatModel(
      tchatType: json['tchatType'],
      idClient: json['idClient'],
      nameClient: json['tchatType'],
      idArticle: json['idArticle'],
      nomArticle: json['nomArticle'],
      imageArticle: json['imageArticle'],
      lastMessage: json['lastMessage'],
    );
  }

  
}