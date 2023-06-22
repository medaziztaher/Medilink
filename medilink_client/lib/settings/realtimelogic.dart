import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/user.dart';

import 'realtime.dart';

class SocketMethods extends GetxController {
  final _socket = SocketClient.instance.socket!;

  addUser([String? userId]) async {
    String? connectedUserId = await queryUserID();
    String? user;
    if (connectedUserId != null) {
      user = connectedUserId;
    } else if (userId != null) {
      user = userId;
    } else {
      return;
    }
    _socket.emit('addUser', user);
  }

  sendMessage(String senderId, String receiverId, String content) {
    _socket.emit('sendMessage', {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
    });
  }

  followUser(String senderId, String receiverId) {
    Map<String, dynamic> data = {
      'patientId': senderId,
      'providerId': receiverId,
    };
    _socket.emit('follow', data);
  }

  unfollowUser(String senderId, String receiverId) {
    Map<String, dynamic> data = {
      'senderId': senderId,
      'receiverId': receiverId,
    };
    _socket.emit('unfollow', data);
  }

  cancelRequest(String senderId, String receiverId) {
    Map<String, dynamic> data = {
      'patientId': senderId,
      'providerId': receiverId,
    };
    _socket.emit('cancelRequest', data);
  }

  approveRequest(String logedinUser, String receiverId) {
    Map<String, dynamic> data = {
      'patientId': receiverId,
      'providerId': logedinUser,
    };
    _socket.emit('approveRequest', data);
  }

  rejectRequest(String logedinUser, String receiverId) {
    Map<String, dynamic> data = {
      'patientId': receiverId,
      'providerId': logedinUser,
    };
    _socket.emit('rejectRequest', data);
  }

  providerveriffication(String userId) {
    Map<String, dynamic> data = {
      'userId': userId,
    };
    _socket.emit('newProviderSignup', data);
  }

  approve(String adminId, String providerId) {
    Map<String, dynamic> data = {
      'adminId': adminId,
      'providerId': providerId,
    };
    _socket.emit('approveProvider', data);
  }

  subscribeToEvents(BuildContext context) {
    _socket.off('arrival_notifications');
    _socket.off('getMessage');
    _socket.off('message-sent');
    _socket.off('follow_request');
    _socket.off('follow_approved');
    _socket.off('follow_canceled');
    _socket.off('unfollow_success');
    _socket.off('reject_request_success');
    _socket.off('provider_signup');
    _socket.off('approve_provider_success');
    _socket.off('newMessageNotification');
    _socket.off('newFollowNotification', _newFollowNotification);
    _socket.off('followApprovedNotification', _followApprovedNotification);
    _socket.off('unfollowSuccessNotification', _unfollowSuccessNotification);
    _socket.off('rejectRequestNotififcation', _unfollowSuccessNotification);
    _socket.off('providerSignupNotififcation', _providerSignupNotififcation);
    _socket.off('approveProviderNotification', _approveProviderNotification);

    _socket.on('arrivalNotifications', _handleArrivalNotificationsEvent);
    _socket.on('getMessage', _handleMessageReceivedEvent);
    _socket.on('messageSent', _handleMessageSentEvent);
    _socket.on('followRequest', _handleFollowRequestSuccessEvent);
    _socket.on('followApproved', _handleApproveRequestSuccessEvent);
    _socket.on('followCanceled', _handleApproveRequestNotificationEvent);
    _socket.on('unfollowSuccess', _handleCancelRequestSuccessEvent);
    _socket.on('rejectRequest', _handleUnfollowSuccessEvent);
    _socket.on('providerSignup', _provider_signupEvent);
    _socket.on('approveProvider', _approve_provider_success);
    _socket.on('newMessageNotification', _newMessageNotification);
    _socket.on('newFollowNotification', _newFollowNotification);
    _socket.on('followApprovedNotification', _followApprovedNotification);
    _socket.on('unfollowSuccessNotification', _unfollowSuccessNotification);
    _socket.on('rejectRequestNotififcation', _unfollowSuccessNotification);
    _socket.on('providerSignupNotififcation', _providerSignupNotififcation);
    _socket.on('approveProviderNotification', _approveProviderNotification);
  }

  unsubscribeFromEvents() {
    _socket.offAny();
  }

  _handleArrivalNotificationsEvent(data) {
    print('Received arrival_notifications event: $data');
  }

  void _handleMessageReceivedEvent(data) {
    final messageSent = data['data'];
    final content = messageSent['content'];

    print('Received getMessage event: $messageSent');
    print('Content :  $content');
  }

  _handleMessageSentEvent(data) {
    print('Received message-sent event: $data');
  }

  _handleFollowRequestSuccessEvent(data) {
    print('Follow Request Success: $data');
  }

  _handleApproveRequestSuccessEvent(data) {
    print('Received follow_approved event: $data');
  }

  _handleApproveRequestNotificationEvent(data) {
    print('Received approve_request_notification event: $data');
  }

  _handleCancelRequestSuccessEvent(data) {
    print('Received cancel_request_success event: $data');
  }

  _handleUnfollowSuccessEvent(data) {
    print('Received unfollowed event: $data');
  }

  _provider_signupEvent(data) {
    print('Received provider_signup event: $data');
  }

  _approve_provider_success(data) {
    print('Received approve_provider_success event: $data');
  }

  _newMessageNotification(data) {
    print('Received approve_provider_success event: $data');
  }

  _newFollowNotification(data) {
    print('Received approve_provider_success event: $data');
  }

  _followApprovedNotification(data) {
    print('Received approve_provider_success event: $data');
  }

  _unfollowSuccessNotification(data) {
    print('Received approve_provider_success event: $data');
  }

  _providerSignupNotififcation(data) {
    print('Received approve_provider_success event: $data');
  }

  _approveProviderNotification(data) {
    print('Received approve_provider_success event: $data');
  }
}
