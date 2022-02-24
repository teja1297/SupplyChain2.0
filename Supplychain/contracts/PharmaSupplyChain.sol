pragma solidity ^0.6.2;

import "./SupplyChainStorage.sol";
contract PharmaSupplyChain {
event addDrug(address indexed user, address indexed SerialNumber);
event MovedFromManufacturer(address indexed user, address indexed SerialNumber);
event MovedFromDistributor(address indexed user, address indexed SerialNumber);
event MovedFromWhareHouse(address indexed user, address indexed SerialNumber);



  modifier isValidPerformer(address _SerialNumber, string role) {
    
        require(keccak256(supplyChainStorage.getUserRole(msg.sender)) == keccak256(role));
        require(keccak256(supplyChainStorage.getnextOwner(_SerialNumber)) == keccak256(role));
        _;
    }
     /* Storage Variables */    
     SupplyChainStorage supplyChainStorage;

 constructor(address _supplyChainAddress) public {
        supplyChainStorage = SupplyChainStorage(_supplyChainAddress);
    }

    function getnextOwner(address _SerialNumber) public view returns(string Owner)
    {
       (Owner) = supplyChainStorage.getnextOwner(_SerialNumber);
       return (Owner);
    }


    function addUser(address  _userAddress,
                     string memory _name, 
                     string  memory _contactNo, 
                     string memory _role, 
                     bool _isActive) public returns(bool){

                       bool result = SupplyChainStorage.setUser(_userAddress,_name,_contactNo,_role,_isActive);
                       
                        return result;
    }

   function addDrugDetails(uint32 _drugID,
        uint32 _batchID,
        string memory _drugName,
        string memory _Currentlocation,
        address _CurrentproductOwner,
        uint32 _cost,
        uint _mfgTimeStamp,
        uint _expTimeStamp,
        uint32  _CurrentTemperature,
        uint32 _IdealTemperature
     ) public  returns(address){
         address SerialNumber = SupplyChainStorage.setDrugDetails(_drugID,_batchID,_drugName,_Currentlocation,_CurrentproductOwner,_cost,_mfgTimeStamp,_expTimeStamp,_CurrentTemperature,_IdealTemperature);
          emit addDrug(msg.sender, SerialNumber); 
          return SerialNumber;
     }

      function MoveFromManufacturer(address _SerialNumber,
                             string memory _name,
                             string memory _ManufacturerAddress,
                             string memory _ExporterName,
                             uint32  _ExportingTemparature,
                             uint32 _ExportingDateTime
                             )public isValidPerformer(_SerialNumber,'Manufacturer')  returns(bool){

                                bool result =  SupplyChainStorage.MoveFromManufacturer(_SerialNumber,_name,_ManufacturerAddress, _ExporterName,_ExportingTemparature,_ExportingDateTime);
                                emit MovedFromManufacturer(msg.sender,_SerialNumber);
                                return result;
                             }


function MoveFromDistributor(address _SerialNumber,
        string memory _name,   
        string memory _DistributorAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint32 _ExportingDateTime,
        string memory _ExporterName
        ) public isValidPerformer(_SerialNumber,'Distributor') returns(bool){

             bool result =  SupplyChainStorage.MoveFromDistributor(_SerialNumber,_name,_DistributorAddress,_ImportingTemparature, _ExportingTemparature,_ImportingDateTime,_ExportingDateTime,_ExporterName);
                                emit MovedFromDistributor(msg.sender,_SerialNumber);
                                return result;   
            }



function MoveFromWhareHouse(address _SerialNumber,
        string memory _name,   
        string memory _WhareHouseAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint32 _ExportingDateTime,
        string memory _ExporterName
        ) public isValidPerformer(_SerialNumber,'WhareHouse') returns(bool){

             bool result =  SupplyChainStorage.MoveFromWhareHouse(_SerialNumber,_name,_WhareHouseAddress,_ImportingTemparature, _ExportingTemparature,_ImportingDateTime,_ExportingDateTime,_ExporterName);
                                emit MovedFromWhareHouse(msg.sender,_SerialNumber);
                                return result;   
            }





function importToPharmacy(address _SerialNumber,
        string memory _PharmacyName,
        string memory _PharmacyAddress,
        uint32 _ImportingTemparature,
        uint32 _ImportingDateTime) public isValidPerformer(_SerialNumber,'Pharmacy') returns(bool){
            bool result = SupplyChainStorage.importToPharmacy(_SerialNumber,_PharmacyName,_PharmacyAddress,_ImportingTemparature,_ImportingDateTime);
            emit MovedToPharmacy(msg.sender,_SerialNumber);
            return result;
        }


                












    /*Get Drug Details*/
    function getDrugDetails(address _serialNumber) public view returns(uint32 _drugID,
        uint32 _batchID,
        string _drugName,
        string _Currentlocation,
        address _CurrentproductOwner,
        uint32 _cost,
        uint _mfgTimeStamp,
        uint _expTimeStamp,
        uint32  _CurrentTemperature,
        uint32 _IdealTemperature,
        string _status){
      
      (drugID,_batchID,drugName,Currentlocation,CurrentproductOwner,cost,mfgTimeStamp,expTimeStamp,CurrentTemperature,IdealTemperature,status)= supplyChainStorage.getDrugDetails(_serialNumber);
      return (drugID,_batchID,drugName,Currentlocation,CurrentproductOwner,cost,mfgTimeStamp,expTimeStamp,CurrentTemperature,IdealTemperature,status);
        }



         function getManufacturerDetails(address _SerialNumber) public onlyAuthCaller view returns(string memory _name,
                             string memory _ManufacturerAddress,
                             string memory _ExporterName,
                             uint32 _ExportingTemparature,
                             uint32 _ExportingDateTime, 
                             string memory _DrugStatus) {
        
       (name,ManufacturerAddress,ExporterName,ExportingTemparature,ExportingDateTime,DrugStatus)=supplyChainStorage.getManufacturerDetails(_SerialNumber);

        return (name,ManufacturerAddress,ExporterName,ExportingTemparature,ExportingDateTime,DrugStatus);
    }
 function getDistributorDetails(address _SerialNumber) public onlyAuthCaller view returns(string memory name,   
        string memory _DistributorAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint32 _ExportingDateTime,
        string memory _ExporterName,
        string memory _DrugStatus
    )
    { 
                    (name,DistributorAddress,ImportingTemparature,ExportingTemparature,ImportingDateTime,ExportingDateTime,ExporterName,DrugStatus) = supplyChainStorage.getWhareHouseDetails(_SerialNumber);


          return (name,DistributorAddress, ImportingTemparature, ExportingTemparature,ImportingDateTime,ExportingDateTime,ExporterName,DrugStatus);

    }
 function getWhareHouseDetails(address _SerialNumber
        )public view returns(string memory name,   
        string memory _whareHouseAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint32 _ExportingDateTime,
        string memory _ExporterName,
        string memory _DrugStatus) {
            (name,WhareHouseAddress,ImportingTemparature,ExportingTemparature,ImportingDateTime,ExportingDateTime,ExporterName,DrugStatus) = supplyChainStorage.getWhareHouseDetails(_SerialNumber);
                    return (name,WhareHouseAddress, ImportingTemparature, ExportingTemparature,ImportingDateTime,ExportingDateTime,ExporterName,DrugStatus);

        }

        
        function getPharmacyDetails(address _SerialNumber)public view returns(string memory _PharmacyName,
        string memory _PharmacyAddress,
        uint32 _ImportingTemparature,
        string memory _DrugStatus,
        uint32 _ImportingDateTime) {

        (PharmacyName,PharmacyAddress,ImportingTemparature,ImportingDateTime) = supplyChainStorage.getPharmacyDetails(_SerialNumber);
         return(PharmacyName,PharmacyAddress,ImportingTemparature,DrugStatus,ImportingDateTime);
           
        }
}
