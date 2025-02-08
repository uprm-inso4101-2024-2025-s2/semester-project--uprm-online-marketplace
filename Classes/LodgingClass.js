const {Product} = require( './ProductClass');
class Lodging extends Product{

    constructor(owner, availability, price= 1000){
        super(owner, availability);
        this.price= price;
        this.location= "UNKOWN";    
        this.condition= 'UNKOWN';
        this.bedrooms= 0;
        this.restrooms= 0;
        this.parking= 0;
        this.description= "";
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


