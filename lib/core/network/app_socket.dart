import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef PoolDataHandler = void Function(Map<String, dynamic> data);

/// Single shared Socket.IO connection for realtime IoT data.
///
/// Backend (Fastify + socket.io) exposes:
///  - emit  `join-pool`  { nodeId }   -> joins room `pool:<nodeId>`
///  - emit  `leave-pool` { nodeId }   -> leaves the room
///  - on    `pool-data`  { node_id, ph, temp, receivedAt }
class AppSocket {
  AppSocket._();
  static final AppSocket instance = AppSocket._();

  io.Socket? _socket;

  /// Rooms we want to be in. Re-joined automatically after a reconnect,
  /// because server-side rooms are dropped when a socket disconnects.
  final Set<String> _rooms = {};

  /// Page-level listeners. Using our own fan-out (instead of socket.on/off per
  /// page) avoids one page's dispose removing another page's listener.
  final Set<PoolDataHandler> _handlers = {};

  io.Socket _ensureSocket() {
    final existing = _socket;
    if (existing != null) return existing;

    final socket = io.io(
      AppConstants.socketURL,
      io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );

    debugPrint('[AppSocket] Menghubungkan ke ${AppConstants.socketURL}');

    socket.onConnect((_) {
      debugPrint('[AppSocket] Terhubung ✅ (id: ${socket.id}) rooms: $_rooms');
      // Re-join all desired rooms after (re)connect.
      for (final nodeId in _rooms) {
        socket.emit('join-pool', {'nodeId': nodeId});
      }
    });

    socket.onDisconnect((reason) {
      debugPrint('[AppSocket] Terputus ❌ ($reason)');
    });

    socket.onConnectError((err) {
      debugPrint('[AppSocket] Gagal konek ⚠️ $err');
    });

    socket.onError((err) {
      debugPrint('[AppSocket] Error ⚠️ $err');
    });

    socket.on('pool-data', (data) {
      debugPrint('[AppSocket] pool-data diterima 📥 $data');
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        debugPrint(
          '[AppSocket]   → node_id=${map['node_id']}, ph=${map['ph']}, '
          'temp=${map['temp']}, receivedAt=${map['receivedAt']}',
        );
        for (final handler in _handlers.toList()) {
          handler(map);
        }
      }
    });

    _socket = socket;
    return socket;
  }

  /// Opens the connection if it is not already connected.
  void connect() {
    final socket = _ensureSocket();
    if (!socket.connected) socket.connect();
  }

  void joinPool(String nodeId) {
    if (nodeId.isEmpty) return;
    _rooms.add(nodeId);
    _ensureSocket().emit('join-pool', {'nodeId': nodeId});
  }

  void leavePool(String nodeId) {
    if (nodeId.isEmpty) return;
    _rooms.remove(nodeId);
    _socket?.emit('leave-pool', {'nodeId': nodeId});
  }

  void addPoolDataListener(PoolDataHandler handler) => _handlers.add(handler);

  void removePoolDataListener(PoolDataHandler handler) =>
      _handlers.remove(handler);

  /// Fully tears down the connection (e.g. on logout).
  void dispose() {
    _socket?.dispose();
    _socket = null;
    _rooms.clear();
    _handlers.clear();
  }
}
