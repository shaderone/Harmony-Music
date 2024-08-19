import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widget_marquee/widget_marquee.dart';

import '../../widgets/loader.dart';
import '../player_controller.dart';

class PlayerControlWidget extends StatelessWidget {
  const PlayerControlWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Get.find<PlayerController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Obx(() {
        return Marquee(
          delay: const Duration(milliseconds: 300),
          duration: const Duration(seconds: 5),
          id: "Current Song",
          child: Text(
            playerController.currentSong.value != null
                ? playerController.currentSong.value!.title
                : "NA",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium!,
          ),
        );
      }),
      const SizedBox(
        height: 10,
      ),
      GetX<PlayerController>(builder: (controller) {
        return Marquee(
          delay: const Duration(milliseconds: 300),
          duration: const Duration(seconds: 5),
          id: "Current Song artists",
          child: Text(
            playerController.currentSong.value != null
                ? controller.currentSong.value!.artist!
                : "NA",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        );
      }),
      const SizedBox(
        height: 20,
      ),
      GetX<PlayerController>(builder: (controller) {
        return ProgressBar(
          baseBarColor: Theme.of(context).sliderTheme.inactiveTrackColor,
          bufferedBarColor: Theme.of(context).sliderTheme.valueIndicatorColor,
          progressBarColor: Theme.of(context).sliderTheme.activeTrackColor,
          thumbColor: Theme.of(context).sliderTheme.thumbColor,
          timeLabelTextStyle: Theme.of(context).textTheme.titleMedium,
          progress: controller.progressBarStatus.value.current,
          total: controller.progressBarStatus.value.total,
          buffered: controller.progressBarStatus.value.buffered,
          onSeek: controller.seek,
        );
      }),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: playerController.toggleFavourite,
              icon: Obx(() => Icon(
                    playerController.isCurrentSongFav.isFalse
                        ? Icons.favorite_border_rounded
                        : Icons.favorite_rounded,
                    color: Theme.of(context).textTheme.titleMedium!.color,
                  ))),
          _previousButton(playerController, context),
          CircleAvatar(radius: 35, child: _playButton()),
          _nextButton(playerController, context),
          Obx(() {
            return IconButton(
                onPressed: playerController.toggleLoopMode,
                icon: Icon(
                  Icons.all_inclusive,
                  color: playerController.isLoopModeEnabled.value
                      ? Theme.of(context).textTheme.titleLarge!.color
                      : Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .color!
                          .withOpacity(0.2),
                ));
          }),
        ],
      ),
    ]);
    
  }
  
  Widget _playButton() {
    return GetX<PlayerController>(builder: (controller) {
      final buttonState = controller.buttonState.value;
      if (buttonState == PlayButtonState.loading) {
        return IconButton(
          icon: const LoadingIndicator(
            dimension: 20,
          ),
          onPressed: () {},
        );
      }
      if (buttonState == PlayButtonState.paused) {
        return IconButton(
          icon: const Icon(Icons.play_arrow_rounded),
          iconSize: 40.0,
          onPressed: controller.play,
        );
      } else if (buttonState == PlayButtonState.playing ||
          buttonState == PlayButtonState.loading) {
        return IconButton(
          icon: const Icon(Icons.pause_rounded),
          iconSize: 40.0,
          onPressed: controller.pause,
        );
      } else {
        return IconButton(
          icon: const Icon(Icons.play_arrow_rounded),
          iconSize: 40.0,
          onPressed: () {},
        );
      }
    });
  }

  Widget _previousButton(
      PlayerController playerController, BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.skip_previous_rounded,
        color: Theme.of(context).textTheme.titleMedium!.color,
      ),
      iconSize: 30,
      onPressed: playerController.prev,
    );
  }
}

Widget _nextButton(PlayerController playerController, BuildContext context) {
  return Obx(() {
    final isLastSong = playerController.currentQueue.isEmpty ||
        (playerController.currentQueue.last.id ==
            playerController.currentSong.value?.id);
    return IconButton(
        icon: Icon(
          Icons.skip_next_rounded,
          color: Theme.of(context).textTheme.titleMedium!.color,
        ),
        iconSize: 30,
        onPressed: isLastSong ? null : playerController.next);
  });
}