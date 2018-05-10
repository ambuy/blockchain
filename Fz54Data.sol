pragma solidity ^0.4.21;

import "./zeppelin/math/SafeMath.sol";
import "./zeppelin/ownership/Ownable.sol";
import "./Config.sol";
import "./EmissionLogic.sol";
import "./Fz54Creator.sol";

/**
 * Контракт который описывает содержимое для чеков под 54ФЗ (Россия) и информацию о валидности данных
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract Fz54Data is Ownable {
    using SafeMath for uint256;

    event Validate();

    /** Информация из qr кода в чеке */
    string public qrInfo;
    /** Полный контент чека */
    string public checkInfo;
    /** Адрес владельца чека */
    address public adderAddress;
    /** Адреса валидаторов которые подтвердили данные */
    mapping(address => uint256) public confirmation;
    /** Сумма которую проставляет первый валидатор, когда данные валидны все валидаторы должны прислать одну и ту же сумму
        по ней происходит начисление ambuy coin'ов */
    uint256 public mainSum = 0;
    /** Количество голосов подтвердивших валидность данных */
    uint256 public voteCount = 0;

    /** Признак того что данные валидны */
    bool public valid;

    /**
     * Конструктор
     * @param _qrInfo       информация из qr кода
     * @param _checkInfo    информация из чека (контент)
     * @param _adderAddress адрес с которого добавили чек
     */
    function Fz54Data(string _qrInfo, string _checkInfo, address _adderAddress) public {
        qrInfo = _qrInfo;
        checkInfo = _checkInfo;
        adderAddress = _adderAddress;
    }

    /**
     * Валидация чека
     * @param sum сумма которую подтвердил валидатор
     */
    function validate(uint256 sum) public {
        // Если данные валидны ни чего не делаем
        if (valid) {
            return;
        }
        // Получаем конфигурацию - конфигурация записана в Fz54Creator в создателе данного контракта
        Config config = Config(Fz54Creator(owner).addressConfig());
        // Проверяем что вызывающий контракт, является одним из валидаторов
        if (config.validators(msg.sender)) {
             if (mainSum == 0) {
                 // Запоминаем итоговую сумму чека
                 mainSum = sum;
             }

             // Если сумма которую прислал валидатор, отличается от той которую прислали все остальные, чтне так такой голос не читываем
             if (mainSum == sum) {
                 // Добавляем один голос
                 voteCount = voteCount.add(1);
                 // Записываем голос валидатора в историю
                 confirmation[msg.sender] = sum;
                 // Если число голосов в контракте == числу которую необходимо набрать (указывается в конфиге) то:
                 if (config.validatorsCount() == voteCount) {
                     // Данные валиды
                     valid = true;
                     // Получаем адрес контракта емисси
                     EmissionLogic emissionLogic = EmissionLogic(config.addressEmissionLogic());
                     // Запускаем подсчет эмиссии
                     emissionLogic.calc(adderAddress, sum);
                     emit Validate();
                 }
             }
        }
    }
}