import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/presentation/l10n/generated/app_localizations.dart';

/// Turns a [Failure] into words a user can read.
///
/// The ONLY place that mapping happens. A `Failure` carries a key, never a
/// sentence, so the layer that produced it never has to know the user's
/// language — and copy can be reworded without touching a use case.
///
/// The `switch` is on the key rather than on the type because two failures of
/// the same class can need opposite advice: "you are offline" and "the server
/// sent nonsense" are both worth saying differently, and both arrive as the
/// same Dart type.
String failureCopy(AppL10n l10n, Failure failure) => switch (failure.messageKey) {
      FailureMessageKey.network => l10n.failureNetwork,
      FailureMessageKey.unexpectedResponse => l10n.failureUnexpectedResponse,
      FailureMessageKey.examDateMissing => l10n.failureExamDateMissing,
      // Deliberately the fallback for an unrecognised key rather than showing
      // the key itself: a dotted identifier on screen is worse than a vague
      // sentence, and it is what happens when a lookup answers a miss by
      // echoing its input.
      _ => l10n.failureUnknown,
    };
