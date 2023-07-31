class Message {
  Message({
    required this.toId,
    required this.read,
    required this.msq,
    required this.type,
    required this.fromId,
    required this.sent,
  });
  late final String toId;
  late final String read;
  late final String msq;
  late final Type type;
  late final String fromId;
  late final String sent;
  
  Message.fromJson(Map<String, dynamic> json){
    toId = json['toId'].toString();
    read = json['read'].toString();
    msq = json['msq'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['read'] = read;
    data['msq'] = msq;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }
}

enum Type{
  text , image
}