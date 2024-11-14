import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meengle/views/main_screen.dart';
import 'package:provider/provider.dart';
import '../data/models/ActionModel.dart';
import '../data/models/ActionRecievedModel.dart';
import '../data/models/ActiveUserModel.dart';
import '../data/models/AnswerRequestModel.dart';
import '../data/models/ConnectionModel.dart';
import '../data/models/HangUpModel.dart';
import '../data/models/IceCandidateRecModel.dart';
import '../data/models/OfferReqModel.dart';
import '../data/models/StartChatAckModel.dart';
import '../main.dart';
import '../services/signalling.dart';
import '../utils/constants.dart';
import '../utils/print.dart';
import 'navigator_provider.dart';

class DashboardProvider extends ChangeNotifier {
  bool isSolo = true;

  bool get getIsSolo => isSolo;

  toggleIsSolo() {
    isSolo = !isSolo;
    notifyListeners();
  }

  int tabValue = 0;

  int get getTabValue => tabValue;

  setTabValue(int value) {
    tabValue = value;
    notifyListeners();
  }

  getAction(val) {
    mDebugPrintApi(val);
    try {
      ActionModel newAction = ActionModel.fromJson(jsonDecode(val));

      switch (newAction.action ?? "") {
        case "connected":
          callConnected(newAction.message);
          break;
        case "active_users":
          callActiveUser(newAction.message);
          break;
        case "start_chat_ack":
          callStartChatAck(newAction.message);
          break;
        case "offer_req":
          callOfferReq(newAction.message);
          break;
        case "ice_candidate_rec":
          callIceCandidateRec(newAction.message);
          break;
        case "answer_req":
          callAnswerReq(newAction.message);
          break;
        case "answer_rec":
          callAnswerRec(newAction.message);
          break;
        case "hang_up_rec":
          callHangUpRec(newAction.message);
          break;
      }
    } catch (e) {
      mDebugPrintApi("Meem --- ${e}");
    }
  }

  addAction({required Object action}) async {
    mDebugPrintApi(action);
    webSocketChannel.sink.add(action);
  }

  clean() {
    tabValue = 0;
    isSolo = true;
    notifyListeners();
  }

  void callConnected(dynamic message) {
    ConnectionModel connectionModel = ConnectionModel.fromJson(message);

    if (connectionModel.success ?? false) {
      // user connected successfully
      mDebugPrintApi("user connected successfully");
      Future.delayed(const Duration(seconds: 1)).then((va) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      });
    } else {
      // user disconnected - show error message
      mDebugPrintApi("user disconnected");
    }
  }

  ActiveUserModel activeUserModel = ActiveUserModel();

  ActiveUserModel get getActiveUserModel => activeUserModel;

  void callActiveUser(dynamic message) {
    ActiveUserModel active = ActiveUserModel.fromJson(message);
    if (active.success ?? false) {
      activeUserModel = active;
      notifyListeners();
    }
  }

  void callStartChatAck(dynamic message) {
    StartChatAckModel startChatAckModel = StartChatAckModel.fromJson(message);
    if (startChatAckModel.success ?? false) {
      mDebugPrintApi("Acknowledged successfully");
      // Provider.of<NavigatorProvider>(navigatorKey.currentContext!,
      //         listen: false)
      //     .setPage(AppPage.videoChat);
    }
  }

  OfferModel offerModel = OfferModel();

  OfferModel get getOfferModel => offerModel;

  void callOfferReq(dynamic message) {
    OfferModel offer = OfferModel.fromJson(message);

    if (offer.success ?? false) {
      offerModel = offer;

      notifyListeners();

      signaling.createRoom();
    }
  }

  Signaling signaling = Signaling();

  List<RTCIceCandidate> pendingCandidates = [];

  Future<void> processPendingCandidates() async {
    final isRemoteExist =
        await signaling.peerConnection!.getRemoteDescription();

    if (isRemoteExist != null) {
      for (RTCIceCandidate candidate in pendingCandidates) {
        await signaling.peerConnection!.addCandidate(candidate);
      }
      pendingCandidates.clear();
    }
  }

  Future<void> callIceCandidateRec(message) async {
    mDebugPrintApi(message);

    try {
      IceCandidateRecModel ice = IceCandidateRecModel.fromJson(message);
      RTCIceCandidate candidate = RTCIceCandidate(
        ice.data?.candidate ?? Constants.defaultString,
        ice.data?.sdpMid ?? Constants.defaultString,
        ice.data?.sdpMLineIndex ?? 0,
      );

      final isRemoteExist =
          await signaling.peerConnection!.getRemoteDescription();

      if (isRemoteExist != null) {
        signaling.peerConnection!.addCandidate(candidate);
      } else {
        // Queue the candidate until remote description is set
        pendingCandidates.add(candidate);
      }

      notifyListeners();
    } catch (e) {
      mDebugPrintError(e);
    }
  }

  void callAnswerReq(message) {
    AnswerRequestModel answerRequestModel =
        AnswerRequestModel.fromJson(message);
    if (answerRequestModel.success ?? false) {
      offerModel = OfferModel(
          success: true,
          data: answerRequestModel.data?.uId ?? Constants.defaultString);
      notifyListeners();
      signaling.joinRoom(
          sdp: answerRequestModel.data?.sdp ?? Constants.defaultString,
          type: answerRequestModel.data?.type ?? Constants.defaultString);
    }
  }

  Future<void> callHangUpRec(dynamic message) async {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(content: Text("recieve hangup")),
    );

    HangUpModel hangUpModel = HangUpModel.fromJson(message);

    if (hangUpModel.success ?? false) {
      // user connected successfully
      mDebugPrintApi("got hangup message");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text("got hangup message")),
      );

      offerModel = OfferModel();
      pendingCandidates.clear();
      await Signaling().hangUpCall();

      notifyListeners();
    }
  }

  void callAnswerRec(message) {
    AnswerRecievedModel answerRecievedModel =
        AnswerRecievedModel.fromJson(message);
    if (answerRecievedModel.success ?? false) {
      offerModel = OfferModel(
          success: true,
          data: answerRecievedModel.data?.uId ?? Constants.defaultString);
      notifyListeners();
      Signaling().peerConnection?.setRemoteDescription(RTCSessionDescription(
          answerRecievedModel.data?.answer, answerRecievedModel.data?.type));

      // Process any pending ICE candidates
      processPendingCandidates();
    }
  }
}
