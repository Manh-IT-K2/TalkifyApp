import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:talkify_app/services/appwrite_service.dart';

class SignalingService {
  final Databases database = AppwriteService.databases;
  final Realtime realtime = AppwriteService.realtime;
  final String collectionId = 'signalings'; // ID của Collection

  /// Gửi Offer/Answer lên Appwrite
  Future<void> sendSignalingData(String callerId, String calleeId, String sdp, String type) async {
    await database.createDocument(
      databaseId: 'webrtc',
      collectionId: collectionId,
      documentId: ID.unique(),
      data: {
        'callerId': callerId,
        'calleeId': calleeId,
        'sdp': sdp,
        'type': type,
      },
    );
  }

  /// Gửi ICE Candidate
  Future<void> sendIceCandidate(String callerId, String calleeId, String candidate) async {
    await database.createDocument(
      databaseId: 'webrtc',
      collectionId: collectionId,
      documentId: ID.unique(),
      data: {
        'callerId': callerId,
        'calleeId': calleeId,
        'iceCandidate': candidate,
        'type': 'candidate',
      },
    );
  }

  /// Lắng nghe tín hiệu từ Appwrite
  void listenForSignaling(String userId, Function(Map<String, dynamic>) onData) {
    final subscription = realtime.subscribe(
      ['databases.webrtc.collections.$collectionId.documents']
    );

    subscription.stream.listen((RealtimeMessage event) {
      if (event.payload == null || event.payload.isEmpty) {
        print("⚠️ Không có dữ liệu từ Realtime");
        return;
      }

      try {
        final Map<String, dynamic> data = jsonDecode(event.payload as String);
        
        if (data.containsKey('calleeId') && data['calleeId'] == userId) {
          onData(data);
        }
      } catch (e) {
        print("❌ Lỗi giải mã JSON: $e");
      }
    });
  }
}
