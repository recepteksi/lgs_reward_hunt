import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_out_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';

/// Reads the stored session and checks that the backend still knows it,
/// before the first screen is chosen.
///
/// The session lives on the device and the accounts live on the backend, so
/// one can outlive the other. A session naming a parent or child the backend
/// no longer has would open the app on pages that can only fail, so a
/// `NotFoundFailure` for either signs out, and the app opens on the intro.
/// Any other failure, such as no network, keeps the session: being offline
/// is not a reason to sign anyone out.
@injectable
final class ConfirmSessionUseCase {
  const ConfirmSessionUseCase(this._session, this._accounts, this._signOut);

  final SessionRepositoryInterface _session;

  final AccountRepositoryInterface _accounts;

  final SignOutUseCase _signOut;

  Future<Either<Failure, SessionValueObject>> call() async {
    final stored = await _session.read();
    if (stored.isLeft) return stored;
    final SessionValueObject session = stored.right;

    final String? parentId = session.parentId;
    if (parentId == null) return stored;
    if (_isGone(
      (await _accounts.parentById(parentId)).fold((f) => f, (_) => null),
    )) {
      return _signOut();
    }

    final String? childId = session.activeChildId;
    if (childId == null) return stored;
    if (_isGone(
      (await _accounts.childById(childId)).fold((f) => f, (_) => null),
    )) {
      return _signOut();
    }

    return stored;
  }

  static bool _isGone(Failure? failure) => failure is NotFoundFailure;
}
