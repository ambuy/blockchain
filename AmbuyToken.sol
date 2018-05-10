pragma solidity ^0.4.21;

import "./zeppelin/token/ERC20/StandardToken.sol";
import "./Config.sol";
import "./InvestContract.sol";

/**
 * ERC20 токен в блокчейне ambay владение которым обеспечивает выплату дивидендов в виде ambuy coin.
 * Максимальное число токенов которые может быть выпущенно данным смарт контрактом 100 000.
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract AmbuyToken is StandardToken {
    using SafeMath for uint256;

    event Mint(address indexed to, uint256 amount);

    /** Название */
    string public constant name = "AmBuy Invest Token";
    /** Сокращенное название */
    string public constant symbol = "ABIT";
    /** Количество символов после запятой */
    uint8 public constant decimals = 0;
    /** Максимальное количество токенов которое будет выпущено */
    uint256 public maxSupply = 100000;

    /** Адрес конфигурации */
    address public configAddress;

    /**
     * Конструктор
     * @param _configAddress адрес конфигурации
     */
    function AmbuyToken(address _configAddress) public {
        configAddress = _configAddress;
    }

    /**
     * Выпуск монет
     * Вызывать метод может только адрес который является мостом
     * @param _to    адрес на который нчислить токены
     * @param _count сколько токенов начислить
     */
    function emission(address _to, uint256 _count) public returns(bool) {
        require(Config(configAddress).investsBridge(msg.sender));
        require(maxSupply >= totalSupply_.add(_count));
        mint(_to, _count);
        return true;
    }

    /**
     * Заблокировать монеты для выплаты дивидендов
     * @param _count сколько токенов заблокировать
     */
    function invest(uint256 _count) public returns (bool) {
        uint256 balance = balanceOf(msg.sender);
        require(balance >= _count);
        address addressInvestContract = Config(configAddress).addressInvestContract();
        transfer(addressInvestContract, _count);
        InvestContract(addressInvestContract).lock(msg.sender, _count);
        return true;
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
