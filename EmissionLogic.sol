pragma solidity ^0.4.21;

import "./zeppelin/math/SafeMath.sol";
import "./zeppelin/ownership/Ownable.sol";
import "./Config.sol";
import "./AmbuyCoin.sol";
import "./Fz54Creator.sol";

/**
 * Контракт содержащий логику расчета эмисси ambuy coin
 * @author Ivanov D.V. (ivanovdw@gmail.com)
 *         Date: 25.04.2018
 */
contract EmissionLogic is Ownable {
    using SafeMath for uint256;

    /** Адрес конфигурации */
    address addressConfig;

    /**
     *  Конструктор
     *  @param _addressConfig адрес конфигурации
     */
    function EmissionLogic(address _addressConfig) public {
        addressConfig = _addressConfig;
    }

    /**
     * Рассчет выплаты за данные
     * @param _to    адрес кому вылачивать
     * @param _count сумма чека
     */
    function calc(address _to, uint256 _count) public {
        // Загружаем конфигурацию
        Config config = Config(addressConfig);
        // Вызывать метод может только контракт который прописан в конфигурации
        require(Fz54Creator(config.addressFz54DataCreator()).children(msg.sender));
        uint256 reward = _count.div(12500).div(70).mul(100).mul(1000000000000000000);
        // Сумма для adderAddress
        uint256 userPercent = reward.div(100).mul(70);
        // Сумма для разработчиков
        uint256 devPercent = reward.sub(userPercent);
        // Получаем контракт монеты AmbuyCoin
        AmbuyCoin amBuyCoinToken = AmbuyCoin(config.addressAmbuyCoin());
        amBuyCoinToken.emission(_to, userPercent);
        amBuyCoinToken.emission(config.addressInvestContract(), devPercent);
    }

    function calcUserAward(uint256 _count) public constant returns (uint256) {
        return _count.div(12500).div(70).mul(100).mul(1000000000000000000).div(100).mul(70);
    }
}
