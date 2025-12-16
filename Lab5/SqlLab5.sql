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





INSERT INTO Proprietor (Passport, Phone, FIO) VALUES
(N'4501123456', N'+79161234567', N'Иванов Петр Сергеевич'),
(N'4501987654', N'+79169876543', N'Смирнова Ольга Владимировна'),
(N'4501234567', N'+79162345678', N'Козлов Александр Иванович'),
(N'4501765432', N'+79167654321', N'Петрова Мария Дмитриевна'),
(N'4501345678', N'+79163456789', N'Сидоров Дмитрий Алексеевич'),
(N'4501876543', N'+79168765432', N'Васильева Екатерина Сергеевна'),
(N'4501456789', N'+79164567890', N'Николаев Андрей Петрович'),
(N'4501567890', N'+79165678901', N'Федорова Ирина Викторовна'),
(N'4501678901', N'+79166789012', N'Алексеев Сергей Николаевич'),
(N'4501789012', N'+79167890123', N'Дмитриева Анна Александровна');

INSERT INTO Client(Passport, Phone, FIO) VALUES
(N'4511123456', N'+79261234567', N'Кузнецов Максим Игоревич'),
(N'4511987654', N'+79269876543', N'Орлова Татьяна Васильевна'),
(N'4511234567', N'+79262345678', N'Белов Артем Сергеевич'),
(N'4511765432', N'+79267654321', N'Григорьева Надежда Петровна'),
(N'4511345678', N'+79263456789', N'Тихонов Владимир Андреевич'),
(N'4511876543', N'+79268765432', N'Захарова Светлана Михайловна'),
(N'4511456789', N'+79264567890', N'Михайлов Павел Денисович'),
(N'4511567890', N'+79265678901', N'Романова Ольга Игоревна'),
(N'4511678901', N'+79266789012', N'Филиппов Алексей Владимирович'),
(N'4511789012', N'+79267890123', N'Семенова Юлия Александровна'),
(N'4511890123', N'+79268901234', N'Данилов Игорь Сергеевич'),
(N'4511901234', N'+79269012345', N'Титова Марина Викторовна'),
(N'4511012345', N'+79260123456', N'Герасимов Роман Олегович'),
(N'4511123457', N'+79261234568', N'Ларина Елена Дмитриевна'),
(N'4511234568', N'+79262345679', N'Савельев Константин Андреевич');


INSERT INTO Premise (Proprietor_Id, Area, [Number of Premises], [Sale Price], [Rental price], [Address], [Floor], LastRenovation, Material, [Status]) VALUES
(1, 45, 1, 8500000, 25000, N'г. Москва, ул. Тверская, д. 10, кв. 25', 5, '2023-01-15', N'Кирпич', 1),
(1, 75, 2, 12000000, 40000, N'г. Москва, ул. Тверская, д. 10, кв. 42', 8, '2022-11-20', N'Панель', 1),
(2, 35, 1, 6500000, 18000, N'г. Москва, пр. Мира, д. 25, кв. 12', 3, '2023-03-10', N'Кирпич', 1),
(3, 90, 3, 15000000, 55000, N'г. Москва, ул. Арбат, д. 15, кв. 78', 12, '2022-09-05', N'Монолит', 1),
(3, 60, 2, 9500000, 32000, N'г. Москва, ул. Арбат, д. 15, кв. 34', 7, '2023-02-28', N'Кирпич', 1),
(4, 48, 1, 7800000, 22000, N'г. Москва, ул. Ленинградская, д. 8, кв. 56', 2, '2023-04-15', N'Панель', 1),
(5, 110, 4, 18500000, 68000, N'г. Москва, ул. Садовая, д. 3, кв. 89', 15, '2022-12-10', N'Монолит', 1),
(6, 55, 2, 9200000, 28000, N'г. Москва, пр. Вернадского, д. 12, кв. 23', 6, '2023-01-30', N'Кирпич', 1),
(7, 68, 2, 10500000, 35000, N'г. Москва, ул. Профсоюзная, д. 18, кв. 45', 9, '2023-05-20', N'Панель', 1),
(8, 85, 3, 13500000, 48000, N'г. Москва, ул. Дмитровская, д. 7, кв. 67', 11, '2022-10-12', N'Монолит', 1),
(9, 40, 1, 7200000, 20000, N'г. Москва, ул. Севастопольская, д. 5, кв. 14', 4, '2023-06-05', N'Кирпич', 1),
(10, 95, 3, 14200000, 52000, N'г. Москва, ул. Рублевская, д. 22, кв. 81', 14, '2022-08-18', N'Монолит', 1);


INSERT INTO Rent (Client_Id, Proprietor_Id, Premise_Id, [Rental start date], [Rental end date], [Final price]) VALUES
(1, 1, 1, '2024-01-01', '2024-06-30', 24000),
(2, 2, 3, '2024-02-15', '2024-08-14', 17500),
(3, 3, 5, '2024-03-01', '2024-08-31', 31000),
(4, 4, 6, '2024-01-20', '2024-07-19', 21000),
(5, 5, 7, '2024-04-01', '2024-09-30', 65000),
(6, 6, 8, '2024-02-10', '2024-08-09', 27000),
(7, 7, 9, '2024-03-15', '2024-09-14', 34000),
(8, 8, 10, '2024-01-05', '2024-12-04', 47000),
(9, 9, 11, '2024-05-01', '2024-10-31', 19500),
(10, 10, 12, '2024-02-01', '2024-07-31', 51000);


INSERT INTO Sale(Proprietor_Id, Premise_Id, Client_Id, [Date of sale], [Final price]) VALUES
(1, 2, 11, '2024-01-10', 11800000),
(3, 4, 12, '2024-02-20', 14800000),
(5, 7, 13, '2024-03-15', 18200000),
(6, 8, 14, '2024-01-25', 9000000),
(7, 9, 15, '2024-04-05', 10300000),
(8, 10, 1, '2024-02-28', 13300000),
(9, 11, 2, '2024-03-10', 7100000),
(10, 12, 3, '2024-01-15', 14000000),
(4, 6, 4, '2024-05-01', 7700000),
(2, 3, 5, '2024-04-20', 6400000);


SELECT * FROM Client;
SELECT * FROM Proprietor;
SELECT * FROM Premise;
SELECT * FROM Sale;
SELECT * FROM Rent;


CREATE LOGIN User_Manager WITH PASSWORD = '1234567';
CREATE LOGIN User_Employee WITH PASSWORD = '1234567';

CREATE USER User_Manager FOR LOGIN User_Manager;
CREATE USER User_Employee FOR LOGIN User_Employee;


CREATE ROLE ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON Client TO ManagerRole WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON Proprietor TO ManagerRole WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON Premise TO ManagerRole WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON Sale TO ManagerRole WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON Rent TO ManagerRole WITH GRANT OPTION;

CREATE ROLE EmployeeRole;

GRANT SELECT ON Client TO EmployeeRole;
GRANT SELECT ON Proprietor TO EmployeeRole;
GRANT SELECT ON Premise TO EmployeeRole;
GRANT UPDATE ON Premise([Status]) TO EmployeeRole;
GRANT INSERT ON Sale TO EmployeeRole;
GRANT INSERT ON Rent TO EmployeeRole;


ALTER ROLE ManagerRole ADD MEMBER User_Manager;
ALTER ROLE EmployeeRole ADD MEMBER User_Employee;

SELECT USER_NAME() AS [Пользователь БД];

EXECUTE AS USER = 'User_Manager';

SELECT TOP 2 * FROM Client;
SELECT TOP 2 * FROM Proprietor;
SELECT TOP 2 * FROM Premise;
SELECT TOP 2 * FROM Sale;
SELECT TOP 2 * FROM Rent;

INSERT INTO Client (Passport, Phone, FIO) 
VALUES (N'4512000000', N'+79260000000', N'Тестовый Клиент Руководителя');

UPDATE Client SET Phone = N'+79261111111' WHERE Passport = N'4512000000';

DELETE FROM Client WHERE Passport = N'4512000000';

REVERT;



EXECUTE AS USER = 'User_Employee';

SELECT TOP 2 * FROM Client;
SELECT TOP 2 * FROM Proprietor;
SELECT TOP 2 * FROM Premise;

UPDATE Premise SET [Status] = 0 WHERE ID = 1;

INSERT INTO Sale (Proprietor_Id, Premise_Id, Client_Id, [Date of sale], [Final price])
VALUES (1, 1, 1, GETDATE(), 10000000);

DELETE FROM Client WHERE ID = 1;

UPDATE Premise SET [Sale Price] = 9000000 WHERE ID = 1;

REVERT;

DELETE FROM Sale WHERE [Final price] = 10000000;
UPDATE Premise SET [Status] = 1 WHERE ID = 1;

GO;

CREATE PROCEDURE GetSalesInfo
AS
SELECT 
    c.FIO AS Клиент,
    p.[Address] AS Адрес,
    s.[Date of sale] AS [Дата продажи],
    s.[Final price] AS Цена
FROM Sale s
JOIN Client c ON s.Client_Id = c.ID
JOIN Premise p ON s.Premise_Id = p.ID;


GO;
CREATE PROCEDURE UpdatePrice
    @PremiseId INT,
    @NewPrice INT
AS
UPDATE Premise SET [Sale Price] = @NewPrice WHERE ID = @PremiseId;

GRANT EXECUTE ON GetSalesInfo TO ManagerRole, EmployeeRole;
GRANT EXECUTE ON UpdatePrice TO ManagerRole;



EXECUTE AS USER = 'User_Employee';

EXEC GetSalesInfo;

EXEC UpdatePrice @PremiseId = 1, @NewPrice = 9000000;

REVERT;

GO;

EXECUTE AS USER = 'User_Manager';

EXEC GetSalesInfo;

EXEC UpdatePrice @PremiseId = 1, @NewPrice = 8000000;

REVERT;

DROP PROCEDURE GetSalesInfo;
DROP PROCEDURE UpdatePrice;



------------------------------------------------------------------------------------------------------------------
--МАСКИРОВАНИЕ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
ALTER TABLE Client
ALTER COLUMN Phone ADD MASKED WITH (FUNCTION = 'partial(3,"-XXX-XX-",4)');

ALTER TABLE Proprietor
ALTER COLUMN Phone ADD MASKED WITH (FUNCTION = 'partial(3,"-XXX-XX-",4)');

ALTER TABLE Client
ALTER COLUMN Passport ADD MASKED WITH (FUNCTION = 'default()');

ALTER TABLE Proprietor
ALTER COLUMN Passport ADD MASKED WITH (FUNCTION = 'partial(2,"******",2)');

GRANT UNMASK ON Client TO ManagerRole;
GRANT UNMASK ON Proprietor TO ManagerRole;

REVOKE UNMASK ON Client FROM EmployeeRole;
REVOKE UNMASK ON Proprietor FROM EmployeeRole;

EXECUTE AS USER = 'User_Manager';
SELECT TOP 3 * FROM Client;
SELECT TOP 3 * FROM Proprietor;
SELECT TOP 3 * FROM Premise;
REVERT;


EXECUTE AS USER = 'User_Employee';
SELECT TOP 3 * FROM Client; 
SELECT TOP 3 * FROM Proprietor;
REVERT;


SELECT USER_NAME() AS [Пользователь БД];

GO


GRANT UNMASK ON Client TO EmployeeRole;
GRANT UNMASK ON Proprietor TO EmployeeRole;


CREATE VIEW Client_Safe AS
SELECT 
    ID,
    LEFT(FIO, CHARINDEX(' ', FIO)) + ' ' + SUBSTRING(FIO, CHARINDEX(' ', FIO) + 1, 1) + '.' + SUBSTRING(FIO, CHARINDEX(' ', FIO, CHARINDEX(' ', FIO) + 1) + 1, 1) + '.' AS FIO,
    '+7***' + RIGHT(Phone, 4) AS Phone,
    LEFT(Passport, 3) + '****' AS Passport
FROM Client;

GO

CREATE VIEW Proprietor_Safe AS
SELECT 
    ID,
    LEFT(FIO, CHARINDEX(' ', FIO)) + ' ' + 
    LEFT(SUBSTRING(FIO, CHARINDEX(' ', FIO) + 1, 1), 1) + '.' AS FIO,
    '+7***' + RIGHT(Phone, 4) AS Phone,
    LEFT(Passport, 4) + '***' AS Passport
FROM Proprietor;

REVOKE SELECT ON Client FROM EmployeeRole;
REVOKE SELECT ON Proprietor FROM EmployeeRole;

GRANT SELECT ON Client_Safe TO EmployeeRole;
GRANT SELECT ON Proprietor_Safe TO EmployeeRole;

GRANT SELECT ON Client_Safe TO ManagerRole;
GRANT SELECT ON Proprietor_Safe TO ManagerRole;

EXECUTE AS USER = 'User_Employee';
SELECT * FROM Client_Safe;
SELECT * FROM Proprietor_Safe;
REVERT;

EXECUTE AS USER = 'User_Manager';
SELECT * FROM Client_Safe;
REVERT;