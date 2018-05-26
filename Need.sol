pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";

import "./SmartDataValidators.sol";
import "./NeedCreator.sol";
import "./SmartData.sol";
import "./Nameble.sol";

/**
 *
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 18.05.2018
 */
contract Need is Ownable, Nameble, SmartData {

    function Need(string _data, address _from, address _to, uint256 _startTime, uint256 _endTime)
                Nameble("Need", "1")
                SmartData(_data, _from, _to, _startTime, _endTime) public {
    }

    function validate() {
        require(!valid);
        // Получаем конфигурацию - конфигурация записана в NeedCreator TODO в создателе данного контракта
        SmartDataValidators smartDataValidators = SmartDataValidators(NeedCreator(owner).addressSmartDataValidators());
        // Проверяем что вызывающий контракт, является одним из валидаторов
        require(smartDataValidators.validators(msg.sender));
        valid = true;
    }
}