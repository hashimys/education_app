import 'package:bloc/bloc.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/add_video.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:equatable/equatable.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit({
    required AddVideo addVideo,
    required GetVideos getVideos,
  })  : _addVideo = addVideo,
        _getVideos = getVideos,
        super(const VideoInitial());

  final AddVideo _addVideo;
  final GetVideos _getVideos;

  Future<void> addVideo(VideoEntity video) async {
    emit(const AddingVideo());
    final result = await _addVideo(video);
    result.fold(
      (failure) => emit(VideoError(failure.errorMessage)),
      (_) => emit(const VideoAdded()),
    );
  }

  Future<void> getVideos(String courseId) async {
    emit(const LoadingVideos());
    final result = await _getVideos(courseId);
    result.fold(
      (failure) => emit(VideoError(failure.errorMessage)),
      (videos) => emit(VideosLoaded(videos)),
    );
  }
}
