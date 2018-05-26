pragma solidity ^0.4.21;

import "./zeppelin/math/SafeMath.sol";
import "./zeppelin/ownership/Ownable.sol";
import "./AmbuyConsensus.sol";
import "./AmbuyCoin.sol";
import "./Fz54Creator.sol";
import "./Nameble.sol";

/**
 * Контракт содержащий логику расчета эмисси ambuy coin
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract AmbuyEmissionLogic is Ownable, Nameble {
    using SafeMath for uint256;

    /** TODO */
    address ambuyConsensusAddress;

    /**
     *  Конструктор
     *  @param _ambuyConsensusAddress адрес конфигурации
     */
    function AmbuyEmissionLogic(address _ambuyConsensusAddress) Nameble("AmbuyEmissionLogic", "1") public {
        ambuyConsensusAddress = _ambuyConsensusAddress;
    }

    /**
     * Рассчет выплаты за данные
     * @param _to    адрес кому вылачивать
     * @param _count сумма чека
     */
    function calc(address _to, uint256 _count) public {
        // Загружаем конфигурацию
        AmbuyConsensus ambuyConsensus = AmbuyConsensus(ambuyConsensusAddress);
        // Вызывать метод может только контракт который прописан в конфигурации
        require(Fz54Creator(ambuyConsensus.addressFz54DataCreator()).children(msg.sender));
        // Сумма для adderAddress
        uint256 award = calcAward(_count);
        uint256 userAward = calcUserAward(award);
        // Сумма для разработчиков
        uint256 investAward = calcInvestAward(award, userAward);
        // Получаем контракт монеты AmbuyCoin
        AmbuyCoin amBuyCoinToken = AmbuyCoin(ambuyConsensus.addressAmbuyCoin());
        amBuyCoinToken.emission(_to, userAward);
        amBuyCoinToken.emission(ambuyConsensus.addressInvestContract(), investAward);
    }

    function calcAward(uint256 _count) public constant returns (uint256) {
        return _count.mul(1000000000000000000).div(125).div(70);
    }

    function calcUserAward(uint256 _count) public constant returns (uint256) {
        return _count.div(100).mul(70);
    }

    function calcInvestAward(uint256 _count, uint256 _userAward) public constant returns (uint256) {
        return _count.sub(_userAward);
    }
}