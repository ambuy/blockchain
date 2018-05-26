pragma solidity ^0.4.21;

import "./Need.sol";
import "./Nameble.sol";

/**
 * Контракт через который происходит добавление потребностей пользователей
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 18.05.2018
 */
contract NeedCreator is Nameble {

    /** Адрес конфигурации */
    address public addressSmartDataValidators;

    /** Список данных порожденных через данный смарт контракт */
    mapping(address => bool) public children;

    /** Событие о добавление новых данных */
    event LogAddData(address childrenAddress);

    /**
     * Конструктор
     * @param _addressSmartDataValidators TODO
     */
    function NeedCreator(address _addressSmartDataValidators) Nameble("NeedCreator", "1") public {
        addressSmartDataValidators = _addressSmartDataValidators;
    }

    /**
     * Добавить контракта потребности в блокчейн
     * @param _data потребность
     */
    function addData(string _data, address _to, uint256 _startTime, uint256 _endTime) public returns (bool)  {
        Need child = new Need(_data, msg.sender, _to, _startTime, _endTime);
        children[child] = true;
        emit LogAddData(child);
        return true;
    }
}
