class Product{
  String owner;
  int price;
  String availability;
  String condition;
  String description;

  //Constructor
  Product({
    required this.owner,
    required this.availability,
    this.price = 1000,
    this.condition = "UNKNOWN",
    this.description = ""
  });

  //Getters
  String getOwner() => owner;
  int getPrice() => price;
  String getAvailability() => availability;
  String getCondition() => condition;
  String getDescription() => description;

  //Setters
  void setOwner(String owner) => this.owner = owner;
  void setPrice(int price) => this.price = price;
  void setAvailability(String availability) => this.availability = availability;
  void setCondition(String condition) => this.condition = condition;
  void setDescription(String description) => this.description = description;
  
}
