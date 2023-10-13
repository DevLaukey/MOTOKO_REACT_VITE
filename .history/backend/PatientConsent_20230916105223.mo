module PatientConsent {

  // Define a record to represent patient consent
  record Consent = {
    patient: Principal;  // Patient's identity
    granted: Bool;      // True if consent is granted, false if revoked
  };

  // Define the main storage for storing consent records
  var consents : [Consent] = [];

  // Function to grant consent
  public func grantConsent() : async () = {
    let patient = Call.caller;
    let consent = { patient = patient; granted = true };
    consents := consents # [consent];
  };

  // Function to revoke consent
  public func revokeConsent() : async () = {
    let patient = Call.caller;
    consents := Array.filter((consent) => consent.patient != patient, consents);
  };

  // Function to check if consent is granted by a patient
  public func isConsentGranted(patient: Principal) : async Bool = {
    let consent = Array.find((c) => c.patient == patient, consents);
    switch (consent) {
      null => false,
      consent => consent.granted,
    };
  };
};


