const web3 = require('web3');

const address = "0x822337e5A2c54B85E59eDA093591465E6Cc5e5D2";

const abi = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_supplyChainAddress",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "SerialNumber",
				"type": "address"
			}
		],
		"name": "MovedFromDistributor",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "SerialNumber",
				"type": "address"
			}
		],
		"name": "MovedFromManufacturer",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "SerialNumber",
				"type": "address"
			}
		],
		"name": "MovedFromWholesaler",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "SerialNumber",
				"type": "address"
			}
		],
		"name": "MovedToPharmacy",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "user",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "SerialNumber",
				"type": "address"
			}
		],
		"name": "addDrug",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "DistributorTreeDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "DistributorAddress",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "ImportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "ExportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint256",
				"name": "ImportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "ExportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "ExporterAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "DrugStatus",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "ManufacturerTreeDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "ManufacturerAddress",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "ExporterAddress",
				"type": "address"
			},
			{
				"internalType": "uint32",
				"name": "ExportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint256",
				"name": "ExportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "DrugStatus",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			},
			{
				"internalType": "uint32",
				"name": "_ExportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "address",
				"name": "_ExporterAddress",
				"type": "address"
			}
		],
		"name": "MoveFromDistributor",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_ManufacturerAddress",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "_ExporterAddress",
				"type": "address"
			},
			{
				"internalType": "uint32",
				"name": "_ExportingTemparature",
				"type": "uint32"
			}
		],
		"name": "MoveFromManufacturer",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			},
			{
				"internalType": "uint32",
				"name": "_ExportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "address",
				"name": "_ExporterAddress",
				"type": "address"
			}
		],
		"name": "MoveFromWholesaler",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "PharmacyTreeDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "PharmacyName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "PharmacyAddress",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "ImportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "DrugStatus",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "ImportingDateTime",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "WholesalerTreeDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "WholesalerAddress",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "ImportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "ExportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint256",
				"name": "ImportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "ExportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "ExporterAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "DrugStatus",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint32",
				"name": "_drugID",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "_batchID",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "_drugName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_Currentlocation",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "_cost",
				"type": "uint32"
			},
			{
				"internalType": "uint256",
				"name": "_mfgTimeStamp",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_expTimeStamp",
				"type": "uint256"
			},
			{
				"internalType": "uint32",
				"name": "_CurrentTemperature",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "_IdealTemperature",
				"type": "uint32"
			}
		],
		"name": "addDrugDetails",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_userAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_ParticipantName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_contactNo",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_role",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_Username",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_password",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_Email",
				"type": "string"
			},
			{
				"internalType": "bool",
				"name": "_isActive",
				"type": "bool"
			}
		],
		"name": "addUser",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "getDistributorDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_DistributorAddress",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "_ImportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "_ExportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint256",
				"name": "_ImportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_ExportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_ExporterAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_DrugStatus",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "getDrugDetails1",
		"outputs": [
			{
				"internalType": "uint32",
				"name": "_drugID",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "_batchID",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "_drugName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_Currentlocation",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "_cost",
				"type": "uint32"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "getDrugDetails2",
		"outputs": [
			{
				"internalType": "address",
				"name": "_CurrentproductOwner",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_mfgTimeStamp",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_expTimeStamp",
				"type": "uint256"
			},
			{
				"internalType": "uint32",
				"name": "_CurrentTemperature",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "_IdealTemperature",
				"type": "uint32"
			},
			{
				"internalType": "address",
				"name": "_nextOwner",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_status",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getDrugList",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "DrugKeyList",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "getManufacturerDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_ManufacturerAddress",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "_ExporterAddress",
				"type": "address"
			},
			{
				"internalType": "uint32",
				"name": "_ExportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint256",
				"name": "_ExportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_DrugStatus",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "getPharmacyDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "_PharmacyName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_PharmacyAddress",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "_ImportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "string",
				"name": "_DrugStatus",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_ImportingDateTime",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_userAddress",
				"type": "address"
			}
		],
		"name": "getUser",
		"outputs": [
			{
				"internalType": "string",
				"name": "_ParticipantName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_Username",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_Email",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_contactNo",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_role",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getUserList",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "UserList",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_userAddress",
				"type": "address"
			}
		],
		"name": "getUserRole",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "getWholesalerDetails",
		"outputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_WholesalerAddress",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "_ImportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint32",
				"name": "_ExportingTemparature",
				"type": "uint32"
			},
			{
				"internalType": "uint256",
				"name": "_ImportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_ExportingDateTime",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "_ExporterAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_DrugStatus",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			}
		],
		"name": "getnextOwner",
		"outputs": [
			{
				"internalType": "string",
				"name": "Owner",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_PharmacyName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_PharmacyAddress",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "_ImportingTemparature",
				"type": "uint32"
			}
		],
		"name": "importToPharmacy",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_DistributorAddress",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "_ImportingTemparature",
				"type": "uint32"
			}
		],
		"name": "receivedToDistributor",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_SerialNumber",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_WholesalerAddress",
				"type": "string"
			},
			{
				"internalType": "uint32",
				"name": "_ImportingTemparature",
				"type": "uint32"
			}
		],
		"name": "receivedToWholeSaler",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "test",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "x",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
module.exports = {address,abi};

