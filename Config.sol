pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";
import "./zeppelin/math/SafeMath.sol";

/**
 * Конфигурация системы ambuy
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract Config is Ownable {
    using SafeMath for uint256;

    /** ключ - адрес, значение - является или не является адрес валидатором */
    mapping (address => bool) public validators;
    /** ключ - порядковый номер, значение - адрес валидатора */
    mapping (uint256 => address) public validatorsIndex;
    /** Количество валидаторов в системе */
    uint256 public validatorsCount = 0;

    /** ключ - адрес, значение - является или не является адрес инвест мостом */
    mapping (address => bool) public investsBridge;
    /** ключ - порядковый номер, значение - адрес инвест моста */
    mapping (uint256 => address) public investsBridgeIndex;
    /** Количество мостов в системе */
    uint256 public investsBridgesCount = 0;

    /** Адрес инвестиционного контракта */
    address public addressInvestContract;
    /** Адрес контракта AmbuyCoin */
    address public addressAmbuyCoin;
    /** Адрес контракта через который добавляются даннные по 54ФЗ */
    address public addressFz54DataCreator;
    /** Адрес контракта с логикой эмиссии */
    address public addressEmissionLogic;

    /**
    * Установить адрес инвестиционного контракта
    * @param _address адрес контракта
    */
    function setAddressInvestContract(address _address) public onlyOwner {
        addressInvestContract = _address;
    }

    /**
    * Установить адрес контракта с монетами ambuy
    * @param _address адрес контракта
    */
    function setAddressAmbuyCoin(address _address) public onlyOwner {
        addressAmbuyCoin = _address;
    }

    /**
    * Установить адрес контракта для добавления данных по 54ФЗ
    * @param _address адрес контракта
    */
    function setAddressFz54DataCreator(address _address) public onlyOwner {
        addressFz54DataCreator = _address;
    }

    /**
    * Установить адрес контракта с логикой по эмиссии
    * @param _address адрес контракта
    */
    function setAddressEmissionLogic(address _address) public onlyOwner {
        addressEmissionLogic = _address;
    }

    /**
     * Добавить адрес инвест моста в систему ambuy
     * @param _address адрес моста
     */
    function addInvestBridge(address _address) public onlyOwner {
        investsBridge[_address] = true;
        investsBridgeIndex[validatorsCount] = _address;
        investsBridgesCount = investsBridgesCount.add(1);
    }

    /**
     * Добавить адрес валидатора в систему ambuy
     * @param _address адрес валидатора
     */
    function addValidator(address _address) public onlyOwner {
        validators[_address] = true;
        validatorsIndex[validatorsCount] = _address;
        validatorsCount = validatorsCount.add(1);
    }

}
