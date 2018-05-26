pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";

import "./Need.sol";
import "./AmbuyCoin.sol";
import "./SmartOffer.sol";
import "./SmartDataValidators.sol";
import "./AmbuyConsensus.sol";

/**
 *
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract SmartOfferCreator is Ownable, Nameble {

    /** TODO */
    address public addressAmbuyConsensus;

    address public addressSmartDataValidators;

    uint256 public amountSmartOffer;

    /** Список данных порожденных через данный смарт контракт */
    mapping(address => bool) public children;

    /** Событие о добавление новых данных */
    event LogAddData(address childrenAddress);

    /**
     * Конструктор TODO
     */
    function SmartOfferCreator(address _addressAmbuyConsensus, address _addressSmartDataValidators) Nameble("SmartOfferCreator", "1") public {
        addressAmbuyConsensus = _addressAmbuyConsensus;
        addressSmartDataValidators = _addressSmartDataValidators;
    }

    /**
     *
     * @param _data TODO
     */
    function addData(string _data, address _parent,
                     address _to,
                     uint256 _startTime, uint256 _endTime,
                     uint256 _lockCount, uint256 _rewardCount) public returns (bool)  {
        AmbuyConsensus ambuyConsensus = AmbuyConsensus(addressAmbuyConsensus);
        AmbuyCoin ambuyCoin = AmbuyCoin(ambuyConsensus.addressAmbuyCoin());
        ambuyCoin.burnFrom(msg.sender, amountSmartOffer);
        require(ambuyCoin.allowance(msg.sender, address(this)) >= (_rewardCount + amountSmartOffer));
        SmartOffer child = new SmartOffer(_data, _parent, msg.sender, _to, _startTime, _endTime, _lockCount, _rewardCount);
        if (_rewardCount > 0) {
            ambuyCoin.transferFrom(msg.sender, child, rewardCount);
        }
        children[child] = true;
        emit LogAddData(child);
        return true;
    }

    function setAmountSmartOffer(uint256 _amountSmartOffer) public onlyOwner {
        amountSmartOffer = _amountSmartOffer;
    }
}
