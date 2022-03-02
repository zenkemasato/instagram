// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetail() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  // 新規登録処理
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "エラー文";
    try {
      if (username.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // firebaseAuth にユーザー登録
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // storageに登録
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        // firestore に登録
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "メールアドレスが入力されていません";
      } else if (err.code == "weak-password") {
        res = "6文字以上で設定してください";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // ログイン処理
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'some error codes';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = "未記入事項があります";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // ログアウト処理
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
