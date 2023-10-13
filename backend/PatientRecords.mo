module PatientRecords {

  // Define a record to represent patient information
  record PatientInfo = {
    patientId: Nat;
    name: Text;
    age: Nat;
    diagnosis: Text;
  };

  // Define the main storage for storing patient records
  var patients : [PatientInfo] = [];

  // Function to add a patient record
  public func addPatientRecord(
    patientId: Nat,
    name: Text,
    age: Nat,
    diagnosis: Text
  ) : async () = {
    let patient = {
      patientId = patientId;
      name = name;
      age = age;
      diagnosis = diagnosis;
    };
    patients := patients # [patient];
  };

  // Function to retrieve a patient record by patient ID
  public func getPatientRecord(patientId: Nat) : async ?PatientInfo = {
    let patient = Array.find((p) => p.patientId == patientId, patients);
    switch (patient) {
      null => null,
      patient => patient,
    };
  };

  // Function to retrieve all patient records
  public func getAllPatientRecords() : async [PatientInfo] = patients;

};


public func storeDummyPatientRecords() : async () = {
  await PatientRecords.addPatientRecord(1, "John Doe", 35, "Common Cold");
  await PatientRecords.addPatientRecord(2, "Jane Smith", 42, "Influenza");
  await PatientRecords.addPatientRecord(3, "Alice Johnson", 28, "Allergies");
  await PatientRecords.addPatientRecord(4, "Bob Brown", 55, "Hypertension");
  await PatientRecords.addPatientRecord(5, "Eve Wilson", 45, "Diabetes");
};
