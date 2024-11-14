import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meengle/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';
import '../data/models/CompLoading.dart';
import '../data/models/OfferReqModel.dart';
import '../main.dart';
import '../services/signalling.dart';
import '../utils/actions.dart';

class VideoProvider extends ChangeNotifier {
  VideoViewModel() {
    _initializeRenderers();
  }

  LoadingModel loadingModel = LoadingModel();

  LoadingModel get getLoadingModel => loadingModel;

  setLoadingModel(LoadingModel va) {
    loadingModel = va;
    notifyListeners();
  }

  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();

  void _initializeRenderers() async {
    await remoteRenderer.initialize();
    await localRenderer.initialize();
    notifyListeners();
  }

  void disposeRenderers() {
    if (remoteRenderer.srcObject != null) {
      remoteRenderer.srcObject = null;
      remoteRenderer.dispose();
    }
    if (localRenderer.srcObject != null) {
      localRenderer.srcObject = null;
      localRenderer.dispose();
    }
    notifyListeners();
  }


  Future<void> updateRemoteRenderer(MediaStream? stream) async {
    print("inside updateRemoteRenderer");
    if (stream != null) {
      await remoteRenderer.initialize();
      remoteRenderer.srcObject = stream;
      notifyListeners();
    }
  }

  Future<void> updateLocalRenderer(MediaStream? stream) async {
    print("inside updateLocalRenderer");
    if (stream != null) {
      await localRenderer.initialize();
      localRenderer.srcObject = stream;
      notifyListeners();
    }
  }

  bool isMicMuted = false;

  bool get getMicStatus => isMicMuted;

  toggleMicStatus() {
    videoOptionStatus = false;
    isMicMuted = !isMicMuted;
    Signaling().toggleAudio(isMicMuted);
    notifyListeners();
  }

  bool isVideoMuted = false;

  bool get getVideoStatus => isVideoMuted;

  toggleVideoStatus() {
    micOptionStatus = false;
    isVideoMuted = !isVideoMuted;
    Signaling().toggleVideo(isVideoMuted);
    notifyListeners();
  }

  bool micOptionStatus = false;

  bool get getMicOptionStatus => micOptionStatus;

  toggleMicOptionStatus() {
    videoOptionStatus = false;
    micOptionStatus = !getMicOptionStatus;
    notifyListeners();
  }

  bool videoOptionStatus = false;

  bool get getVideoOptionStatus => videoOptionStatus;

  toggleVideoOptionStatus() {
    micOptionStatus = false;
    videoOptionStatus = !getVideoOptionStatus;
    notifyListeners();
  }

  List<MediaDeviceInfo> audioInputDevices = [];

  List<MediaDeviceInfo> get getAudioInputDevices => audioInputDevices;
  MediaDeviceInfo? selectedAudioInputDevices;

  MediaDeviceInfo? get getSelectedAudioInputDevices =>
      selectedAudioInputDevices;

  setSelectedAudioInputDevices(MediaDeviceInfo? val) {
    Signaling().switchAudioInput(val?.deviceId ?? "");
    selectedAudioInputDevices = val;
    notifyListeners();
  }

  List<MediaDeviceInfo> audioOutputDevices = [];

  List<MediaDeviceInfo> get getAudioOutputDevices => audioOutputDevices;
  MediaDeviceInfo? selectedAudioOutputDevices;

  MediaDeviceInfo? get getSelectedAudioOutputDevices =>
      selectedAudioOutputDevices;

  setSelectedAudioOutputDevices(MediaDeviceInfo? val) {
    selectedAudioOutputDevices = val;
    notifyListeners();
  }

  List<MediaDeviceInfo> videoInputDevices = [];

  List<MediaDeviceInfo> get getVideoInputDevices => videoInputDevices;
  MediaDeviceInfo? selectedVideoInputDevices;

  MediaDeviceInfo? get getSelectedVideoInputDevices =>
      selectedVideoInputDevices;

  setSelectedVideoInputDevices(MediaDeviceInfo? val) {
    Signaling().switchVideoInput(val?.deviceId ?? "");
    selectedVideoInputDevices = val;
    notifyListeners();
  }

  hangUpAndReconnect() async {
    Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false)
        .addAction(action: CompAction.getHangUpResToJson());
    Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false)
        .offerModel = OfferModel();
    Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false)
        .pendingCandidates
        .clear();
    await Signaling().hangUpCall();

    notifyListeners();
  }

  forceHangUp() async {
    Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false)
        .addAction(action: CompAction.getForceHangUpResToJson());
    Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false)
        .offerModel = OfferModel();
    Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false)
        .pendingCandidates
        .clear();
    await Signaling().hangUpCall();

    notifyListeners();
  }

  onSuddenDisconnect() async {
    print("inside onDisconnect");
    Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false)
        .addAction(action: CompAction.getDisconnectResToJson());
    Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false)
        .offerModel = OfferModel();
    Provider.of<DashboardProvider>(navigatorKey.currentContext!, listen: false)
        .pendingCandidates
        .clear();
    await Signaling().hangUpCall();
  }

  clean() {
    isMicMuted = false;
    isVideoMuted = false;
    notifyListeners();
  }
}
