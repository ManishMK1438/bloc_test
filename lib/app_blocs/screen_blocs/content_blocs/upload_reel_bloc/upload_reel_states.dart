import 'package:equatable/equatable.dart';

enum UploadReelStatus {
  initial,
  valid,
  videoSelected,
  thumbnailSelected,
  loading,
  success,
  error
}

class UploadReelState extends Equatable {
  final String error;
  final UploadReelStatus status;

  const UploadReelState(
      {this.error = "", this.status = UploadReelStatus.initial});

  UploadReelState copyWith({String? error, UploadReelStatus? status}) {
    return UploadReelState(
        error: error ?? this.error, status: status ?? this.status);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [error];

  @override
  String toString() {
    // TODO: implement toString
    return '''UploadReelState { error: $error}, status: $status''';
  }
}
