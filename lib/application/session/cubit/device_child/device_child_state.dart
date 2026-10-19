part of 'device_child_cubit.dart';

/// What the device step is showing.
sealed class DeviceChildState {
  const DeviceChildState();
}

/// The children are being read, or a choice is being stored.
final class DeviceChildLoading extends DeviceChildState {
  const DeviceChildLoading();
}

/// The children to choose between.
final class DeviceChildChoosing extends DeviceChildState {
  const DeviceChildChoosing(this.choice);

  final DeviceChoiceReadModel choice;
}

/// The children could not be read, or the choice could not be stored.
final class DeviceChildFailed extends DeviceChildState {
  const DeviceChildFailed(this.failure);

  final Failure failure;
}

/// The device has its child; the page opens the map.
final class DeviceChildChosen extends DeviceChildState {
  const DeviceChildChosen();
}
