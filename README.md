

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
### Sale table
![Sale](/Pics/Sale.png)
### Rent table
![Rent](/Pics/Rent.png)
### Diagram
![Diagram](/Pics/Diagram.png)
