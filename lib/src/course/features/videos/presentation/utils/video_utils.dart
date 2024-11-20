import 'dart:async';

import 'package:education_app/core/extensions/string_extensions.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/presentation/views/video_player_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoUtils {
  const VideoUtils._();

  static Future<VideoEntity?> getVideoFromYT(
    BuildContext context, {
    required String url,
  }) async {
    void showSnack(String message) => CoreUtils.showSnackBar(context, message);
    final yt = YoutubeExplode();

    try {
      final videoId = VideoId.parseVideoId(url);
      if (videoId == null) {
        showSnack('Invalid YouTube URL');
        return null;
      }

      final video = await yt.videos.get(videoId);
      // if (video.title == null || video.author == null || video.thumbnails.isEmpty) {
      //   final missingData = <String>[];
      //   if (video.thumbnails.isEmpty) missingData.add('Thumbnail');
      //   if (video.title == null) missingData.add('Title');
      //   if (video.author == null) missingData.add('AuthorName');
      //   final missingDataText = missingData.join(', ');
      //   final message = 'Could not get video data. Please try again.\n'
      //       'The following data is missing: $missingDataText';
      //   showSnack(message);
      //   return null;
      // }

      return VideoModel.empty().copyWith(
        thumbnail: video.thumbnails.highResUrl,
        videoURL: url,
        title: video.title,
        tutor: video.author,
      );
    } catch (e) {
      showSnack('PLEASE TRY AGAIN\n$e');
      return null;
    } finally {
      yt.close();
    }
  }

  static Future<void> playVideo(BuildContext context, String videoURL) async {
    final navigator = Navigator.of(context);
    if (videoURL.isYoutubeVideo) {
      if (!await launchUrl(
        Uri.parse(videoURL),
        mode: LaunchMode.externalApplication,
      )) {
        // ignore: use_build_context_synchronously
        CoreUtils.showSnackBar(
          context,
          'Could not launch $videoURL',
        );
      }
    } else {
      unawaited(
        navigator.pushNamed(
          VideoPlayerView.routeName,
          arguments: videoURL,
        ),
      );
    }
  }
}
