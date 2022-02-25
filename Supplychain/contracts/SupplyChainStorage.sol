// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.2;

contract SupplyChainStorage{

address public owner;
    constructor() public{
        owner = msg.sender;
         authorizedCaller[msg.sender] = 1;
    }


    /* Events */
    event AuthorizedCaller(address caller);
    event DeAuthorizedCaller(address caller);


    mapping(address => string) userRole;

    mapping(address => uint8) authorizedCaller;
      mapping (address => string) nextOwner;

    
    struct User{
        string name;
        string contactNo;
        bool isActive;
     }


    struct Drug{
        uint32 drugID;
        uint32 batchID;
        string drugName;
        string Currentlocation;
        address CurrentproductOwner;
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
        uint32 ExportingDateTime;
        string DrugStatus;
    }

    struct Distributer{
        string name;
        string DistributorAddress;
        uint32 ImportingTemparature;
        uint32 ExportingTemparature;
        uint32 ImportingDateTime;
        uint32 ExportingDateTime;
        address ExporterAddress;
        string DrugStatus;
    }

    struct WhareHouse{
        string name;
        string WhareHouseAddress;
        uint32 ImportingTemparature;
        uint32 ExportingTemparature;
        uint32 ImportingDateTime;
        uint32 ExportingDateTime;
       address ExporterAddress;
        string DrugStatus;
    }

    struct Pharmacy{

        string PharmacyName;
        string PharmacyAddress;
        uint32 ImportingTemparature;
        string DrugStatus;
        uint32 ImportingDateTime;
    }
    mapping(address => Drug) BatchDrugDetails;
    mapping(address =>User) BatchUserDetails;
    mapping(address => Manufacturer)BatchManufactureringDetails;
    mapping(address =>Distributer)BatchDistributerDetails;
    mapping(address =>WhareHouse)BatchWhareHouseDetails;
    mapping(address =>Pharmacy)BatchPharmacyDetails;


        Drug DrugDetails;
        User UserDetail;
        Manufacturer ManufacturerDetails;
        Distributer DistributerDetails;
        WhareHouse WhareHouseDetails;
        Pharmacy PharmacyDetails;




    function getUserRole(address _userAddress) public onlyAuthCaller view returns( string memory)
    {
        return userRole[_userAddress];
    }

     function setUser(address  _userAddress,
                     string memory _name, 
                     string  memory _contactNo, 
                     string memory _role, 
                     bool _isActive) public onlyOwner returns(bool){
        
        /*store data into struct*/
        UserDetail.name = _name;
        UserDetail.contactNo = _contactNo;
        UserDetail.isActive = _isActive;
        authorizedCaller[_userAddress] = 1;
        /*store data into mapping*/
        BatchUserDetails[_userAddress] = UserDetail;
        userRole[_userAddress] = _role;
        
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
        nextOwner[SerialNumber] = "Manufacturer";
        BatchDrugDetails[SerialNumber] = DrugDetails;
        return SerialNumber;

    }

 


 /*Set ManufacturerDetails*/
    function MoveFromManufacturer(address _SerialNumber,
                             string memory _name,
                             string memory _ManufacturerAddress,
                             address  _ExporterAddress,
                             uint32  _ExportingTemparature,
                             uint32 _ExportingDateTime
                             )public onlyAuthCaller  returns(bool){      
                bool good =  isBad(_SerialNumber,_ExportingTemparature,_ExporterAddress);
           if(good){                     
         ManufacturerDetails.name = _name;
         ManufacturerDetails.ManufacturerAddress = _ManufacturerAddress;
         ManufacturerDetails.ExporterAddress = _ExporterAddress;
         ManufacturerDetails.ExportingTemparature = _ExportingTemparature;
         ManufacturerDetails.ExportingDateTime = _ExportingDateTime;
         BatchManufactureringDetails[_SerialNumber] = ManufacturerDetails;
          nextOwner[_SerialNumber] = 'Distributor'; 
        
         return true;}
         else{
             return false;
         }
        }

    function MoveFromDistributor(address _SerialNumber,
        string memory _name,   
        string memory _DistributorAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint32 _ExportingDateTime,
        address _ExporterAddress
        ) public onlyAuthCaller returns(bool){
           bool good =  isBad(_SerialNumber,_ExportingTemparature,_ExporterAddress);
           if(good){
            DistributerDetails.name = _name;
            DistributerDetails.DistributorAddress =  _DistributorAddress;
            DistributerDetails.ImportingTemparature = _ImportingTemparature;
            DistributerDetails.ExportingTemparature = _ExportingTemparature;
            DistributerDetails.ImportingDateTime = _ImportingDateTime;
            DistributerDetails.ExportingDateTime = _ExportingDateTime;
            DistributerDetails.ExporterAddress = _ExporterAddress;
            DistributerDetails.DrugStatus = "Good";
            BatchDistributerDetails[_SerialNumber] = DistributerDetails;
             nextOwner[_SerialNumber] = 'WhareHouse'; 
            return true; 
           }
           else{
               return false;
           }
        }



 function moveFromWhareHouse(address _SerialNumber,
        string memory _name,   
        string memory _WhareHouseAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint32 _ExportingDateTime,
        address _ExporterAddress
        ) public onlyAuthCaller returns(bool){
               bool good =  isBad(_SerialNumber,_ExportingTemparature,_ExporterAddress);
           if(good){
            WhareHouseDetails.name = _name;
            WhareHouseDetails.WhareHouseAddress =  _WhareHouseAddress;
            WhareHouseDetails.ImportingTemparature = _ImportingTemparature;
            WhareHouseDetails.ExportingTemparature = _ExportingTemparature;
            WhareHouseDetails.ImportingDateTime = _ImportingDateTime;
            WhareHouseDetails.ExportingDateTime = _ExportingDateTime;
            WhareHouseDetails.ExporterAddress = _ExporterAddress;
            WhareHouseDetails.DrugStatus = "Good";
            BatchWhareHouseDetails[_SerialNumber] = WhareHouseDetails;
             nextOwner[_SerialNumber] = 'Pharmacy';
            return true; 
           }
           else{
               return false;
           }
        }



function importToPharmacy(address _SerialNumber,
        string memory _PharmacyName,
        string memory _PharmacyAddress,
        uint32 _ImportingTemparature,
        uint32 _ImportingDateTime) public onlyAuthCaller  returns(bool){
               bool good =  isBad(_SerialNumber,_ImportingTemparature,address(0));
           if(good){

            PharmacyDetails.PharmacyName = _PharmacyName;
            PharmacyDetails.PharmacyAddress = _PharmacyAddress;
            PharmacyDetails.ImportingTemparature = _ImportingTemparature;
            PharmacyDetails.DrugStatus = "Good";
            PharmacyDetails.ImportingDateTime = _ImportingDateTime;
            BatchPharmacyDetails[_SerialNumber] = PharmacyDetails;
             nextOwner[_SerialNumber] = 'DONE';
            return true;}
            else{
                return false;
            }
    
}
    /*get user details*/
    function getUser(address _userAddress) public onlyAuthCaller view returns(string memory name, 
                                                                    string memory contactNo, 
                                                                    string memory role,
                                                                    bool isActive
                                                                ){

        /*Getting value from struct*/
        User memory tmpData = BatchUserDetails[_userAddress];
        
        return (tmpData.name, tmpData.contactNo, userRole[_userAddress], tmpData.isActive);
    }


    function getDrugDetails(address _SerialNumber) public onlyAuthCaller view returns(uint32 _drugID,
        uint32 _batchID,
        string memory _drugName,
        string memory _Currentlocation,
        address _CurrentproductOwner,
        uint32 _cost,
        uint _mfgTimeStamp,
        uint _expTimeStamp,
        uint32  _CurrentTemperature,
        uint32 _IdealTemperature,
        string memory _status
        ){

        Drug memory tmpData = BatchDrugDetails[_SerialNumber];

        return(tmpData.drugID,
        tmpData.batchID,
        tmpData.drugName,
        tmpData.Currentlocation,
        tmpData.CurrentproductOwner,
        tmpData.cost,
        tmpData.mfgTimeStamp,
        tmpData.expTimeStamp,
        tmpData.CurrentTemperature,
        tmpData.IdealTemperature,
        tmpData.status);
        }




  

      /*get ManufacturerDetails*/
    function getManufacturerDetails(address _SerialNumber) public onlyAuthCaller view returns(string memory _name,
                             string memory _ManufacturerAddress,
                             address _ExporterAddress,
                             uint32 _ExportingTemparature,
                             uint32 _ExportingDateTime, 
                             string memory _DrugStatus) {
        
        Manufacturer memory tmpData = BatchManufactureringDetails[_SerialNumber];

        return (tmpData.name,tmpData.ManufacturerAddress,tmpData.ExporterAddress,tmpData.ExportingTemparature,tmpData.ExportingDateTime,tmpData.DrugStatus);
    }





 /*get DistributorDetails*/

  function getDistributorDetails(address _SerialNumber) public onlyAuthCaller view returns(string memory name,   
        string memory _DistributorAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint32 _ExportingDateTime,
        address _ExporterAddress,
        string memory _DrugStatus
    )
    { 
        Distributer memory tmpData = BatchDistributerDetails[_SerialNumber];

        return (tmpData.name,tmpData.DistributorAddress, tmpData.ImportingTemparature, tmpData.ExportingTemparature,tmpData.ImportingDateTime,tmpData.ExportingDateTime,tmpData.ExporterAddress,tmpData.DrugStatus);
    }


    function getWhareHouseDetails(address _SerialNumber
        )public view returns(string memory name,   
        string memory _whareHouseAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint32 _ExportingDateTime,
      address _ExporterAddress,
        string memory _DrugStatus) {
            WhareHouse memory tmpData = BatchWhareHouseDetails[_SerialNumber];
                    return (tmpData.name,tmpData.WhareHouseAddress, tmpData.ImportingTemparature, tmpData.ExportingTemparature,tmpData.ImportingDateTime,tmpData.ExportingDateTime,tmpData.ExporterAddress,tmpData.DrugStatus);

        }


        function getPharmacyDetails(address _SerialNumber)public view returns(string memory _PharmacyName,
        string memory _PharmacyAddress,
        uint32 _ImportingTemparature,
        string memory _DrugStatus,
        uint32 _ImportingDateTime) {

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
   

 /* Get Next Action  */    
    function getnextOwner(address _SerialNumber) public onlyAuthCaller view returns(string memory)
    {
        return nextOwner[_SerialNumber];
    }

function isBad(address _SerialNumber,uint32 _ExportingTemparature,address currentowner) internal returns(bool){
    require(!BatchDrugDetails[_SerialNumber].isBad);
  DrugDetails = BatchDrugDetails[_SerialNumber];
  DrugDetails.CurrentTemperature = _ExportingTemparature;
     

    if(_ExportingTemparature > DrugDetails.IdealTemperature){
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
    DrugDetails.CurrentproductOwner = currentowner;
    BatchDrugDetails[_SerialNumber]=DrugDetails;

        return true;

    }

}






