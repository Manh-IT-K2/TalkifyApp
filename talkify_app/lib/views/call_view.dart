import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:talkify_app/controllers/appwrite_controller.dart';

class CallView extends StatefulWidget {
  final String callerId;
  final String callReceiverId;
  const CallView(
      {super.key, required this.callerId, required this.callReceiverId});

  @override
  _CallViewState createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  late RTCPeerConnection _peerConnection;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  late String _callId;

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    _initWebRTC();
    _listenForCall();
  }

  Future<void> _initWebRTC() async {
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ],
    });

    MediaStream localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });

    _localRenderer.srcObject = localStream;
    localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, localStream);
    });

    _peerConnection.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        _remoteRenderer.srcObject = event.streams[0];
      }
    };

    _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      sendIceCandidate(
          widget.callerId, widget.callReceiverId, candidate.toMap().toString());
    };

    RTCSessionDescription offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);

    // Gửi trạng thái cuộc gọi
    _callId = await sendSignalingData(
        widget.callerId, widget.callReceiverId, offer.sdp!, 'offer');
    updateCallStatus(_callId, 'calling');

    listenForCallStatus(_callId, (status) {
      if (status == 'ended') {
        Navigator.pop(context);
      }
    });
  }

  //
  void _listenForCall() {
    listenForSignaling(widget.callReceiverId, (data) async {
      if (data['type'] == 'offer') {
        RTCSessionDescription offer =
            RTCSessionDescription(data['sdp'], 'offer');
        await _peerConnection.setRemoteDescription(offer);

        RTCSessionDescription answer = await _peerConnection.createAnswer();
        await _peerConnection.setLocalDescription(answer);

        sendSignalingData(
            widget.callReceiverId, widget.callerId, answer.sdp!, 'answer');
      } else if (data['type'] == 'candidate') {
        RTCIceCandidate candidate = RTCIceCandidate(
          data['iceCandidate']['candidate'],
          data['iceCandidate']['sdpMid'],
          data['iceCandidate']['sdpMLineIndex'],
        );
        _peerConnection.addCandidate(candidate);
      }
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video của người nhận
          Positioned.fill(
            child: RTCVideoView(_remoteRenderer, mirror: true),
          ),
          // Video của chính mình (ở góc màn hình)
          Positioned(
            top: 20,
            right: 20,
            width: 120,
            height: 160,
            child: RTCVideoView(_localRenderer, mirror: true),
          ),
          // Nút kết thúc cuộc gọi
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              backgroundColor: Colors.red,
              child: const Icon(Icons.call_end, color: Colors.white),
            ),
          ),
          // Positioned(
          //   bottom: 50,
          //   left: 20,
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       updateCallStatus(_callId, 'ended');
          //       Navigator.pop(context);
          //     },
          //     backgroundColor: Colors.red,
          //     child: const Icon(Icons.call_end, color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}
