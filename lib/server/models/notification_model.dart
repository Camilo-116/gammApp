class Notification {
  /// The uuid of the user that received the notification.
  final String receiverUUID;

  /// The username of the user that received the notification.
  final String receiverUsername;

  /// The uuid of the user that sent the notification.
  final String senderUUID;

  /// The username of the user that sent the notification.
  final String senderUsername;

  /// The type of the notification.
  final String typeNotification;

  /// Creates a new notification.
  Notification({
    required this.receiverUUID,
    required this.receiverUsername,
    required this.senderUUID,
    required this.senderUsername,
    required this.typeNotification,
  });

  /// Translates the notification to a map.
  Map<String, dynamic> toMap() {
    return {
      'receiverUUID': receiverUUID,
      'receiverUsername': receiverUsername,
      'senderUUID': senderUUID,
      'senderUsername': senderUsername,
      'typeNotification': typeNotification,
    };
  }
}
