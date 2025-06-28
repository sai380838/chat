import 'package:chat/local_storage.dart';
import 'package:chat/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static const _userKey = 'user_data';

  Future<UserModel?> register({
    required String email,
    required String password,
    required String displayName,
    required String mobile,
    required String country,
    required String token,
  }) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    final user = UserModel(
      email: email,
      displayName: displayName,
      mobile: mobile,
      country: country,
      token: token,
    );

    await saveUser(user);
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(uid)
        .set(user.toJson());
    return user;
  }

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Try reading from secure storage (user saved at registration)
    // final data = await LocalStorageService.read(_userKey);
    // if (data != null) {
    //   return UserModel.fromJson(json.decode(data));
    // }

    // Fallback: construct minimal user
    return UserModel(
      email: email,
      displayName: "Unknown",
      mobile: "Unknown",
      country: "Unknown",
      token: "",
    );
  }

  Future<void> saveUser(UserModel user) async {
    await LocalStorageService.save(_userKey, json.encode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final data = await LocalStorageService.read(_userKey);
    if (data == null) return null;
    return UserModel.fromJson(json.decode(data));
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await LocalStorageService.clear();
  }
}
