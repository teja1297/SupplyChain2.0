// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

contract SupplyChainStorage{
address public owner;
    constructor() public{
        owner = msg.sender;
         authorizedCaller[msg.sender] = 1;
    }
    address[] public DrugKeyList ;
    address[] public UserKeyList;
    /* Events */
    event AuthorizedCaller(address caller);
    event DeAuthorizedCaller(address caller);

    mapping(address => string) userRole;
    mapping(address => uint8) authorizedCaller;
      mapping (address => string) nextOwner;

    
    struct User{
        string ParticipantName;
        string contactNo;
        bool isActive;
        string UserName;
        string userPassword;
        string Email;
     }


    struct  Drug {
        uint32 drugID;
        uint32 batchID;
        string drugName;
        string Currentlocation;
        address CurrentproductOwner;
        address nextOwner;
        uint32 cost;
        uint mfgTimeStamp;
        uint expTimeStamp;
        uint32  CurrentTemperature;
        uint32 IdealTemperature;
        string status;
        bool isBad;

    }

    struct Manufacturer{
        string name;
        string ManufacturerAddress;
        address ExporterAddress;
        uint32 ExportingTemparature;
        uint256 ExportingDateTime;
        string DrugStatus;
    }

    struct distributor{
        string name;
        string DistributorAddress;
        uint32 ImportingTemparature;
        uint32 ExportingTemparature;
        uint256 ImportingDateTime;
        uint256 ExportingDateTime;
        address ExporterAddress;
        string DrugStatus;
    }

    struct Wholesaler{
        string name;
        string WholesalerAddress;
        uint32 ImportingTemparature;
        uint32 ExportingTemparature;
        uint256 ImportingDateTime;
        uint256 ExportingDateTime;
       address ExporterAddress;
        string DrugStatus;
    }

    struct Pharmacy{

        string PharmacyName;
        string PharmacyAddress;
        uint32 ImportingTemparature;
        string DrugStatus;
        uint256 ImportingDateTime;
    }
    mapping(address => Drug) BatchDrugDetails;
    mapping(address =>User) BatchUserDetails;
    mapping(address => Manufacturer)BatchManufactureringDetails;
    mapping(address =>distributor)BatchdistributorDetails;
    mapping(address =>Wholesaler)BatchWholesalerDetails;
    mapping(address =>Pharmacy)BatchPharmacyDetails;


        Drug DrugDetails;
        User UserDetail;
        Manufacturer ManufacturerDetails;
        distributor distributorDetails;
        Wholesaler WholesalerDetails;
        Pharmacy PharmacyDetails;



    // function getAllDrugDetails() public view returns(Drug[] memory){
    //    Drug[] memory drugs;
    //     for(uint i=0;i<DrugList.length;i++){
    //     drugs[i] = BatchDrugDetails[DrugList[i]];
    //     }
    //     return drugs;
    // }



    function getUserRole(address _userAddress) public onlyAuthCaller view returns( string memory)
    {
        return userRole[_userAddress];
    }

    function getDrugKeyList() public view returns(address[] memory){
        return DrugKeyList;
    }
    function getUserKeyList() public view returns(address[] memory){
        return UserKeyList;
    }
   

     function setUser(address  _userAddress,
                     string memory _ParticipantName, 
                     string  memory _contactNo, 
                     string memory _role, 
                     string memory _UserName,
                     string memory _UserPassword,
                     string memory _Email,
                     bool _isActive) public onlyOwner returns(bool){
        
        /*store data into struct*/
        UserDetail.ParticipantName = _ParticipantName;
        UserDetail.contactNo = _contactNo;
        UserDetail.isActive = _isActive;
        UserDetail.UserName = _UserName;
        UserDetail.Email = _Email;
        UserDetail.userPassword = _UserPassword;
        authorizedCaller[_userAddress] = 1;
        /*store data into mapping*/
        BatchUserDetails[_userAddress] = UserDetail;
        userRole[_userAddress] = _role;
        UserKeyList.push(_userAddress);
        return true;
    }  
    

    function setDrugDetails(uint32 _drugID,
        uint32 _batchID,
        string memory _drugName,
        string memory _Currentlocation,
        uint32 _cost,
        uint _mfgTimeStamp,
        uint _expTimeStamp,
        uint32  _CurrentTemperature,
        uint32 _IdealTemperature
     ) public onlyOwner  returns(address){

         uint tmpData = uint(keccak256(abi.encodePacked(msg.sender, block.timestamp )));
        address SerialNumber = address(tmpData);
         DrugKeyList.push(SerialNumber);//newly added
        DrugDetails.drugID = _drugID;
        DrugDetails.batchID = _batchID;
        DrugDetails.drugName = _drugName;
        DrugDetails.Currentlocation = _Currentlocation;
        DrugDetails.CurrentproductOwner = tx.origin;
        DrugDetails.cost = _cost;
        DrugDetails.mfgTimeStamp = _mfgTimeStamp;
        DrugDetails.expTimeStamp = _expTimeStamp;
        DrugDetails.CurrentTemperature = _CurrentTemperature;
        DrugDetails.IdealTemperature = _IdealTemperature;
        DrugDetails.status = "Good";
        DrugDetails.nextOwner = address(0);
        nextOwner[SerialNumber] = "Manufacturer";
        BatchDrugDetails[SerialNumber] = DrugDetails;
        return SerialNumber;

    }


 /*Set ManufacturerDetails*/
    function MoveFromManufacturer(address _SerialNumber,
                             string memory _name,
                             string memory _ManufacturerAddress,
                             address  _ExporterAddress,
                             uint32  _ExportingTemparature
                             )public onlyAuthCaller onlyDrugOwner(_SerialNumber)  returns(bool){      
                bool good =  isBad(_SerialNumber,_ExportingTemparature);
           if(good){   
                DrugDetails = BatchDrugDetails[_SerialNumber];      
                     DrugDetails.status = "In Transit from Manufacturer";   
                     DrugDetails.nextOwner = _ExporterAddress;    
         ManufacturerDetails.name = _name;
         ManufacturerDetails.ManufacturerAddress = _ManufacturerAddress;
         ManufacturerDetails.ExporterAddress = _ExporterAddress;
         ManufacturerDetails.ExportingTemparature = _ExportingTemparature;
         ManufacturerDetails.ExportingDateTime = block.timestamp;
         ManufacturerDetails.DrugStatus = "Good";
         BatchManufactureringDetails[_SerialNumber] = ManufacturerDetails;
         BatchDrugDetails[_SerialNumber] = DrugDetails;
          nextOwner[_SerialNumber] = 'Distributor'; 
        
         return true;}
         else{
             return false;
         }
        }


        function distributorReceving(address _SerialNumber, string memory _name,string memory _DistributorAddress,uint32 _ImportingTemparature) public onlyAuthCaller onlyDrugReceiver(_SerialNumber) returns(bool){
            bool good =  isBad(_SerialNumber,_ImportingTemparature);
            if(good){
            DrugDetails = BatchDrugDetails[_SerialNumber];
            distributorDetails.name = _name;
            distributorDetails.DistributorAddress =  _DistributorAddress;
            distributorDetails.ImportingTemparature = _ImportingTemparature;
            distributorDetails.ImportingDateTime = block.timestamp;
            
            distributorDetails.DrugStatus = "Good";
            BatchdistributorDetails[_SerialNumber] = distributorDetails;
            DrugDetails.CurrentproductOwner = tx.origin;
            DrugDetails.nextOwner = address(0);

             DrugDetails.status = "Received by Distributor"; 
             BatchDrugDetails[_SerialNumber] = DrugDetails;
             return true;
            }
            else{
                return false;
            }


        }

    function MoveFromDistributor(address _SerialNumber,
        uint32 _ExportingTemparature, 
        address _ExporterAddress
        ) public onlyAuthCaller onlyDrugOwner(_SerialNumber)returns(bool){
           
           bool good =  isBad(_SerialNumber,_ExportingTemparature);
           if(good){
               DrugDetails = BatchDrugDetails[_SerialNumber];      
                     DrugDetails.status = "In Transit from Distributor";  
                     DrugDetails.nextOwner = _ExporterAddress;
            distributorDetails.ExportingTemparature = _ExportingTemparature;
            distributorDetails.ExportingDateTime = block.timestamp;
            distributorDetails.ExporterAddress = _ExporterAddress;
            distributorDetails.DrugStatus = "Good";
            BatchdistributorDetails[_SerialNumber] = distributorDetails;
             nextOwner[_SerialNumber] = 'Wholesaler'; 
             BatchDrugDetails[_SerialNumber] = DrugDetails;
                
            return true; 
           }
           else{
               return false;
           }
        }

         function WholeSalerReceving(address _SerialNumber, string memory _name,string memory _DistributorAddress,uint32 _ImportingTemparature) public onlyAuthCaller onlyDrugReceiver(_SerialNumber) returns(bool){
            bool good =  isBad(_SerialNumber,_ImportingTemparature);
            if(good){
            DrugDetails = BatchDrugDetails[_SerialNumber];
             DrugDetails.nextOwner = address(0);   
            WholesalerDetails.name = _name;
            WholesalerDetails.WholesalerAddress =  _DistributorAddress;
            WholesalerDetails.ImportingTemparature = _ImportingTemparature;
            WholesalerDetails.ImportingDateTime = block.timestamp;
            
            WholesalerDetails.DrugStatus = "Good";
            BatchWholesalerDetails[_SerialNumber] = WholesalerDetails;
            DrugDetails.CurrentproductOwner = tx.origin;
             DrugDetails.nextOwner = address(0);
             DrugDetails.status = "Received by Wholesaler"; 
             BatchDrugDetails[_SerialNumber] = DrugDetails;
             return true;
            }
            else{
                return false;
            }


        }



 function moveFromWholesaler(address _SerialNumber,
        uint32 _ExportingTemparature,
        address _ExporterAddress
        ) public onlyAuthCaller onlyDrugOwner(_SerialNumber) returns(bool){
               bool good =  isBad(_SerialNumber,_ExportingTemparature);
           if(good){
          DrugDetails = BatchDrugDetails[_SerialNumber];      
                     DrugDetails.status = "In Transit from Wholesaler"; 
                     DrugDetails.nextOwner = _ExporterAddress;
            WholesalerDetails.ExportingTemparature = _ExportingTemparature;
            WholesalerDetails.ExportingDateTime = block.timestamp;
            WholesalerDetails.ExporterAddress = _ExporterAddress;
            WholesalerDetails.DrugStatus = "Good";
            BatchWholesalerDetails[_SerialNumber] = WholesalerDetails;
             nextOwner[_SerialNumber] = 'Pharmacy';
             BatchDrugDetails[_SerialNumber] = DrugDetails;
            return true; 
           }
           else{
               return false;
           }
        }

function importToPharmacy(address _SerialNumber,
        string memory _PharmacyName,
        string memory _PharmacyAddress,
        uint32 _ImportingTemparature) public onlyAuthCaller onlyDrugReceiver(_SerialNumber) returns(bool){
               bool good =  isBad(_SerialNumber,_ImportingTemparature);
           if(good){
                  DrugDetails = BatchDrugDetails[_SerialNumber];
             DrugDetails.nextOwner = address(0); 
            DrugDetails.status = "Received by Pharmacy";
            PharmacyDetails.PharmacyName = _PharmacyName;
            PharmacyDetails.PharmacyAddress = _PharmacyAddress;
            PharmacyDetails.ImportingTemparature = _ImportingTemparature;
            PharmacyDetails.DrugStatus = "Good";
            PharmacyDetails.ImportingDateTime = block.timestamp;
            BatchPharmacyDetails[_SerialNumber] = PharmacyDetails;
             nextOwner[_SerialNumber] = 'DONE';
             BatchDrugDetails[_SerialNumber] = DrugDetails;
            return true;}
            else{
                return false;
            }
    
}
    /*get user details*/
    function getUser(address _userAddress) public onlyAuthCaller view returns(string memory ParticipantName,
                                                                    string memory UserName, 
                                                                    string memory Email, 
                                                                    string memory contactNo, 
                                                                    string memory role
                                            
                                                                ){

        /*Getting value from struct*/
        User memory tmpData = BatchUserDetails[_userAddress];
        
        return (tmpData.ParticipantName, tmpData.UserName, tmpData.Email,tmpData.contactNo, userRole[_userAddress]);
    }


    function getDrugDetails1(address _SerialNumber) public onlyAuthCaller view returns(uint32 _drugID,
        uint32 _batchID,
        string memory _drugName,
        string memory _Currentlocation,
        uint32 _cost
        ){

        Drug memory tmpData = BatchDrugDetails[_SerialNumber];

        return(tmpData.drugID,
        tmpData.batchID,
        tmpData.drugName,
        tmpData.Currentlocation,
        tmpData.cost
       );
        }



    function getDrugDetails2(address _SerialNumber) public onlyAuthCaller view returns(
        address _CurrentproductOwner,
        uint _mfgTimeStamp,
        uint _expTimeStamp,
        uint32  _CurrentTemperature,
        uint32 _IdealTemperature,
        address _nextOwner,
        string memory _status
        ){

        Drug memory tmpData = BatchDrugDetails[_SerialNumber];

        return(
        tmpData.CurrentproductOwner,
      
        tmpData.mfgTimeStamp,
        tmpData.expTimeStamp,
        tmpData.CurrentTemperature,
        tmpData.IdealTemperature,
        tmpData.nextOwner,
        tmpData.status);
        }


  

      /*get ManufacturerDetails*/
    function getManufacturerDetails(address _SerialNumber) public onlyAuthCaller view returns(string memory _name,
                             string memory _ManufacturerAddress,
                             address _ExporterAddress,
                             uint32 _ExportingTemparature,
                             uint _ExportingDateTime, 
                             string memory _DrugStatus) {
        
        Manufacturer memory tmpData = BatchManufactureringDetails[_SerialNumber];

        return (tmpData.name,tmpData.ManufacturerAddress,tmpData.ExporterAddress,tmpData.ExportingTemparature,tmpData.ExportingDateTime,tmpData.DrugStatus);
    }





 /*get DistributorDetails*/

  function getDistributorDetails(address _SerialNumber) public onlyAuthCaller view returns(string memory name,   
        string memory _DistributorAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint256 _ImportingDateTime,
        uint _ExportingDateTime,
        address _ExporterAddress,
        string memory _DrugStatus
    )
    { 
        distributor memory tmpData = BatchdistributorDetails[_SerialNumber];

        return (tmpData.name,tmpData.DistributorAddress, tmpData.ImportingTemparature, tmpData.ExportingTemparature,tmpData.ImportingDateTime,tmpData.ExportingDateTime,tmpData.ExporterAddress,tmpData.DrugStatus);
    }


    function getWholesalerDetails(address _SerialNumber
        )public view returns(string memory name,   
        string memory _WholesalerAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint256 _ImportingDateTime,
        uint256 _ExportingDateTime,
      address _ExporterAddress,
        string memory _DrugStatus) {
            Wholesaler memory tmpData = BatchWholesalerDetails[_SerialNumber];
                    return (tmpData.name,tmpData.WholesalerAddress, tmpData.ImportingTemparature, tmpData.ExportingTemparature,tmpData.ImportingDateTime,tmpData.ExportingDateTime,tmpData.ExporterAddress,tmpData.DrugStatus);

        }


        function getPharmacyDetails(address _SerialNumber)public view returns(string memory _PharmacyName,
        string memory _PharmacyAddress,
        uint32 _ImportingTemparature,
        string memory _DrugStatus,
        uint256 _ImportingDateTime) {

         Pharmacy memory tmpData = BatchPharmacyDetails[_SerialNumber];
         return(tmpData.PharmacyName,tmpData.PharmacyAddress,tmpData.ImportingTemparature,tmpData.DrugStatus,tmpData.ImportingDateTime);
           
        }






        /* authorize caller */
    function authorizeCaller(address _caller) public onlyAuthCaller returns(bool) 
    {
        authorizedCaller[_caller] = 1;
        emit AuthorizedCaller(_caller);
        return true;
    }
        
    /* deauthorize caller */
    function deAuthorizeCaller(address _caller) public onlyAuthCaller returns(bool) 
    {
        authorizedCaller[_caller] = 0;
        emit DeAuthorizedCaller(_caller);
        return true;
    }

 
   modifier onlyAuthCaller(){

        require(authorizedCaller[tx.origin] == 1);
        _;
    }
    modifier onlyOwner(){
        require(tx.origin == owner);
        _;
    }

    modifier onlyDrugOwner(address _SerialNumber){
        require(BatchDrugDetails[_SerialNumber].CurrentproductOwner == tx.origin);
        _;
    }

    modifier onlyDrugReceiver(address _SerialNumber){
            require(BatchDrugDetails[_SerialNumber].nextOwner == tx.origin);
            _;
    }
   

 /* Get Next Action  */    
    function getnextOwner(address _SerialNumber) public onlyAuthCaller view returns(string memory)
    {
        return nextOwner[_SerialNumber];
    }

function isBad(address _SerialNumber,uint32 Temparature) internal returns(bool){
    require(!BatchDrugDetails[_SerialNumber].isBad);
  DrugDetails = BatchDrugDetails[_SerialNumber];
  DrugDetails.CurrentTemperature = Temparature;
     

    if(Temparature > DrugDetails.IdealTemperature){
        DrugDetails.isBad = true;
        DrugDetails.status = "Exceeded ideal temperature";
           BatchDrugDetails[_SerialNumber]=DrugDetails;

        return false;
    }
    else if(DrugDetails.expTimeStamp <=block.timestamp){
         DrugDetails.isBad = true;
        DrugDetails.status = "Drug Expired";
           BatchDrugDetails[_SerialNumber]=DrugDetails;
        return false;
    }

    BatchDrugDetails[_SerialNumber]=DrugDetails;
        return true;

    }

}




//1646246054
