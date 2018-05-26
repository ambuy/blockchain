pragma solidity ^0.4.0;

contract Nameble {
    
    string public name;
    string public version;
    
    function Nameble(string _name, string _version){
        name = _name;
        version = _version;
    }
}
