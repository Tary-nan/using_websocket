class InitChatModel {
    InitChatModel({
        this.type,
        this.initiatorId,
        this.peerId,
        this.peerNumber,
        this.wsId,
        this.status,
        this.setChat,
        this.initiator,
        this.peer,
        this.messages,
    });

    String type;
    String initiatorId;
    String peerId;
    String peerNumber;
    String wsId;
    bool status;
    bool setChat;
    Initiator initiator;
    Initiator peer;
    List<Message> messages;

    factory InitChatModel.fromJson(Map<String, dynamic> json) => InitChatModel(
        type: json["type"] == null ? null : json["type"],
        initiatorId: json["initiator_id"] == null ? null : json["initiator_id"],
        peerId: json["peer_id"] == null ? null : json["peer_id"],
        peerNumber: json["peer_number"] == null ? null : json["peer_number"],
        wsId: json["ws_id"] == null ? null : json["ws_id"],
        status: json["status"] == null ? null : json["status"],
        setChat: json["setChat"] == null ? null : json["setChat"],
        initiator: json["initiator"] == null ? null : Initiator.fromJson(json["initiator"]),
        peer: json["peer"] == null ? null : Initiator.fromJson(json["peer"]),
        messages: json["messages"] == null ? null : List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    );
}

class Initiator {
    Initiator({
        this.initiatorId,
        this.nom,
        this.prenoms,
        this.image,
        this.email,
        this.pays,
        this.numero,
    });

    String initiatorId;
    String nom;
    String prenoms;
    String image;
    String email;
    String pays;
    String numero;

    factory Initiator.fromJson(Map<String, dynamic> json) => Initiator(
        initiatorId: json["id"] == null ? null : json["id"],
        nom: json["nom"] == null ? null : json["nom"],
        prenoms: json["prenoms"] == null ? null : json["prenoms"],
        image: json["image"] == null ? null : json["image"],
        email: json["email"] == null ? null : json["email"],
        pays: json["pays"] == null ? null : json["pays"],
        numero: json["numero"] == null ? null : json["numero"],
    );
}

class Message {
    Message({
        this.createdAt,
        this.id,
        this.user,
        this.msgId,
        this.content,
    });

    DateTime createdAt;
    String id;
    Initiator user;
    String msgId;
    String content;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        id: json["_id"] == null ? null : json["_id"],
        user: json["user"] == null ? null : Initiator.fromJson(json["user"]),
        msgId: json["msg_id"] == null ? null : json["msg_id"],
        content: json["content"] == null ? null : json["content"],
    );

}
