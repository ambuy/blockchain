pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";
import "./zeppelin/math/SafeMath.sol";
import "./Nameble.sol";

/**
 * TODO
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract InvestBridge is Ownable, Nameble {
    using SafeMath for uint256;

    /** ключ - адрес, значение - является или не является адрес инвест мостом */
    mapping (address => bool) public investsBridge;
    /** ключ - порядковый номер, значение - адрес инвест моста */
    mapping (uint256 => address) public investsBridgeIndex;
    /** Количество мостов в системе */
    uint256 public investsBridgesCount = 0;

    function InvestBridge() Nameble("InvestBridge", "1") public {

    }

    /**
     * Добавить адрес инвест моста в систему ambuy
     * @param _address адрес моста
     */
    function addInvestBridge(address _address) public onlyOwner {
        investsBridge[_address] = true;
        investsBridgeIndex[investsBridgesCount] = _address;
        investsBridgesCount = investsBridgesCount.add(1);
    }
}