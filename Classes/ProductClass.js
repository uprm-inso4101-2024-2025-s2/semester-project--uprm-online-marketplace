class Product{

    constructor(owner, availability, price= 1000){
        this.owner= owner;
        this.price= price;
        this.availability= availability;
        this.condition= "";
        this.description= "";
    }
    

    //Getters
    getOwner(){return this.owner;}
    getPrice(){return this.price;}
    getAvailability(){return this.availability;}
    getDescription(){return this.description;}
    getCondition(){return this.condition;}

    //Setters
    setOwner(owner){this.owner= owner;}
    setPrice(price){this.price= price;}
    setAvailability(availability){this.availability= availability;}
    setDescription(description){this.description= description;}
    setCondition(condition){this.condition= condition;}
    
}
module.exports.Product= Product;