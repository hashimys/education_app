import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repos/video_repo.dart';

class AddVideo extends FutureUsecaseWithParams<void, VideoEntity> {
  const AddVideo(this._repo);

  final VideoRepo _repo;

  @override
  ResultFuture<void> call(VideoEntity params) => _repo.addVideo(params);
}
