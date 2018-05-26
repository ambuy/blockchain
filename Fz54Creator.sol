pragma solidity ^0.4.21;

import "./AmbuyConsensus.sol";
import "./ShoppingList.sol";

/**
 * Контракт через который происходит добавление данных по 54ФЗ (Росссия)
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract Fz54Creator is Nameble {

    /** TODO */
    address public ambuyConsensusAddress;

    /** TODO */
    address public addressFz54Validators;

    /** Список данных порожденных через данный смарт контракт */
    mapping(address => bool) public children;

    /** Событие о добавление новых данных */
    event LogAddData(address childrenAddress);

    /**
     * Конструктор TODO
     */
    function Fz54Creator(address _ambuyConsensusAddress, address _addressFz54Validators) Nameble("Fz54Creator", "1") public {
        ambuyConsensusAddress = _ambuyConsensusAddress;
        addressFz54Validators = _addressFz54Validators;
    }

    /**
     * Добавить данные для проверки в блокчейн
     * @param _qrInfo    информация из qr
     * @param _checkInfo контент чека
     */
    function addData(string _qrInfo, string _checkInfo) public returns (bool)  {
        ShoppingList child = new ShoppingList(_qrInfo, _checkInfo, msg.sender);
        children[child] = true;
        emit LogAddData(child);
        return true;
    }
}
