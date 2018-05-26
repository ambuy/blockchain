pragma solidity ^0.4.21;

import "./zeppelin/math/SafeMath.sol";
import "./zeppelin/ownership/Ownable.sol";
import "./AmbuyConsensus.sol";
import "./AmbuyEmissionLogic.sol";
import "./Fz54Creator.sol";
import "./Fz54Validators.sol";

/**
 * Контракт который описывает содержимое для чеков под 54ФЗ (Россия) и информацию о валидности данных
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract ShoppingList is Ownable, Nameble {
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
    function ShoppingList(string _qrInfo, string _checkInfo, address _adderAddress) Nameble("ShoppingList", "1") public {
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
        // Получаем конфигурацию - конфигурация записана в Fz54Creator в создателе данного контракта TODO
        Fz54Validators fz54Validators = Fz54Validators(Fz54Creator(owner).addressFz54Validators());
        // Проверяем что вызывающий контракт, является одним из валидаторов
        if (fz54Validators.validators(msg.sender)) {
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
                 if (fz54Validators.validatorsCount() == voteCount) {
                     // Данные валиды
                     valid = true;
                     // Получаем адрес контракта емисси
                     address addressAmbuyEmissionLogic = AmbuyConsensus(Fz54Creator(owner).ambuyConsensusAddress()).addressAmbuyEmissionLogic();
                     AmbuyEmissionLogic ambuyEmissionLogic = AmbuyEmissionLogic(addressAmbuyEmissionLogic);
                     // Запускаем подсчет эмиссии
                     ambuyEmissionLogic.calc(adderAddress, sum);
                     emit Validate();
                 }
             }
        }
    }
}