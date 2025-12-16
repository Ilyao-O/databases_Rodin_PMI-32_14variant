

# Database

Вариант 14. Фирма по аренде/продаже помещений.

Список объектов: адрес, характеристики (этаж, площадь, кол-во комнат, материал, ремонт, и т.д.), вид сделки (продажа, аренда), цена, владелец.
Информация о сделках (дата сделки, окончательная цена аренды в месяц/продажи, срок аренды).
Информация о владельцах, клиентах.

Реализовать:
- Поиск свободных помещений, пригодных для аренды.
- Поиск вариантов в соответствии с требованиями клиента;
- Необходимо предусмотреть получение разнообразной статистики:
средние сроки аренды
количество сделок аренды для каждого помещения
количество помещений для каждого владельца
доходы владельцев от аренды/продажи помещений за определенный срок

## Lab 1

### ER-model:
![ER-model](/Pics/ER_model.png)
### Relational model:
![REL-model](/Pics/REL_model.png)



## Lab 2
### SQL create tables:
```
Create table Client(
	ID INT PRIMARY KEY IDENTITY,
	Passport NVARCHAR(15) UNIQUE NOT NULL,
	Phone NVARCHAR(20) NOT NULL,
	FIO NVARCHAR(100) NOT NULL
);

Create table Proprietor(
	ID INT PRIMARY KEY IDENTITY,
	Passport NVARCHAR(15) UNIQUE NOT NULL,
	Phone NVARCHAR(20) NOT NULL,
	FIO NVARCHAR(100) NOT NULL
);

Create table Premise(
	ID INT PRIMARY KEY IDENTITY,
	Proprietor_id INT FOREIGN KEY REFERENCES Proprietor(ID),
	Area FLOAT NOT NULL CHECK(Area>0),
	[Number of Premises] INT NOT NULL CHECK([Number of Premises]>0),
	[Sale Price] INT CHECK([Sale Price]>=0),
	[Rental price] INT CHECK([Rental price] >=0),
	[Address] NVARCHAR(200) NOT NULL,
	[Floor] INT NOT NULL,
	LastRenovation  DATE NOT NULL,
	Material NVARCHAR(200) NOT NULL,
	[Status] BIT NOT NULL
);

Create table Sale(
	ID INT PRIMARY KEY IDENTITY,
	Proprietor_Id INT FOREIGN KEY REFERENCES Proprietor(ID),
	Client_Id INT FOREIGN KEY REFERENCES Client(ID),
	Premise_Id INT FOREIGN KEY REFERENCES Premise(ID),
	[Date of sale] DATE NOT NULL,
	[Final price] INT NOT NULL
);

Create table Rent(
	ID INT PRIMARY KEY IDENTITY,
	Proprietor_Id INT FOREIGN KEY REFERENCES Proprietor(ID),
	Client_Id INT FOREIGN KEY REFERENCES Client(ID),
	Premise_Id INT FOREIGN KEY REFERENCES Premise(ID),
	[Rental start date] DATE NOT NULL,
	[Rental end date] DATE NOT NULL,
	[Final price] INT NOT NULL
);
```
### Proprietor table
![Proprietor](/Pics/Proprietor.png)
### Client table
![Client](/Pics/Client.png)
### Premise table
![Premise](/Pics/Premise.png)
### Saletable
![Sale](/Pics/Sale.png)
### Rent table
![Rent](/Pics/Rent.png)
### Diagram
![Diagram](/Pics/Diagram.png)


## Lab 3
[Lab3](/Lab3[Родин_ПМИ32БО.docx])

## Lab 4
### Процедуры
a) Процедура без параметров, формирующая список объектов (адрес, владелец, арендатор, цена аренды), находящихся в данный момент в аренде
```
CREATE PROCEDURE CurrentRentals
AS
BEGIN
   
    SELECT 
        p.[Address] AS 'Адрес',
        pr.FIO AS 'Владелец',
        c.FIO AS 'Арендатор',
        p.[Rental price] AS 'Цена аренды (в месяц)'
    FROM Premise p
    JOIN Proprietor pr ON p.Proprietor_id = pr.ID
    JOIN Rent r ON p.ID = r.Premise_Id
    JOIN Client c ON r.Client_Id = c.ID
    WHERE r.[Rental end date] >= GETDATE() 
    AND r.[Rental start date] <= GETDATE()
END;
EXEC CurrentRentals;
```
![proc-a](/Lab4/proc_a.png)
b) Процедура, на входе получающая ФИО владельца и формирующая список объектов, выставленных им на продажу
```
CREATE PROCEDURE OwnerPropertiesForSale
    @OwnerFIO NVARCHAR(100)
AS
BEGIN
    SELECT 
        p.[Address] AS 'Адрес',
        p.[Sale Price] AS 'Цена продажи',
        p.Area AS 'Площадь',
        p.[Number of Premises] AS 'Количество помещений'
    FROM Premise p
    JOIN Proprietor pr ON p.Proprietor_id = pr.ID
    WHERE pr.FIO = @OwnerFIO 
    AND p.[Sale Price] > 0
END;

EXEC OwnerPropertiesForSale @OwnerFIO = 'Иванов Петр Сергеевич';
```
![proc-b](/Lab4/proc_a.png)

 c) Процедура, на входе получающая ФИО клиента, выходной параметр – количество сделок, где он участвует в качестве арендатора
```
CREATE PROCEDURE CountTenantDeals
    @ClientFIO NVARCHAR(100),
    @DealCount INT OUTPUT
AS
BEGIN
    SELECT @DealCount = COUNT(*)
    FROM Rent r
    JOIN Client c ON r.Client_Id = c.ID
    WHERE c.FIO = @ClientFIO;
END;

DECLARE @Count INT;
EXEC CountTenantDeals 
    @ClientFIO = 'Данилов Игорь Сергеевич', 
    @DealCount = @Count OUTPUT;
SELECT @Count AS 'Количество сделок аренды';
```
![proc-c](/Lab4/proc_c.png)

 d) Процедура, вызывающая вложенную процедуру, которая находит помещение, участвовавшее в договорах аренды наибольшее количество раз (если их несколько, берется любое). Вызывающая процедура выводит список всех арендаторов этого помещения за все время работы нашей фирмы
 
Вложенная процедура
```
CREATE PROCEDURE GetMostRentedPremiseId
    @MostRentedPremiseId INT OUTPUT
AS
BEGIN
    SELECT TOP 1 @MostRentedPremiseId = Premise_Id
    FROM Rent
    GROUP BY Premise_Id
    ORDER BY COUNT(*) DESC;
END;
```
Вызывающая процедура
```
CREATE PROCEDURE ShowAllTenantsOfMostRentedPremise
AS
BEGIN
    DECLARE @TargetPremiseId INT;
    
    EXEC GetMostRentedPremiseId @MostRentedPremiseId = @TargetPremiseId OUTPUT;

    SELECT DISTINCT
        c.FIO AS 'Арендатор',
        r.[Rental start date] AS 'Дата начала аренды',
        r.[Rental end date] AS 'Дата окончания аренды',
        r.[Final price] AS 'Стоимость аренды'
    FROM Rent r
    JOIN Client c ON r.Client_Id = c.ID
    JOIN Premise p ON r.Premise_Id = p.ID
    WHERE r.Premise_Id = @TargetPremiseId
    ORDER BY r.[Rental start date];
END;

EXEC ShowAllTenantsOfMostRentedPremise;
```
![proc-d](/Lab4/proc_d.png)

### Функции

a) Скалярная функция, которая по заданному адресу помещения возвращает ФИО его владельца
```
CREATE FUNCTION GetOwnerByAddress (@Address NVARCHAR(200))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @OwnerFIO NVARCHAR(100);
    
    SELECT @OwnerFIO = pr.FIO
    FROM Premise p
    JOIN Proprietor pr ON p.Proprietor_id = pr.ID
    WHERE p.[Address] = @Address;
    
    RETURN @OwnerFIO;
END;

SELECT dbo.GetOwnerByAddress('г. Москва, ул. Тверская, д. 10, кв. 25') AS 'Владелец';
SELECT dbo.GetOwnerByAddress('г. Москва, пр. Мира, д. 25, кв. 12') AS 'Владелец';
SELECT dbo.GetOwnerByAddress('г. Москва, ул. Ленинградская, д. 8, кв. 56') AS 'Владелец';
```
![funk-a](/Lab4/funk_a.png)

b) Inline-функция, возвращающая адреса помещений, проданных за наиболее низкую цену
```
CREATE FUNCTION GetCheapestSoldPremises ()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.[Address] AS 'Адрес',
        s.[Final price] AS 'Цена продажи',
        s.[Date of sale] AS 'Дата продажи',
        pr.FIO AS 'Продавец',
        c.FIO AS 'Покупатель'
    FROM Sale s
    JOIN Premise p ON s.Premise_Id = p.ID
    JOIN Proprietor pr ON s.Proprietor_Id = pr.ID
    JOIN Client c ON s.Client_Id = c.ID
    WHERE s.[Final price] = (
        SELECT MIN([Final price]) 
        FROM Sale
    )
);

SELECT * FROM dbo.GetCheapestSoldPremises();
```
![funk-b](/Lab4/funk_b.png)

c) Multi-statement-функция, выдающая список в виде: ФИО арендатора| ФИО владельца| адрес помещения для тех арендаторов и владельцев, которые заключали между собой договора 2 и более раз
```
CREATE FUNCTION GetFrequentPairs ()
RETURNS @ResultTable TABLE (
    tenant_fio NVARCHAR(100),
    owner_fio NVARCHAR(100),
    premise_address NVARCHAR(200),
    deal_count INT
)
AS
BEGIN
    INSERT INTO @ResultTable (tenant_fio, owner_fio, premise_address, deal_count)
    SELECT 
        c.FIO AS tenant_fio,
        pr.FIO AS owner_fio,
        p.[Address] AS premise_address,
        COUNT(*) AS deal_count
    FROM Rent r
    JOIN Client c ON r.Client_Id = c.ID
    JOIN Proprietor pr ON r.Proprietor_Id = pr.ID
    JOIN Premise p ON r.Premise_Id = p.ID
    GROUP BY c.FIO, pr.FIO, p.[Address]
    HAVING COUNT(*) >= 2
    ORDER BY deal_count DESC;
    RETURN;
END;

SELECT * FROM dbo.GetFrequentPairs();
```  
![funk-c](/Lab4/funk_c.png)

### Триггеры
a) Триггер любого типа на добавление помещения – если адрес добавляемого помещения совпадает с адресом уже имеющегося помещения, то такое добавление не производится
```  
CREATE TRIGGER tr_PreventDuplicateAddress
ON Premise
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @AddressToCheck NVARCHAR(200);
    DECLARE @DuplicateFound BIT = 0;
    DECLARE @ErrorMessage NVARCHAR(MAX) = '';
    
    DECLARE address_cursor CURSOR FOR
        SELECT DISTINCT [Address] 
        FROM inserted;
    
    OPEN address_cursor;
    FETCH NEXT FROM address_cursor INTO @AddressToCheck;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (SELECT 1 FROM Premise WHERE [Address] = @AddressToCheck)
        BEGIN
            SET @DuplicateFound = 1;
            SET @ErrorMessage = @ErrorMessage + 'Адрес "' + @AddressToCheck + '" уже существует. ';
        END
        
        FETCH NEXT FROM address_cursor INTO @AddressToCheck;
    END
    
    CLOSE address_cursor;
    DEALLOCATE address_cursor;
    
    IF @DuplicateFound = 1
    BEGIN
        THROW 50001, @ErrorMessage, 1;
        RETURN;
    END
    
    INSERT INTO Premise (
        Proprietor_id, Area, [Number of Premises], 
        [Sale Price], [Rental price], [Address], 
        [Floor], LastRenovation, Material, [Status]
    )
    SELECT 
        Proprietor_id, Area, [Number of Premises], 
        [Sale Price], [Rental price], [Address], 
        [Floor], LastRenovation, Material, [Status]
    FROM inserted;
END;

INSERT INTO Premise (Proprietor_Id, Area, [Number of Premises], [Sale Price], [Rental price], [Address], [Floor], LastRenovation, Material, [Status]) VALUES
(1, 45, 1, 8500000, 25000, N'г. Москва, ул. Тверская, д. 10, кв. 25', 5, '2023-01-15', N'Кирпич', 1);
```  
![trig-a](/Lab4/trig_a.png)

b) Последующий триггер на изменение вида сделки для помещения – если вид меняется с «аренда» на «продажа», и помещение находится на данный момент в аренде, то вид сделки не меняется, выводится соответствующее сообщение
```  
CREATE TRIGGER PreventRentToSaleChange
ON Sale
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (
        SELECT 1
        FROM inserted i  
        JOIN Rent r ON i.Premise_Id = r.Premise_Id
        WHERE r.[Rental end date] >= GETDATE()
    )
    BEGIN
        DECLARE @ErrorMessage NVARCHAR(500) = 'Невозможно сменить тип сделки на "продажа" для помещения, так как оно находится в аренде';
        ROLLBACK TRANSACTION;
        RAISERROR(@ErrorMessage, 16, 1);
    END
END;

INSERT INTO Sale(Proprietor_Id, Premise_Id, Client_Id, [Date of sale], [Final price]) VALUES
(1, 1, 1, '2024-10-09', 6500000);

```  
![trig-b](/Lab4/trig_b.png)
c) Замещающий триггер на операцию удаления владельца – если у этого владельца в данный момент какие-то помещения находятся в аренде, то мы его не удаляем, если нет, то удаляем и во всех прошлых сделках мы заменяем его на владельца, имеющего наименьшее количество сделок
```  
CREATE TRIGGER trg_Proprietor_Delete
ON Proprietor
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentDate DATE = GETDATE();
    DECLARE @SubstituteProprietorId INT;
    DECLARE @ProprietorId INT;
    DECLARE @HasActiveRent BIT = 0;
    DECLARE @AnyInvalid BIT = 0;

    IF NOT EXISTS (
        SELECT 1 
        FROM Proprietor 
        WHERE ID NOT IN (SELECT ID FROM deleted)
    )
    BEGIN
        RAISERROR(N'Ошибка: невозможно выполнить удаление — не останется владельцев для замены в прошлых сделках.', 16, 1);
        RETURN;
    END

    WITH ValidProprietors AS (
        SELECT ID 
        FROM Proprietor 
        WHERE ID NOT IN (SELECT ID FROM deleted)
    ),
    TransactionCounts AS (
        SELECT 
            vp.ID AS ProprietorId,
            COUNT(s.ID) + COUNT(r.ID) AS TotalDeals
        FROM ValidProprietors vp
        LEFT JOIN Sale s ON vp.ID = s.Proprietor_Id
        LEFT JOIN Rent r ON vp.ID = r.Proprietor_Id
        GROUP BY vp.ID
    )
    SELECT TOP 1 @SubstituteProprietorId = ProprietorId
    FROM TransactionCounts
    ORDER BY TotalDeals ASC, ProprietorId ASC;

    DECLARE prop_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT ID FROM deleted;
    
    OPEN prop_cursor;
    FETCH NEXT FROM prop_cursor INTO @ProprietorId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM Rent r
            JOIN Premise p ON r.Premise_Id = p.ID
            WHERE p.Proprietor_id = @ProprietorId
                AND @CurrentDate BETWEEN r.[Rental start date] AND r.[Rental end date]
        )
        BEGIN
            SET @AnyInvalid = 1;
            BREAK;
        END

        FETCH NEXT FROM prop_cursor INTO @ProprietorId;
    END

    CLOSE prop_cursor;
    DEALLOCATE prop_cursor;

    IF @AnyInvalid = 1
    BEGIN
        RAISERROR(N'Ошибка: операция удаления отменена. Некоторые владельцы имеют помещения в активной аренде.', 16, 1);
        RETURN;
    END

    UPDATE Sale
    SET Proprietor_Id = @SubstituteProprietorId
    WHERE Proprietor_Id IN (SELECT ID FROM deleted);

    UPDATE Rent
    SET Proprietor_Id = @SubstituteProprietorId
    WHERE Proprietor_Id IN (SELECT ID FROM deleted);

    DELETE Proprietor
    WHERE ID IN (SELECT ID FROM deleted);
END;


DELETE FROM Proprietor WHERE ID = 8;
```  
![trig-c](/Lab4/trig_c.png)