enum PageName {
  nightMap,
  nightOffers,
  nightSocial,
}

enum LoginRegistrationButtonType {
  filled,
  transparent,
}

enum CountryCode {
  dk,
  se,
  no,
}

enum PermissionState {
  noPermissions, // DEFAULT
  lowPermission, // GPS IS PERMITTED
  highPermission, // PRECISE LOCATION PERMITTED
  allPermissions, // ALWAYS USE GPS PERMITTED
}

enum MainOfferRedemptionPermisson {
  pending,
  granted,
  denied,
}

enum PartyStatus {
  unsure,
  yes,
  no,
}

enum OfferType {
  none,
  alwaysActive,
  redeemable,
}
