pragma solidity ^0.4.21;

import "./Config.sol";
import "./Fz54Data.sol";

/**
 * Контракт через который происходит добавление данных по 54ФЗ (Росссия)
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract Fz54Creator {

    /** Адрес конфигурации */
    address public addressConfig;

    /** Список данных порожденных через данный смарт контракт */
    mapping(address => bool) public children;

    /** Событие о добавление новых данных */
    event LogAddData(address childrenAddress);

    /**
     * Конструктор
     * @param _addressConfig - адрес конвигурации
     */
    function Fz54Creator(address _addressConfig) public {
        addressConfig = _addressConfig;
    }

    /**
     * Добавить данные для проверки в блокчейн
     * @param qrInfo    информация из qr
     * @param checkInfo контент чека
     */
    function addData(string qrInfo, string checkInfo) public returns (bool)  {
        Fz54Data child = new Fz54Data(qrInfo, checkInfo, msg.sender);
        children[child] = true;
        emit LogAddData(child);
        return true;
    }
}
