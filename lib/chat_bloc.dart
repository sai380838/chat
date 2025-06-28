import 'package:chat/chat_message_model.dart';
import 'package:chat/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc(this._repository) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<_ChatUpdated>(_onChatUpdated); // ✅ Register listener
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    final stream = _repository.getMessages(event.currentUser, event.peerUser);
    stream.listen((messages) {
      add(_ChatUpdated(messages));
    });
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    await _repository.sendMessage(
      event.message,
      event.receiverToken,
    ); // ✅ Pass token
  }

  void _onChatUpdated(_ChatUpdated event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.messages));
  }
}
