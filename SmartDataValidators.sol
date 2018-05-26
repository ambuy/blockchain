pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";
import "./zeppelin/math/SafeMath.sol";
import "./Nameble.sol";

/**
 * TODO
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract SmartDataValidators is Nameble, Ownable {
    using SafeMath for uint256;

    /** ключ - адрес, значение - является или не является адрес валидатороом need контрактов */
    mapping (address => bool) public validators;
    /** ключ - порядковый номер, значение - адрес валидатора need контрактов */
    mapping (uint256 => address) public validatorsIndex;
    /** Количество валидаторов need контрактов в системе */
    uint256 public validatorsCount = 0;

    function SmartDataValidators() Nameble("SmartDataValidators", "1") public {
    }

    /**
     * Добавить адрес need валидатора в систему ambuy
     * @param _address адрес валидатора
    */
    function addValidator(address _address) public onlyOwner {
        validators[_address] = true;
        validatorsIndex[validatorsCount] = _address;
        validatorsCount = validatorsCount.add(1);
    }
}