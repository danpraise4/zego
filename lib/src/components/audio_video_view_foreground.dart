// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';

// Project imports:
import 'package:zego_uikit_prebuilt_live_streaming/src/components/defines.dart';
import 'package:zego_uikit_prebuilt_live_streaming/src/components/pop_up_manager.dart';
import 'package:zego_uikit_prebuilt_live_streaming/src/components/pop_up_sheet_menu.dart';
import 'package:zego_uikit_prebuilt_live_streaming/src/controller.dart';
import 'package:zego_uikit_prebuilt_live_streaming/src/core/connect_manager.dart';
import 'package:zego_uikit_prebuilt_live_streaming/src/core/host_manager.dart';
import 'package:zego_uikit_prebuilt_live_streaming/src/inner_text.dart';
import 'package:zego_uikit_prebuilt_live_streaming/src/internal/internal.dart';

/// @nodoc
class ZegoAudioVideoForeground extends StatelessWidget {
  final Size size;
  final ZegoUIKitUser? user;

  final bool isPluginEnabled;
  final ZegoLiveHostManager hostManager;
  final ZegoLiveConnectManager connectManager;
  final ZegoPopUpManager popUpManager;
  final ZegoInnerText translationText;
  final ZegoUIKitPrebuiltLiveStreamingController prebuiltController;

  final bool showMicrophoneStateOnView;
  final bool showCameraStateOnView;
  final bool showUserNameOnView;

  const ZegoAudioVideoForeground({
    Key? key,
    this.user,
    required this.size,
    required this.isPluginEnabled,
    required this.hostManager,
    required this.connectManager,
    required this.popUpManager,
    required this.prebuiltController,
    required this.translationText,
    this.showMicrophoneStateOnView = true,
    this.showCameraStateOnView = true,
    this.showUserNameOnView = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Container(color: Colors.transparent);
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(3.zR),
              padding: EdgeInsets.all(3.zR),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  userName(
                    context,
                    constraints.maxWidth * 0.7,
                  ),
                  microphoneStateIcon(),
                  cameraStateIcon(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: audioVideoViewForegroundControlButton(
              context,
              user,
              constraints.maxWidth,
              constraints.maxHeight,
            ),
          ),
        ],
      );
    });
  }

  Widget userName(BuildContext context, double maxWidth) {
    return showUserNameOnView
        ? ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: Text(
              user?.name ?? '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 22.0.zR,
                color: const Color(0xffffffff),
                decoration: TextDecoration.none,
              ),
            ),
          )
        : const SizedBox();
  }

  Widget microphoneStateIcon() {
    if (!showMicrophoneStateOnView) {
      return const SizedBox();
    }

    return SizedBox(
      width: 20.zR,
      height: 33.zR,
      child: ZegoMicrophoneStateIcon(targetUser: user),
    );
  }

  Widget cameraStateIcon() {
    if (!showCameraStateOnView) {
      return const SizedBox();
    }

    return SizedBox(
      width: 20.zR,
      height: 33.zR,
      child: ZegoCameraStateIcon(targetUser: user),
    );
  }

  Widget audioVideoViewForegroundControlButton(
    BuildContext context,
    ZegoUIKitUser? user,
    double maxWidth,
    double maxHeight,
  ) {
    if (!hostManager.isLocalHost ||
        user == null ||
        user.id == hostManager.notifier.value?.id) {
      return Container();
    }

    final popupItems = <PopupItem>[];

    // if (user.id != hostManager.notifier.value?.id &&
    //     isCoHost(user) &&
    //     (isPluginEnabled)) {
    //   popupItems.add(PopupItem(
    //     PopupItemValue.kickCoHost,
    //     translationText.removeCoHostButton,
    //   ));
    // }

    if (popupItems.isEmpty) {
      return Container();
    }

    popupItems.add(PopupItem(
      PopupItemValue.cancel,
      translationText.cancelMenuDialogButton,
    ));

    return GestureDetector(
      onTap: () {
        showPopUpSheet(
          context: context,
          user: user,
          popupItems: popupItems,
          hostManager: hostManager,
          connectManager: connectManager,
          popUpManager: popUpManager,
          prebuiltController: prebuiltController,
          translationText: translationText,
        );
      },
      child: Container(
        color: Colors.transparent,
        //  need for click
        width: maxWidth,
        height: maxHeight * 0.33,
        padding: EdgeInsets.all(5.zR),
        child: Align(
          alignment: Alignment.topRight,
          child: ZegoTextIconButton(
            buttonSize: Size(28.zR, 28.zR),
            iconSize: Size(28.zR, 28.zR),
            icon: ButtonIcon(
              backgroundColor: Colors.black.withOpacity(0.6),
              icon: PrebuiltLiveStreamingImage.asset(
                  PrebuiltLiveStreamingIconUrls.bottomBarMore),
            ),
          ),
        ),
      ),
    );
  }
}
