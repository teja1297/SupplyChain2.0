// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;

import "./SupplyChainStorage.sol";

contract PharmaSupplyChain {
event addDrug(address indexed user, address indexed SerialNumber);
event MovedFromManufacturer(address indexed user, address indexed SerialNumber);
event MovedFromDistributor(address indexed user, address indexed SerialNumber);
event MovedFromWholesaler(address indexed user, address indexed SerialNumber);
event MovedToPharmacy(address indexed user, address indexed SerialNumber);


  modifier isValidPerformer(address _SerialNumber, string memory role) {
        require(keccak256(abi.encodePacked(supplyChainStorage.getUserRole(msg.sender))) == keccak256(abi.encodePacked(role)));
        require(keccak256(abi.encodePacked(supplyChainStorage.getnextOwner(_SerialNumber))) == keccak256(abi.encodePacked(role)));
        _;
    }

     /* Storage Variables */    
     SupplyChainStorage supplyChainStorage;
address[] DrugList;
 constructor(address _supplyChainAddress) public {
        supplyChainStorage = SupplyChainStorage(_supplyChainAddress);
      DrugList = supplyChainStorage.getDrugKeyList();
    }

    function getnextOwner(address _SerialNumber) public view returns(string memory Owner)
    {
       (Owner) = supplyChainStorage.getnextOwner(_SerialNumber);
       return (Owner);
    }


    function addUser(address  _userAddress,
                     string memory _name, 
                     string  memory _contactNo, 
                     string memory _role, 
                     bool _isActive) public returns(bool){

                       bool result = supplyChainStorage.setUser(_userAddress,_name,_contactNo,_role,_isActive);
                       
                        return result;
    }


   function addDrugDetails(uint32 _drugID,
        uint32 _batchID,
        string memory _drugName,
        string memory _Currentlocation,
        uint32 _cost,
        uint _mfgTimeStamp,
        uint _expTimeStamp,
        uint32  _CurrentTemperature,
        uint32 _IdealTemperature
     ) public  returns(address){
         address SerialNumber = supplyChainStorage.setDrugDetails(_drugID,_batchID,_drugName,_Currentlocation,_cost,_mfgTimeStamp,_expTimeStamp,_CurrentTemperature,_IdealTemperature);
          emit addDrug(msg.sender, SerialNumber); 
          return SerialNumber;
     }


      function MoveFromManufacturer(address _SerialNumber,
                             string memory _name,
                             string memory _ManufacturerAddress,
                             address _ExporterAddress,
                             uint32  _ExportingTemparature
                            
                             )public isValidPerformer(_SerialNumber,'Manufacturer')  returns(bool){

                                bool result =  supplyChainStorage.MoveFromManufacturer(_SerialNumber,_name,_ManufacturerAddress, _ExporterAddress,_ExportingTemparature);
                                emit MovedFromManufacturer(msg.sender,_SerialNumber);
                                return result;
                             }


function MoveFromDistributor(address _SerialNumber,
        string memory _name,   
        string memory _DistributorAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
       address _ExporterAddress
        ) public isValidPerformer(_SerialNumber,'Distributor') returns(bool){

             bool result =  supplyChainStorage.MoveFromDistributor(_SerialNumber,_name,_DistributorAddress,_ImportingTemparature, _ExportingTemparature,_ImportingDateTime,_ExporterAddress);
                                emit MovedFromDistributor(msg.sender,_SerialNumber);
                                return result;   
            }


function MoveFromWholesaler(address _SerialNumber,
        string memory _name,   
        string memory _WholesalerAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        address _ExporterAddress
        ) public isValidPerformer(_SerialNumber,'Wholesaler') returns(bool){

             bool result =  supplyChainStorage.moveFromWholesaler(_SerialNumber,_name,_WholesalerAddress,_ImportingTemparature, _ExportingTemparature,_ImportingDateTime,_ExporterAddress);
                                emit MovedFromWholesaler(msg.sender,_SerialNumber);
                                return result;   
            }



function importToPharmacy(address _SerialNumber,
        string memory _PharmacyName,
        string memory _PharmacyAddress,
        uint32 _ImportingTemparature,
        uint32 _ImportingDateTime) public isValidPerformer(_SerialNumber,'Pharmacy') returns(bool){
            bool result = supplyChainStorage.importToPharmacy(_SerialNumber,_PharmacyName,_PharmacyAddress,_ImportingTemparature,_ImportingDateTime);
            emit MovedToPharmacy(msg.sender,_SerialNumber);
            return result;
        }




 function getDrugDetails(address _SerialNumber) public  view returns(uint32 _drugID,
        uint32 _batchID,
        string memory _drugName,
        string memory _Currentlocation,
        address _CurrentproductOwner,
        uint32 _cost,
        uint _mfgTimeStamp,
        uint _expTimeStamp,
        uint32  _CurrentTemperature,
        uint32 _IdealTemperature,
        string memory _status){
      
      return supplyChainStorage.getDrugDetails(_SerialNumber);
      
        }



         function getManufacturerDetails(address _SerialNumber) public  view returns(string memory _name,
                             string memory _ManufacturerAddress,
                            address _ExporterAddress,
                             uint32 _ExportingTemparature,
                             uint256 _ExportingDateTime, 
                             string memory _DrugStatus) {
     (_name,_ManufacturerAddress,_ExporterAddress,_ExportingTemparature,_ExportingDateTime,_DrugStatus)=supplyChainStorage.getManufacturerDetails(_SerialNumber);

        return (_name,_ManufacturerAddress,_ExporterAddress,_ExportingTemparature,_ExportingDateTime,_DrugStatus);
 
        
         }
 function getDistributorDetails(address _SerialNumber) public  view returns(string memory name,   
        string memory _DistributorAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint256 _ExportingDateTime,
        address _ExporterAddress,
        string memory _DrugStatus
    )
    { 
                    (name,_DistributorAddress,_ImportingTemparature,_ExportingTemparature,_ImportingDateTime,_ExportingDateTime,_ExporterAddress,_DrugStatus) = supplyChainStorage.getWholesalerDetails(_SerialNumber);


          return (name,_DistributorAddress,_ImportingTemparature,_ExportingTemparature,_ImportingDateTime,_ExportingDateTime,_ExporterAddress,_DrugStatus);

    }
 function getWholesalerDetails(address _SerialNumber
        )public view returns(string memory name,   
        string memory _WholesalerAddress,
        uint32 _ImportingTemparature,
        uint32 _ExportingTemparature,
        uint32 _ImportingDateTime,
        uint256 _ExportingDateTime,
       address _ExporterAddress,
        string memory _DrugStatus) {
           (name,_WholesalerAddress,_ImportingTemparature,_ExportingTemparature,_ImportingDateTime,_ExportingDateTime,_ExporterAddress,_DrugStatus)=supplyChainStorage.getWholesalerDetails(_SerialNumber);
return(name,_WholesalerAddress,_ImportingTemparature,_ExportingTemparature,_ImportingDateTime,_ExportingDateTime,_ExporterAddress,_DrugStatus);

        }

        
   
        function getPharmacyDetails(address _SerialNumber)public view returns(string memory _PharmacyName,
        string memory _PharmacyAddress,
        uint32 _ImportingTemparature,
        string memory _DrugStatus,
        uint32 _ImportingDateTime) {

       (_PharmacyName,_PharmacyAddress,_ImportingTemparature,_DrugStatus,_ImportingDateTime)=supplyChainStorage.getPharmacyDetails(_SerialNumber);
return(_PharmacyName,_PharmacyAddress,_ImportingTemparature,_DrugStatus,_ImportingDateTime);

        }

}
