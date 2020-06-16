class GetMessageInGroup {
    GetMessageInGroup({
        this.type,
        this.status,
        this.chatType,
        this.idClient,
        this.idArticle,
        this.nameClient,
        this.nameArticle,
        this.image,
        this.messages,
    });

    String type;
    bool status;
    String chatType;
    String idClient;
    String idArticle;
    String nameClient;
    String nameArticle;
    String image;
    List<Message> messages;

    factory GetMessageInGroup.fromJson(Map<String, dynamic> json) => GetMessageInGroup(
        type: json["type"] == null ? null : json["type"],
        status: json["status"] == null ? null : json["status"],
        chatType: json["chatType"] == null ? null : json["chatType"],
        idClient: json["id_client"] == null ? null : json["id_client"],
        idArticle: json["id_article"] == null ? null : json["id_article"],
        nameClient: json["name_client"] == null ? null : json["name_client"],
        nameArticle: json["name_article"] == null ? null : json["name_article"],
        image: json["image"] == null ? null : json["image"],
        messages: json["messages"] == null ? null : List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    );
}

class Message {
    Message({
        this.createdAt,
        this.id,
        this.message,
        this.user,
    });

    DateTime createdAt;
    String id;
    String message;
    User user;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        id: json["_id"] == null ? null : json["_id"],
        message: json["message"] == null ? null : json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

}

class User {
    User({
        this.userId,
        this.nom,
        this.prenoms,
        this.image,
        this.email,
        this.numero,
    });
    
    String userId;
    String nom;
    String prenoms;
    String image;
    String email;
    String numero;

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["id"] == null ? null : json["id"],
        nom: json["nom"] == null ? null : json["nom"],
        prenoms: json["prenoms"] == null ? null : json["prenoms"],
        image: json["image"] == null ? null : json["image"],
        email: json["email"] == null ? null : json["email"],
        numero: json["numero"] == null ? null : json["numero"],
    );

}