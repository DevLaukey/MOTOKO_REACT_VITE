module EHRAccessControl {

  // Define a record to represent a healthcare professional or entity
  record HealthcareEntity = {
    id: Text;          // Unique identifier for the entity
    role: Text;        // Role of the entity (e.g., doctor, hospital)
  };

  // Define a record to represent an EHR (Electronic Health Record)
  record EHR = {
    patientId: Nat;
    data: Text;        // EHR data (simplified as a text field)
  };

  // Define a record to represent an access token
  record AccessToken = {
    token: Text;       // Token value
    entityId: Text;    // Healthcare entity's ID
    patientId: Nat;    // Patient's ID
    expiration: Time;  // Token expiration time
    scope: Text;       // Token scope (e.g., "view", "modify")
  };

  // Define the main storage for storing healthcare entities, EHRs, and access tokens
  var entities : [HealthcareEntity] = [];
  var patientEHRs : [EHR] = [];
  var accessTokens : [AccessToken] = [];

  // Function to generate a time-limited access token
  public func generateAccessToken(entityId: Text, patientId: Nat, scope: Text, duration: Time) : async Text = {
    // Check if the caller has the necessary permissions (e.g., admin role)
    assert(checkAdminPermission());

    // Generate a random token value (you can use a more secure method)
    let token = Principal.toText(Principal.fromActor(this)) # "-" # Text.fromInt(Did.toNat(Time.toDid(now)));

    // Calculate the token expiration time
    let expiration = Time.add(now, duration);

    // Create the access token record
    let accessToken = {
      token = token;
      entityId = entityId;
      patientId = patientId;
      expiration = expiration;
      scope = scope;
    };

    // Store the access token
    accessTokens := accessTokens # [accessToken];

    // Return the generated token
    token;
  };

  // Function to check the validity of an access token
  public func isValidAccessToken(token: Text, scope: Text) : async Bool = {
    let currentTimestamp = now;

    // Find the access token with the provided token value
    let accessToken = Array.find((at) => at.token == token, accessTokens);

    switch (accessToken) {
      null => false,
      accessToken => {
        // Check if the token is expired or the scope doesn't match
        if (accessToken.expiration <= currentTimestamp || accessToken.scope != scope) {
          false;
        } else {
          true;
        };
      };
    };
  };

  // ...

  // Helper function to check if the caller has admin permissions
  private func checkAdminPermission() : Bool = {
    // Replace this with your actual logic to check admin permissions
    // In a real-world scenario, you may use Principal to identify the caller's role.
    // For simplicity, we assume that the caller has admin permissions.
    true;
  };

  // ...

};
