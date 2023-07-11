// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hospital{
    address public admin; 
    string labReports;
    address patientId;
    mapping(address=>string)  accessReports;

    struct patient{
        string name;
        uint age;
        string diseaseHistory;
        address patientId;
    }
    mapping (address=>patient) public details;
    address[] patients;
    
    constructor(){
        admin = msg.sender;
    }
    modifier onlyAdmin(){
        require(msg.sender==admin,"Only admin can call function");
        _;
    }

    function patientExists(address _patientId)public onlyAdmin view returns(bool result){
        for(uint i =0;i<patients.length; i++){
            if(patients[i]== _patientId){
                result= true;
            }else{
                result =  false;
                }
        }
    }

    function addPatient(string memory _name,uint _age,string memory _diseaseHistory,address _patientId)public onlyAdmin {
        require(patientExists(_patientId)==false,"Patient already exists");
        patient memory p1= patient({
            name : _name,
            age : _age,
            diseaseHistory:_diseaseHistory,
            patientId : _patientId
        });
        details[_patientId]=p1;
        patients.push(_patientId);
    }

    function upload(string memory _labreports, address _patientId) public  onlyAdmin{
        require(patientExists(_patientId)==true,"Patient does not exists");
        labReports= _labreports;
        patientId=_patientId;
        accessReports[_patientId] = labReports;
        
    }
     function Accesslabreports()public view  returns(string memory){
         require(patientId ==msg.sender,"Invalid patient Id");
         require(msg.sender!= admin,"admin cannot access this report");
         return accessReports[patientId];

     }

}