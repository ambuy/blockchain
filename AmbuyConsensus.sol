pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";
import "./zeppelin/math/SafeMath.sol";
import "./Nameble.sol";

/**
 * Конфигурация системы ambuy
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract AmbuyConsensus is Ownable, Nameble {
    using SafeMath for uint256;

    /** Адрес инвестиционного контракта */
    address public addressInvestContract;
    /** Адрес контракта AmbuyCoin */
    address public addressAmbuyCoin;
    /** Адрес контракта через который добавляются даннные по 54ФЗ */
    address public addressFz54DataCreator;
    /** Адрес контракта с логикой эмиссии */
    address public addressAmbuyEmissionLogic;

    function AmbuyConsensus() Nameble("AmbuyConsensus", "1") {
    }

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
    function setAddressAmbuyEmissionLogic(address _address) public onlyOwner {
        addressAmbuyEmissionLogic = _address;
    }
}