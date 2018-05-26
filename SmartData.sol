pragma solidity ^0.4.0;

contract SmartData {

    string public data;
    address public from;
    address public to;
    uint256 public startTime;
    uint256 public endTime;

    bool public valid = false;

    function SmartData(string _data, address _from, address _to, uint256 _startTime, uint256 _endTime) {
        data = _data;
        from = _from;
        to = _to;
        startTime = _startTime;
        endTime = _endTime;
    }
}
