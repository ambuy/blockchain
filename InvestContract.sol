pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";
import "./zeppelin/math/SafeMath.sol";
import "./AmbuyToken.sol";
import "./Nameble.sol";

/**
 * Смарт контракт который отвечает за выплату дивидендов.
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract InvestContract is Ownable, Nameble {
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
    address public addressAmbuyToken;
    address public addressAmbuyCoin;

    /**
     * Конструктор
     * @param _addressAmbuyToken адрес контракта токенов ambuy
     */
    function InvestContract(address _addressAmbuyToken, address _addressAmbuyCoin) Nameble("InvestContract", "1") public {
        addressAmbuyToken = _addressAmbuyToken;
        addressAmbuyCoin = _addressAmbuyCoin;
    }

    /**
     * Заблокировать токены для выплаты дивидендов
     * Метод вызывается только контрактом TODO
     * @param _count сколько
     */
    function lock(uint256 _count) public {
        AmbuyToken(addressAmbuyToken).transferFrom(msg.sender, address(this), _count);
        allLock = allLock.add(_count);
        lockToken[msg.sender] = lockToken[msg.sender].add(_count);
        lockTokenIndex[lockTokenCount] = msg.sender;
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
        AmbuyToken(addressAmbuyToken).transfer(msg.sender, _count);
    }

    function pay() public {}

}
