pragma solidity ^0.4.21;

import "./zeppelin/token/ERC20/StandardToken.sol";
import "./Config.sol";

/**
 * ERC20 токен который выпускается за добавление полезных данных в блокчейн
 * Полезность данных определяют валидаторы системы ambuy
 * Размер эмиссии определяется контрактом EmissionLogic
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract AmbuyCoin is StandardToken {
    using SafeMath for uint256;

    event Mint(address indexed to, uint256 amount);

    /** Название */
    string public constant name = "ambuy coin";
    /** Сокращенное название */
    string public constant symbol = "ABC";
    /** Количество символов после запятой */
    uint8 public constant decimals = 18;
    
    address public addressConfig;

    /**
     * Конструктор
     * @param _addressConfig адрес конфигурации
     */
    function AmbuyCoin(address _addressConfig) public {
        totalSupply_ = 0;
        addressConfig = _addressConfig;
    }

    /**
     * Эмиссия
     * Вызывать метод может только смарт контракт эмиссии определенный в конфигурации
     * @param _to    адрес куда выпускать токены
     * @param _count количество выпускаемых монет
     */
    function emission(address _to, uint256 _count) public {
        Config config = Config(addressConfig);
        // Вызывать метод может только смарт контракт эмиссии
        require(msg.sender == config.addressEmissionLogic());
        mint(_to, _count);
    }

    /**
     * Выпуск монет
     * @param _to    адрес куда выпускать токены
     * @param _count количество выпускаемых монет
     */
    function mint(address _to, uint256 _count) private returns (bool) {
        totalSupply_ = totalSupply_.add(_count);
        balances[_to] = balances[_to].add(_count);
        emit Mint(_to, _count);
        emit Transfer(address(0), _to, _count);
        return true;
    }
}
