pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";

import "./AmbuyConsensus.sol";
import "./NeedCreator.sol";
import "./SmartData.sol";
import "./AmbuyCoin.sol";
import "./SmartOfferCreator.sol";

/**
 *
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 18.05.2018
 */
contract SmartOffer is SmartData, Nameble, Ownable {

    string public additionalData;
    string public userData;
    uint256 public lockCount;
    uint256 public rewardCount;
    address public parent;
    
    /**
     *  0 - NEW
     *  1 - ACCEPTED
     *  2 - EXECUTED
     *  3 - REJECT
     */
    uint public status;

    function SmartOffer(string _data, string _additionalData, address _parent,
                        address _from, address _to,
                        uint256 _startTime, uint256 _endTime,
                        uint256 _lockCount, uint256 _rewardCount)
                Nameble("SmartOffer", "1")
                SmartData(_data, _from, _to, _startTime, _endTime)  public {
        lockCount = _lockCount;
        rewardCount = _rewardCount;
        parent = _parent;
        additionalData = _additionalData;
        status = 0;

    }

    function validate() {
        require(!valid);
        // Получаем конфигурацию - конфигурация записана в SmartOfferCreator TODO в создателе данного контракта
        SmartDataValidators smartDataValidators = SmartDataValidators(SmartOfferCreator(owner).addressSmartDataValidators());
        // Проверяем что вызывающий контракт, является одним из валидаторов
        require(smartDataValidators.validators(msg.sender));
        valid = true;
    }

    function executed() {
        require(msg.sender == from);
        require(valid);
        require(status == 1);
        AmbuyConsensus ambuyConsensus = AmbuyConsensus(SmartOfferCreator(owner).addressAmbuyConsensus());
        AmbuyCoin ambuyCoin = AmbuyCoin(ambuyConsensus.addressAmbuyCoin());
        if (lockCount > 0) {
            ambuyCoin.transfer(to, lockCount);
        }
        if (rewardCount > 0) {
            ambuyCoin.transfer(to, rewardCount);
        }
        status = 2;
    }

    function reject() {
        require(valid);
        require(block.timestamp >= endTime);
        require(status != 2);
        require(status != 3);
        AmbuyConsensus ambuyConsensus = AmbuyConsensus(SmartOfferCreator(owner).addressAmbuyConsensus());
        AmbuyCoin ambuyCoin = AmbuyCoin(ambuyConsensus.addressAmbuyCoin());
        if (status == 0) {
            ambuyCoin.transfer(from, rewardCount);
        } else if (status == 1) {
            ambuyCoin.transfer(from, rewardCount);
            ambuyCoin.transfer(to, lockCount);
        }
        status = 3;

    }

    function accept(string _userData) public {
        require(msg.sender == to);
        require(valid);
        require(status == 0);
        require(block.timestamp < endTime);
        if (lockCount > 0) {
            AmbuyConsensus ambuyConsensus = AmbuyConsensus(SmartOfferCreator(owner).addressAmbuyConsensus());
            AmbuyCoin ambuyCoin = AmbuyCoin(ambuyConsensus.addressAmbuyCoin());
            ambuyCoin.transferFrom(msg.sender, address(this), lockCount);
        }
        userData = _userData;
        status = 1;
    }
}