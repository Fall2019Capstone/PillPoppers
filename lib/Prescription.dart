class Prescription{
  String name = "New prescription";
  bool taken = false;
  int numberToTake = 10;
  int numberTaken = 0; 


  static List<Prescription> prescriptions = [new Prescription("TestMade1"), new Prescription("TestMade2")];

  Prescription(String name){
    this.name = name;
    //prescriptions.add(this);
  }

  static instantiate(){
    prescriptions = new List<Prescription>();

    Prescription scrip1 = new Prescription("TestMade1");
    Prescription scrip2 = new Prescription("TestMade2");
    prescriptions.add(scrip1);
    prescriptions.add(scrip2);
  }

  static newPrescription(String name){
    prescriptions.add(new Prescription(name));
  }
}