class Product{
  String owner;
  double price;
  String availability;
  String condition;
  String description;
  String title;


  //Constructor
  Product({
    required this.owner,
    required this.availability,
    required this.price,
    this.condition = "UNKNOWN",
    this.description = "",
    required this.title,
  });

  //Getters
  String getOwner() => owner;
  double getPrice() => price;
  String getAvailability() => availability;
  String getCondition() => condition;
  String getDescription() => description;
  String getTitle() => title;

  //Setters
  void setOwner(String owner) => this.owner = owner;
  void setPrice(double price) => this.price = price;
  void setAvailability(String availability) => this.availability = availability;
  void setCondition(String condition) => this.condition = condition;
  void setDescription(String description) => this.description = description;
  void setTitle(String title) => this.title = title;

}