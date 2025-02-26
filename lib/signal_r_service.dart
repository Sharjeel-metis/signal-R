import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late HubConnection _hubConnection;
  final String _serverUrl = "http://10.0.2.2:5298/chatHub";


  SignalRService() {
    _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl)
        .withAutomaticReconnect()
        .build();
  }

  Future<void> connect() async {
    try {
      await _hubConnection.start();
      print(" Connected to SignalR Server");
    } catch (e) {
      print("Error connecting: $e");
    }
  }

  void listenForMessages(Function(String user, String message) onMessageReceived) {
    _hubConnection.on("ReceiveMessage", (arguments) {
      if (arguments != null && arguments.length >= 2) {
        String user = arguments[0] as String;
        String message = arguments[1] as String;
        onMessageReceived(user, message);
      }
    });
  }

  Future<void> sendMessage(String user, String message) async {
    if (_hubConnection.state == HubConnectionState.Connected) {
      try {
        await _hubConnection.invoke("SendMessage", args: [user, message]);
        print("Sent message: $message");
      } catch (e) {
        print("Error sending message: $e");
      }
    } else {
      print(" Not connected to SignalR!");
    }
  }

  Future<void> disconnect() async {
    await _hubConnection.stop();
    print("Disconnected from SignalR Server");
  }
}
