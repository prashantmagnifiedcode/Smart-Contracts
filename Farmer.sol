// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
contract farmers_products{
    address private actual_owner;
    address payable[] public collected_farmer;
 
    mapping(address=>string) public proofs_of_farmer;
    constructor(){
        actual_owner=msg.sender;
    }

    ///description of product
    struct available_product{
        address farmer;
         string name;
         string ingradient;
         string grown_location;
         uint amount; 
    }
     mapping (address=>uint) count;


    ///customer reciept after purchase
     event customer_reciept(
         address from,
         address to ,
         string product
     );

     //farmer present or not
    function alreadyentered() view private returns(bool){
        for(uint i=0;i<collected_farmer.length;i++){
            if(collected_farmer[i]==msg.sender){
                return true;
            }
        }
        return false;
    }


    function faremer_access( address _pur) view private returns(bool){
        for(uint i=0;i<collected_farmer.length;i++){
            if(collected_farmer[i]==_pur){
                return true;
            }
        }
        return false;
    }
      mapping(address => mapping(uint=>available_product))  mp; 
         

         // first checking already registered or not
     modifier registed_or_not {
  require(alreadyentered() ==true,"Firsty register farmer");
  _;
     }


     /// pushing item of farmer
    function insert_product(string memory _name,string memory _ingradient,string memory _grow_location,uint _amount) public registed_or_not {
        
        mp[msg.sender][count[msg.sender]]=available_product( msg.sender, _name,_ingradient,_grow_location, _amount);
      count[msg.sender]+=1;
    
    }
    
      function Current_data(address _id) public view returns (available_product[] memory){
      available_product[]    memory id = new available_product[](count[_id]);
      for (uint i = 0; i < count[_id]; i++) {
          available_product memory member = mp[_id][i];
          id[i] = member;
      }
      return id;
  }

    /// collecting farmer identities
     function farmer_identity(string memory _proof) public  {
         require(actual_owner!=msg.sender,"not farmer");
         require(alreadyentered()==false,"You registered already");
         proofs_of_farmer[msg.sender]=_proof;
         collected_farmer.push(payable(msg.sender));

     }

   /// showing detail of farmer registered 
     function consumer() public view returns(address payable[] memory){
          return (collected_farmer);
     } 

     //purchasing section
     function purchase(address _from,uint _id) payable public {
           require(faremer_access(_from) ==true,"farmer does not aces");
           require(msg.value == mp[_from][_id].amount,"pls pay valid amount");
           emit customer_reciept(_from ,msg.sender,mp[_from][_id].name);
     } 
}
