import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// The outcome of anything that can fail, as a value.
///
/// Business logic does not throw. A thrown exception is invisible in a
/// signature and lands wherever a `try` happens to be; a [Result] is in the
/// return type, so a caller that ignores the failure case does not compile.
///
/// `sealed` is what buys that: an exhaustive `switch` over [Ok] and [Err] needs
/// no default branch, and adding a third variant would break every call site on
/// purpose rather than silently falling through one.
sealed class Result<T> {
  const Result();

  /// True when this carries a value. Prefer a `switch` — this exists for the
  /// places where only the question matters, not the value.
  bool get isOk => this is Ok<T>;

  /// The value, or `null` when this is a failure.
  T? get valueOrNull => switch (this) {
        Ok<T>(:final value) => value,
        Err<T>() => null,
      };

  /// The failure, or `null` when this carries a value.
  Failure? get failureOrNull => switch (this) {
        Ok<T>() => null,
        Err<T>(:final failure) => failure,
      };
}

/// A result that carries the value it was asked for.
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// A result that carries why it could not.
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
