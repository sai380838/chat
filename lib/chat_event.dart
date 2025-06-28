part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {
  final String currentUser;
  final String peerUser;

  LoadMessages(this.currentUser, this.peerUser);
}

class SendMessage extends ChatEvent {
  final ChatMessage message;
  final  String receiverToken;
  SendMessage(this.message,this.receiverToken);
}

class _ChatUpdated extends ChatEvent {
  final List<ChatMessage> messages;

  _ChatUpdated(this.messages);
}
