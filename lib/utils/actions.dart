import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meengle/provider/dashboard_provider.dart';
import 'package:meengle/utils/print.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'constants.dart';

class CompAction {
  static getPingReqToJson() {
    return jsonEncode({"action": "ping", "data": ""});
  }

  static getStartChatReqToJson(String type) {
    Map<String, dynamic> jsonMap = {
      'action': 'start_chat_req',
      'data': {
        'type': type,
      }
    };
    return jsonEncode(jsonMap);
  }

  static getOfferResToJson({required dynamic offer}) {
    String uId = Provider.of<DashboardProvider>(navigatorKey.currentContext!,
                listen: false)
            .getOfferModel
            .data ??
        Constants.defaultString;

    Map<String, dynamic> jsonMap = {
      'action': 'offer_res',
      'data': {
        'uId': uId,
        'sdp': offer['sdp'], // Extract 'sdp' from the offer object
        'type': offer['type'] ?? "offer", // Ensure 'type' is 'offer'
      }
    };
    mDebugPrintApi("Mee - ${jsonEncode(jsonMap)}");
    return jsonEncode(jsonMap);
  }

  static getIceCandidateResToJson({
    required RTCIceCandidate candidate,
  }) {
    String uId = Provider.of<DashboardProvider>(navigatorKey.currentContext!,
                listen: false)
            .getOfferModel
            .data ??
        Constants.defaultString;

    Map<String, dynamic> jsonMap = {
      'action': 'ice_candidate_res',
      'data': {
        'uId': uId,
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      }
    };

    return jsonEncode(jsonMap);
  }

  static getAnswerResToJson({required RTCSessionDescription answer}) {
    String uId = Provider.of<DashboardProvider>(navigatorKey.currentContext!,
                listen: false)
            .getOfferModel
            .data ??
        Constants.defaultString;

    Map<String, dynamic> jsonMap = {
      'action': 'answer_res',
      'data': {
        'uId': uId,
        'answer': answer.sdp,
        'type': answer.type,
      }
    };

    return jsonEncode(jsonMap);
  }

  static getDisconnectResToJson() {
    String uId = Provider.of<DashboardProvider>(navigatorKey.currentContext!,
                listen: false)
            .getOfferModel
            .data ??
        Constants.defaultString;

    Map<String, dynamic> jsonMap = {
      'action': 'dis_connected',
      'data': {
        'uId': uId,
      }
    };

    return jsonEncode(jsonMap);
  }

  static getHangUpResToJson() {
    String uId = Provider.of<DashboardProvider>(navigatorKey.currentContext!,
                listen: false)
            .getOfferModel
            .data ??
        Constants.defaultString;

    Map<String, dynamic> jsonMap = {
      'action': 'hang_up_res',
      'data': {
        'uId': uId,
      }
    };

    return jsonEncode(jsonMap);
  }

  static getConnectedPeerReqToJson() {
    String uId = Provider.of<DashboardProvider>(navigatorKey.currentContext!,
                listen: false)
            .getOfferModel
            .data ??
        Constants.defaultString;

    Map<String, dynamic> jsonMap = {
      'action': 'action_connected_peer_req',
      'data': {
        'pId': uId,
      }
    };

    return jsonEncode(jsonMap);
  }

  static getForceHangUpResToJson() {
    String uId = Provider.of<DashboardProvider>(navigatorKey.currentContext!,
                listen: false)
            .getOfferModel
            .data ??
        Constants.defaultString;

    Map<String, dynamic> jsonMap = {
      'action': 'force_hang_up_res',
      'data': {
        'uId': uId,
      }
    };

    return jsonEncode(jsonMap);
  }
}
