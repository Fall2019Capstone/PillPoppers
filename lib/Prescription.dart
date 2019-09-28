class Prescription{
  String name;
  bool taken;
  int numberToTake;
  int numberTaken;


  static List<Prescription> prescriptions;

  Prescription(String name){
    this.name = name;
  }

  static instantiate(){
    prescriptions = new List<Prescription>();

    Prescription scrip1 = new Prescription("TestMade1");
    Prescription scrip2 = new Prescription("TestMade2");
    prescriptions.add(scrip1);
    prescriptions.add(scrip2);
  }
}