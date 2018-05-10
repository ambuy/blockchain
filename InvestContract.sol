pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";
import "./zeppelin/math/SafeMath.sol";
import "./AmbuyToken.sol";

/**
 * Смарт контракт который отвечает за выплату дивидендов.
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract InvestContract is Ownable {
    using SafeMath for uint256;

    /** ключ - адрес, значение число токенов заблокированных для выплаты дивидендов */
    mapping(address => uint256) public lockToken;
    /** ключ - порядковый номер, значение - адрес инвестора */
    mapping (uint => address) private lockTokenIndex;
    /** Число инвесторов за все время */
    uint256 public lockTokenCount = 0;

    /** Количество заблокированных токенов */
    uint256 public allLock = 0;

    /** Адрес контракта токенов ambuy */
    address public addressAmbuyCoin;

    /**
     * Конструктор
     * @param _addressAmbuyCoin адрес контракта токенов ambuy
     */
    function InvestContract(address _addressAmbuyCoin) public {
        addressAmbuyCoin = _addressAmbuyCoin;
    }

    /**
     * Заблокировать токены для выплаты дивидендов
     * Метод вызывается только контрактом AmbuyCoin
     * @param _from  кто блокирует токены
     * @param _count сколько
     */
    function lock(address _from, uint256 _count) public {
        require(msg.sender == addressAmbuyCoin);
        allLock = allLock.add(_count);
        lockToken[_from] = lockToken[_from].add(_count);
        lockTokenIndex[lockTokenCount] = _from;
        lockTokenCount = lockTokenCount.add(1);
    }

    /**
     * Разблокировать токены для выплаты дивидендов
     * @param _count количество токенов которые необходимо разблокировать
     */
    function unlock(uint256 _count) public {
        uint256 balance = lockToken[msg.sender];
        require(balance >= _count);
        allLock = allLock.sub(_count);
        lockToken[msg.sender] = lockToken[msg.sender].sub(_count);
        AmbuyToken(addressAmbuyCoin).transfer(msg.sender, _count);
    }

    function pay() public {}

}
