import 'owner_link_failure_result.dart';
import 'verification_result.dart';

class VerificationOutcome {
  VerificationOutcome.success(this.success) : failure = null;
  VerificationOutcome.failure(this.failure) : success = null;

  final VerificationResult? success;
  final OwnerLinkFailureResult? failure;

  bool get isSuccess => success != null;
}
