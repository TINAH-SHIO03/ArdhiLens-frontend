/// Tracks whether the active verification flow is buyer due-diligence or seller ownership proof.
class VerificationMode {
  static const String buyer = 'buyer_verification';
  static const String seller = 'seller_ownership';

  static bool isSellerMode(String? mode) => mode == seller;
}
