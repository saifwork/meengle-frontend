import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:meengle/provider/dashboard_provider.dart';
import 'package:meengle/provider/video_provider.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../utils/actions.dart';
import '../utils/constants.dart';
import '../utils/print.dart';

class Signaling {
  static final Signaling _instance = Signaling._internal();

  factory Signaling() {
    return _instance;
  }

  Signaling._internal();

  static final videoViewModel =
      Provider.of<VideoProvider>(navigatorKey.currentContext!, listen: false);
  static final dashboardViewModel = Provider.of<DashboardProvider>(
      navigatorKey.currentContext!,
      listen: false);

  final Map<String, dynamic> configuration = {
    'iceServers': [
      // STUN
      {"urls": "stun:stun.l.google.com:19302"},
      {"urls": "stun:stun1.l.google.com:19302"},
      {"urls": "stun:stun2.l.google.com:19302"},
      {"urls": "stun:stun3.l.google.com:19302"},
      {"urls": "stun:stun4.l.google.com:19302"},
      {"urls": "stun:stun.services.mozilla.com"},

      // TURN

      // Auth
      {
        "urls": 'turn:relay1.expressturn.com:3478',
        "username": 'efWW4MZVVGKY5O1X8S',
        "credential": 'jHZgw9nrJ07EQRWk'
      },
      {
        "urls": 'turn:relay1.expressturn.com:3478',
        "username": 'efE9XLF5VM4ONSNTDZ',
        "credential": 'Z8NqEhi8am1cWbic'
      },

      // Fake
      {
        "urls": 'turn:relay1.expressturn.com:3478',
        "username": 'efS1GKFN2MP8PQV3Z8',
        "credential": 'kEA7078R1T2MfnxB'
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  RTCDataChannel? dataChannel;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  void disposeLocalResources() {
    // Dispose of the local stream
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        track.stop(); // Stop each track (audio and video)
      });
      _localStream = null;
    }
  }

  // void displayReceivedImage(Uint8List imageBytes) {
  //   // Use an Image widget or any other way to display the image
  //   // For example, you can use Image.memory to display the image
  //   Image image = Image.memory(imageBytes);
  //
  //   print("got image from peer");
  //
  //   showDialog(
  //     context: navigatorKey.currentContext!,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Received Image"),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Image.memory(imageBytes), // Display the image
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text("Close"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Helper function to check if a string is Base64 encoded
  // bool isBase64(String s) {
  //   // Check if the string is a valid Base64 string
  //   try {
  //     // Attempt to decode and check if it matches the original
  //     return base64Encode(base64Decode(s)) == s;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Future<void> pickAndSendImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     // Read the image file as bytes
  //     Uint8List imageBytes = await pickedFile.readAsBytes();
  //
  //     // Convert the image bytes to a Base64 string
  //     String base64Image = base64Encode(imageBytes);
  //
  //     // Send the Base64 string over the Data Channel
  //     dataChannel?.send(RTCDataChannelMessage(base64Image));
  //     print("Image sent");
  //   } else {
  //     print("No image selected");
  //   }
  // }

  Future<void> createRoom() async {
    try {
      peerConnection = await createPeerConnection(configuration);

      // Create Data Channel
      dataChannel =
          await peerConnection!.createDataChannel("chat", RTCDataChannelInit());

      dataChannel?.onMessage = (RTCDataChannelMessage message) {
        print("Received message: ${message.text}");

        // if (message.isBinary) {
        //   // Handle binary message (image data)
        //   Uint8List imageBytes = message.binary;
        //   displayReceivedImage(imageBytes);
        // } else {
        //   String receivedText = message.text;
        //
        //   if (isBase64(receivedText)) {
        //     // If the message text is a valid Base64 string, decode it as an image
        //     Uint8List imageBytes = base64Decode(receivedText);
        //     displayReceivedImage(imageBytes);
        //   } else {
        //     // Handle incoming message (e.g., show text in Snackbar)
        //     ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        //       SnackBar(content: Text(receivedText)),
        //     );
        //   }
        // }
      };
      // Get local media stream (video + audio)
      // await openUserMedia();

      // Add local stream tracks to peer connection
      _localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, _localStream!);
      });

      // Display local video
      videoViewModel.updateLocalRenderer(_localStream);

      // Handle remote stream
      peerConnection?.onTrack = (RTCTrackEvent event) {
        // if (_remoteStream == null) {
        _remoteStream = event.streams[0];

        print("inside remote Stream create");
        videoViewModel.updateRemoteRenderer(_remoteStream);
        // }
      };

      // Create an offer and set local description
      RTCSessionDescription offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);

      dashboardViewModel.addAction(
          action: CompAction.getOfferResToJson(offer: offer.toMap()));

      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        dashboardViewModel.addAction(
            action: CompAction.getIceCandidateResToJson(candidate: candidate));
        listenForConnectionState();
      };
    } catch (e) {
      mDebugPrintApi("Error:  ${e}");
    }
  }

  Future<void> joinRoom({required String sdp, required String type}) async {
    try {
      peerConnection = await createPeerConnection(configuration);

      // Listen for data channel from the creator
      peerConnection?.onDataChannel = (RTCDataChannel channel) {
        dataChannel = channel; // Get the Data Channel created by the creator

        dataChannel?.onMessage = (RTCDataChannelMessage message) {
          print("Received message: ${message.text}");

          // if (message.isBinary) {
          //   // Handle binary message (image data)
          //   Uint8List imageBytes = message.binary;
          //   displayReceivedImage(imageBytes);
          // } else {
          //   String receivedText = message.text;
          //
          //   if (isBase64(receivedText)) {
          //     // If the message text is a valid Base64 string, decode it as an image
          //     Uint8List imageBytes = base64Decode(receivedText);
          //     displayReceivedImage(imageBytes);
          //   } else {
          //     // Handle incoming message (e.g., show text in Snackbar)
          //     ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          //       SnackBar(content: Text(receivedText)),
          //     );
          //   }
          // }
        };
      };

      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        dashboardViewModel.addAction(
            action: CompAction.getIceCandidateResToJson(candidate: candidate));
      };

      // Add local stream tracks to peer connection
      _localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, _localStream!);
      });

      // Display local video
      videoViewModel.updateLocalRenderer(_localStream);

      // Handle remote stream
      peerConnection?.onTrack = (RTCTrackEvent event) {
        // if (_remoteStream == null) {
        _remoteStream = event.streams[0];

        print("inside onTrack remote Stream create");
        videoViewModel.updateRemoteRenderer(_remoteStream);
        // }
      };

      // Set the remote description using the received offer SDP
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(sdp, type),
      );

      // Create an answer and set local description
      RTCSessionDescription answer = await peerConnection!.createAnswer();
      await peerConnection!.setLocalDescription(answer);

      await dashboardViewModel.addAction(
          action: CompAction.getAnswerResToJson(answer: answer));

      // Process any pending ICE candidates
      await dashboardViewModel.processPendingCandidates();

      listenForConnectionState();
    } catch (e) {
      mDebugPrintApi("Error joining room: $e");
    }
  }

  void sendMessage(String text) {
    if (dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      dataChannel?.send(RTCDataChannelMessage(text));
      print("Message sent: $text");
    } else {
      print("Data Channel is not open.");
    }
  }

  void listenForConnectionState() {
    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        print("Both peers are fully connected.");
        Provider.of<DashboardProvider>(navigatorKey.currentContext!,
                listen: false)
            .addAction(action: CompAction.getConnectedPeerReqToJson());
      } else {
        print("Connection state: $state");
      }
    };
  }

  Future<void> getMediaDevices() async {
    try {
      mDebugPrintApi("inside getMediaDevices");
      // Get access to audio and video to populate device list
      await navigator.mediaDevices.getUserMedia({'audio': true, 'video': true});

      mDebugPrintApi("phase 1");
      // Fetch all media devices
      var devices = await navigator.mediaDevices.enumerateDevices();

      mDebugPrintApi("phase 2");
      // Clear the previous lists before adding new devices
      videoViewModel.getAudioInputDevices.clear();
      videoViewModel.getAudioOutputDevices.clear();
      videoViewModel.getVideoInputDevices.clear();

      mDebugPrintApi("phase 3");

      devices.forEach((device) {
        if (device.kind == 'audioinput') {
          videoViewModel.getAudioInputDevices.add(device); // Microphone
        } else if (device.kind == 'audiooutput') {
          videoViewModel.getAudioOutputDevices.add(device); // Speaker
        } else if (device.kind == 'videoinput') {
          videoViewModel.getVideoInputDevices.add(device); // Camera
        }
      });

      mDebugPrintApi("phase 4");

      videoViewModel.selectedAudioInputDevices =
          (videoViewModel.getAudioInputDevices.first);
      videoViewModel.selectedAudioOutputDevices =
          (videoViewModel.getAudioOutputDevices.first);
      videoViewModel.selectedVideoInputDevices =
          (videoViewModel.getVideoInputDevices.first);

      mDebugPrintApi("phase 5");

      // Log the available devices for debugging
      print(
          "Available audio input devices: ${videoViewModel.getAudioInputDevices.first.label}");
      print(
          "Available audio output devices: ${videoViewModel.getAudioOutputDevices.first.label}");
      print(
          "Available video input devices: ${videoViewModel.getVideoInputDevices.first.label}");
    } catch (e) {
      print("Error fetching media devices: $e");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text("Error fetching media devices: $e")),
      );
    }
  }

  Future<void> openUserMedia(String callType) async {
    try {
      mDebugPrintApi("before calling getMediaDevices");
      await getMediaDevices();
      mDebugPrintApi("after calling getMediaDevices");

      // Check if there are available video and audio input devices
      if (videoViewModel.getVideoInputDevices.isEmpty) {
        mDebugPrintApi("No video input devices available.");
      }

      if (videoViewModel.getAudioInputDevices.isEmpty) {
        mDebugPrintApi("No audio input devices available");
      }

      // var constraints = {
      //   'video': true, // Enable video
      //   'audio': {
      //     'deviceId': {'exact': videoViewModel.getAudioInputDevices.first.deviceId}
      //   }
      // };

      var constraints;
      if (callType == Constants.videochat) {
        constraints = {'video': true, 'audio': true};
      } else if (callType == Constants.audiochat) {
        constraints = {'video': false, 'audio': true};
      } else {
        constraints = {'video': false, 'audio': false};
      }

      print("Attempting to access user media...${constraints}");
      _localStream = await navigator.mediaDevices.getUserMedia(constraints);

      mDebugPrintApi(_localStream);

      if (_localStream != null) {
        videoViewModel.updateLocalRenderer(_localStream);
        print("Successfully accessed user media.");
        dashboardViewModel.addAction(
            action: CompAction.getStartChatReqToJson(callType));
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text("Successfully accessed user media.")),
        );
      } else {
        print("Failed to access user media: Stream is null.");
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
              content: Text("Failed to access user media: Stream is null.")),
        );
      }
    } catch (e) {
      mDebugPrintApi("Error accessing user media: $e");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text("Error accessing user media: $e")),
      );
    } finally {
      mDebugPrintApi("Error accessing user media");
    }
  }

  Future<void> switchAudioInput(String? newAudioDeviceId) async {
    try {
      // Define audio constraints with the new audio device ID
      var newAudioConstraints = {
        'audio': {
          'deviceId': {'exact': newAudioDeviceId}
        }
      };

      // Get a new audio stream with the updated constraints
      var newStream =
          await navigator.mediaDevices.getUserMedia(newAudioConstraints);
      var newAudioTrack = newStream.getAudioTracks().first;

      // Replace the current audio track in the existing _localStream
      if (_localStream != null) {
        var currentAudioTrack = _localStream!.getAudioTracks().firstWhere(
              (track) => track.kind == 'audio',
              orElse: () =>
                  newAudioTrack, // Just return the new track if there's no existing audio track
            );

        // Remove and stop the current audio track if it exists and is different from the new one
        if (currentAudioTrack != null && currentAudioTrack != newAudioTrack) {
          _localStream
              ?.removeTrack(currentAudioTrack); // Remove the old audio track
          currentAudioTrack
              .stop(); // Stop the old audio track to release system resources
        }

        _localStream?.addTrack(newAudioTrack); // Add the new audio track
      }

      print("Successfully switched audio input to: $newAudioDeviceId");

      // Re-render the local stream, though video remains unchanged
      videoViewModel.updateLocalRenderer(_localStream);
    } catch (e) {
      print("Error switching audio input: $e");
    }
  }

  Future<void> switchVideoInput(String? newVideoDeviceId) async {
    try {
      // Create new video constraints with the selected device ID
      var newConstraints = {
        'video': {
          'deviceId': {'exact': newVideoDeviceId}
        }
      };

      // Get the new video stream from the selected device
      var newStream = await navigator.mediaDevices.getUserMedia(newConstraints);
      var newVideoTrack = newStream.getVideoTracks().first;

      // Replace the current video track with the new one
      if (_localStream != null) {
        var currentVideoTrack = _localStream!.getVideoTracks().first;
        _localStream?.removeTrack(currentVideoTrack); // Remove the old track
        _localStream?.addTrack(newVideoTrack); // Add the new track
      }

      print("Successfully switched video input to: $newVideoDeviceId");

      // Update the renderer to show the new video stream
      videoViewModel.updateLocalRenderer(
          _localStream); // This updates the UI to display the new video stream
    } catch (e) {
      print("Error switching video input: $e");
    }
  }

  Future<void> switchCamera(bool useBackCamera) async {
    try {
      // Determine which camera to use based on the flag (true for back, false for front)
      var facingMode = useBackCamera ? 'environment' : 'user';

      // Create new video constraints with the selected facing mode
      var newConstraints = {
        'video': {'facingMode': facingMode},
        'audio': true // Keep audio if needed
      };

      // Get the new video stream from the selected camera
      var newStream = await navigator.mediaDevices.getUserMedia(newConstraints);
      var newVideoTrack = newStream.getVideoTracks().first;

      // Replace the current video track with the new one
      if (_localStream != null) {
        var currentVideoTrack = _localStream!.getVideoTracks().first;
        _localStream?.removeTrack(currentVideoTrack); // Remove the old track
        _localStream?.addTrack(newVideoTrack); // Add the new track
      }

      // Update the renderer to show the new video stream
      videoViewModel.updateLocalRenderer(_localStream);

      print(
          "Successfully switched camera to: ${useBackCamera ? 'Back' : 'Front'}");
    } catch (e) {
      print("Error switching camera: $e");
    }
  }

  Future<void> hangUpCall() async {
    try {
      // 1. Close the RTCPeerConnection (disconnects from the other user)
      if (peerConnection != null) {
        await peerConnection!.close();
        peerConnection = null; // Clear the peer connection reference
      }

      // Don't clear local, because will enhance smooth performance

      // Clear Remote
      _remoteStream?.getTracks().forEach((track) => track.stop());
      await _remoteStream?.dispose();
      _remoteStream = null;
      // Optionally, reset the remote video renderer (if showing the other user's video)
      videoViewModel
          .updateRemoteRenderer(null); // Clear the remote video renderer
      print("Successfully disconnected from the other user (hang up).");

      // Optionally show a Snackbar or UI notification
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text("Successfully disconnected from the call.")));
    } catch (e) {
      print("Error during hang up: $e");
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(SnackBar(content: Text("Error during hang up: $e")));
    }
  }

  Future<void> toggleAudio(bool isAudioMuted) async {
    try {
      if (_localStream != null) {
        // Get the audio track from the local stream
        var audioTrack = _localStream!.getAudioTracks().first;

        if (isAudioMuted) {
          // Mute the audio
          audioTrack.enabled = false;
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(content: Text("Microphone muted")),
          );
        } else {
          // Unmute the audio
          audioTrack.enabled = true;
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(content: Text("Microphone unmuted")),
          );
        }
      } else {
        print("No local stream available to mute/unmute.");
      }
    } catch (e) {
      print("Error toggling audio: $e");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text("Error toggling audio: $e")),
      );
    }
  }

  Future<void> toggleVideo(bool isVideoMuted) async {
    try {
      if (_localStream != null) {
        // Get the video track from the local stream
        var videoTrack = _localStream!.getVideoTracks().first;

        if (isVideoMuted) {
          // Mute the video
          videoTrack.enabled = false;
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(content: Text("Video muted")),
          );
        } else {
          // Unmute the video
          videoTrack.enabled = true;
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(content: Text("Video unmuted")),
          );
        }
      } else {
        print("No local stream available to mute/unmute video.");
      }
    } catch (e) {
      print("Error toggling video: $e");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text("Error toggling video: $e")),
      );
    }
  }
}
