Config.sol
-------------
Смарт контракт который представляет конфигуратор системы ambuy.
Содержит в себе адреса других смарт контрактов системы ambuy и адреса валидаторов

AmbuyCoin.sol
-------------
ERC20 токен который выпускается за добавление полезных данных в блокчейн
Полезность данных определяют валидаторы системы ambuy
Размер эмиссии определяется контрактом EmissionLogic

AmbuyToken.sol
-------------
ERC20 токен в блокчейне ambay владение которым обеспечивает выплату дивидендов в виде ambuy coin.
Максимальное число токенов которые может быть выпущенно данным смарт контрактом 100 000.

InvestContract.sol
-------------
Смарт контракт который отвечает за выплату дивидендов.

Fz54Creator.sol
-------------
Смарт контракт с помощью которого пользователь добавляет данные соответствующие 54ФЗ
При добавление данных в блокчейне создается смарт контракт Fz54Data

Fz54Data.sol
-------------
Смарт контракт представляющий из себя данные из qr кода чека, контент чека (информация о покупках)
Содержит в себе метод validate вызвыть который могут только валидатор в системе ambuy тем самым подтвердить что данные являются корректными.
Если все валидаторы в системе ambuy подтвердят валидность, запустится процесс эмиссии ambuy coin

EmissionLogic.sol
-------------
Смарт контракт который содержит вычислительную логику по выпуску токенов.
70% ambuy coin начисляется пользователю добавившему данные
30% ambuy coin начисляется инвесторам

Диаграмма связей
-------------
![Диаграмма связей](https://github.com/ambuy/blockchain/blob/master/diagramm/link.png)

Процесс эмиссии
-------------
![Процесс эмиссии](https://github.com/ambuy/blockchain/blob/master/diagramm/emission.png)
1. Пользователь помещает данные в блокчей вызовом метода addData у смарт контракта Fz54DataCreator
2. Fz54DataCreator порождает смарт контракт Fz54Data содержащие данные пользователя
3. Валидаторы проверяют данные на их полезность и признают их валидность путем вызова метода validate у смарт контракта Fz54Data
4. Когда данные признаются валидными происходит Fz54Data вызывает рассчет эмиссии у контракта EmissionLogic
5. EmissionLogic рассчитывает количество выпускаемых монет, 70% эмиссии идет пользователю, 30% монет начисляется на контракт InvestContract и дает команду контракту AmbuyCoin выпустить монеты
6. AmbuyCoin производит начисление монет

Схема инвестиций
-------------
![Схема инвестиций](https://github.com/ambuy/blockchain/blob/master/diagramm/bridge.png)
1. Инвестор присылает ETH на смарт контрак в системе ethereum
2. Мост представляющий из себя внешний софт, производит проверку количества монет на смарт контраке в ethereum
3. Мост осуществляет начисление соответсвующего количества ambuy token путем вызова метода emission у контракта Ambuy Token
