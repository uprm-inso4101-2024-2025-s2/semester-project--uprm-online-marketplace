const {Product} = require( './ProductClass');
class Lodging extends Product{

    constructor(owner, availability, price= 1000, location= "UNKOWN", condition= "UNKOWN", bedrooms= 0, restrooms= 0, parking= 0, description= ""){
        super(owner, availability, price, condition, description);
        this.location= location;    
        this.bedrooms= bedrooms;
        this.restrooms= restrooms;
        this.parking= parking;
    }
    
    //Getters
    getLocation(){return this.location;}
    getBedrooms(){return this.bedrooms;}
    getRestrooms(){return this.restrooms;}
    getParking(){return this.parking;}

    //Setters
    setLocation(location){this.location= location;}
    setBedrooms(bedrooms){this.bedrooms= bedrooms;}
    setRestrooms(restrooms){this.restrooms= restrooms;}
    setParking(parking){this.parking= parking;}

}
module.exports.Lodging= Lodging;


