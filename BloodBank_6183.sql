------------------------------------------------------------------------
------- Baza Danych - Bank Krwi ----------------
------- Autor - Sebastian Błaszczyk ------------
------- Semestr 4 Grupa A ----------------------
------- Nr. Indeksu - 6183 ---------------------
------------------------------------------------------------------------





-- Tworzenie bazy danych

set nocount on;
set ansi_nulls on;
set ansi_warnings on;
set xact_abort on;

USE master
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'BloodBank')
	DROP DATABASE [BloodBank]
GO

CREATE DATABASE [BloodBank]
GO

USE BloodBank
GO

-- Tworzenie Tabel wraz z kolumnami


CREATE TABLE [dbo].[Pacjent] (
	[Imie] [char] (20) COLLATE Polish_CI_AS NOT NULL ,
	[Nazwisko] [char] (30) COLLATE Polish_CI_AS NOT NULL ,
	[Pesel] [char] (11) COLLATE Polish_CI_AS NOT NULL ,
	[Ilosc] [int] NOT NULL,
	[GrKrwi] [char] (10) NOT NULL,
	[Miejscowosc] [char] (30) COLLATE Polish_CI_AS NOT NULL,
	[Telefon] [char] (25) COLLATE Polish_CI_AS NULL,
	[Wiek] [tinyint] NOT NULL,
	[NrPacjenta] [int] NOT NULL,
	[DataZapisu] [date] NOT NULL,
	[IdOddzialu] [int] NOT NULL
	) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Dawca] (
	[Imie] [char] (20) COLLATE Polish_CI_AS NOT NULL ,
	[Nazwisko] [char] (30) COLLATE Polish_CI_AS NOT NULL ,
	[Pesel] [char] (11) COLLATE Polish_CI_AS NOT NULL ,
	[Ilosc] [int] NOT NULL, 
	[GrKrwi] [char] (10) NOT NULL,
	[Miejscowosc] [char] (30) COLLATE Polish_CI_AS NOT NULL,
	[Telefon] [char] (25) COLLATE Polish_CI_AS NULL,
	[Wiek] [tinyint] NOT NULL,
	[IdOddzialu] [int] NOT NULL,
	[KodDawcy] [int] NOT NULL
	) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Oddzial] (
	[Nazwa] [char] (50) COLLATE Polish_CI_AS NOT NULL ,
	[IdOddzialu] [int] NOT NULL,
	[Miejscowosc] [char] (50) COLLATE Polish_CI_AS NOT NULL,
	[Telefon] [char] (25) NOT NULL,
	[Email] [char] (50) NULL,
	)ON [PRIMARY]
GO
CREATE TABLE [dbo].[Zabieg] (
	[Nazwa] [char] (30) COLLATE Polish_CI_AS NOT NULL,
	[IdZabiegu] [int] NOT NULL,
	[TerminZabiegu] [datetime] NOT NULL,
	[TypZabiegu] [char] (128)COLLATE Polish_CI_AS NULL,
	[IdWykonawcy] [int] not null
	)ON [PRIMARY]
GO
CREATE TABLE [dbo].[Zapis] (
	[IdZapisu] [int] NOT NULL,
	[IdZabiegu] [int] NOT NULL,
	[NrPacjenta] [int] NOT NULL
	)ON [PRIMARY]
GO
CREATE TABLE [dbo].[Pracownik] (
	[IdPracownika] [int] NOT NULL,
	[Imie] [char] (20) COLLATE Polish_CI_AS NOT NULL,
	[Nazwisko] [char] (25) COLLATE Polish_CI_AS NOT NULL,
	[Pesel] [char] (11) COLLATE Polish_CI_AS NOT NULL,
	[Miejscowosc] [char] (25)COLLATE Polish_CI_AS NOT NULL,
	[Adres] [char] (25)COLLATE Polish_CI_AS NULL,
	[IdOddzialu] [int] NOT NULL,
	[TypZatrudnienia] [char] (25) COLLATE Polish_CI_AS NOT NULL,
	[IdWynagrodzenia] [int] NOT NULL,
	[Stanowisko] [char] (30) COLLATE Polish_CI_AS NOT NULL,
	[Email] [char] (30) COLLATE Polish_CI_AS NULL,
	[Telefon] [char] (30) NULL,
	[IdZmiany] [int] NOT NULL
	)ON [PRIMARY]
GO
CREATE TABLE [dbo].[WykonawcaZabieg] (
	[IdPracownika] [int] NOT NULL,
	[IdWykonawcy] [int] NOT NULL
	) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Dostawa] (
	[Nazwa] [char] (25) COLLATE Polish_CI_AS NOT NULL,
	[GrKrwi] [char] (25) COLLATE Polish_CI_AS NOT NULL,
	[Termin] [datetime] NOT NULL,
	[IdDostawy] [int] NOT NULL,
	[IdOdbiorcy] [int] NOT NULL,
	[Ilosc] [smallint] NOT NULL,
	[Uwagi] [char] (128) COLLATE Polish_CI_AS NULL,
	)ON [PRIMARY]
GO
CREATE TABLE [dbo].[Oplaty] (
	[Rodzaj] [char] (25) COLLATE Polish_CI_AS NOT NULL,
	[IdRachunku] [int] NOT NULL,
	[IdOplaty] [int] NOT NULL
	) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Rachunki] (
	[Nazwa] [char] (25) COLLATE Polish_CI_AS NOT NULL,
	[IdRachunku] [int] NOT NULL,
	[TypRachunku] [char] (25) COLLATE Polish_CI_AS NULL,
	[KwotaRachunku] [smallmoney] NOT NULL,
	[NrKonta] [char] (50) NULL
	) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Zmiany] (
	[TypZmiany] [char] (25) COLLATE Polish_CI_AS NOT NULL,
	[GodzinyZmiany] [char] (35) NOT NULL,
	[IdZmiany] [int] NOT NULL
	) ON [PRIMARY]
GO
	
CREATE TABLE [dbo].[Wynagrodzenie] (
	[Nazwa] [char] (25) COLLATE Polish_CI_AS NOT NULL,
	[IdRachunku] [int] NOT NULL,
	[IdWynagrodzenia] [int] NOT NULL,
	[IdPracownika] [int] NOT NULL
	) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Bank] (
	[GrKrwi] [char] (25) NOT NULL,
	[Ilosc] [int] NOT NULL
) ON [PRIMARY]
GO


	
	

	
---- Procedury przechowywania danych w tabelach ----

---- Pacjent ----

CREATE PROC Pacjent_wstaw
@Imie char(20),
@Nazwisko char(30),
@Pesel char(11),
@Ilosc int,
@GrKrwi char(10),
@Miejscowosc char(30),
@Telefon char(25),
@Wiek tinyint,
@NrPacjenta int,
@DataZapisu datetime,
@IdOddzialu int
AS
INSERT Pacjent (Imie,Nazwisko,Pesel,Ilosc,GrKrwi,Miejscowosc,Telefon,Wiek,NrPacjenta,DataZapisu,IdOddzialu)
VALUES (@Imie,@Nazwisko,@Pesel,@Ilosc,@GrKrwi,@Miejscowosc,@Telefon,@Wiek,@NrPacjenta,@DataZapisu,@IdOddzialu)
GO

---- Dawca ----

CREATE PROCEDURE Dawca_wstaw
@Imie char(20),
@Nazwisko char(30),
@Pesel char (11),
@Ilosc int,
@GrKrwi char(10),
@Miejscowosc char(30),
@Telefon char(25),
@Wiek tinyint,
@IdOddzialu int,
@KodDawcy int
AS
INSERT Dawca (Imie,Nazwisko,Pesel,Ilosc,GrKrwi,Miejscowosc,Telefon,Wiek,IdOddzialu,KodDawcy)
Values (@Imie,@Nazwisko,@Pesel,@Ilosc,@GrKrwi,@Miejscowosc,@Telefon,@Wiek,@IdOddzialu,@KodDawcy)
GO

---- Oddzial ----

CREATE PROCEDURE Oddzial_wstaw
@Nazwa char(50),
@IdOddzialu int,
@Miejscowosc char(50),
@Telefon char(25),
@Email char(50)
AS
INSERT Oddzial (Nazwa,IdOddzialu,Miejscowosc,Telefon,Email)
VALUES(@Nazwa,@IdOddzialu,@Miejscowosc,@Telefon,@Email)
GO

---- Zabieg ----

CREATE PROCEDURE Zabieg_wstaw
@Nazwa char(70),
@IdZabiegu int,
@TerminZabiegu datetime,
@TypZabiegu char(128),
@IdWykonawcy int
AS
INSERT Zabieg (Nazwa,IdZabiegu,TerminZabiegu,TypZabiegu,IdWykonawcy)
VALUES (@Nazwa,@IdZabiegu,@TerminZabiegu,@TypZabiegu,@IdWykonawcy)
GO

---- Pracownik ----

CREATE PROCEDURE Pracownik_wstaw
@IdPracownika int,
@Imie char(20),
@Nazwisko char(25),
@Pesel char(11),
@Miejscowosc char(25),
@Adres char(25),
@IdOddzialu int,
@TypZatrudnienia char(25),
@IdWynagrodzenia int,
@Stanowisko char(30),
@Email char(30),
@Telefon char(30),
@IdZmiany int
AS
INSERT Pracownik (IdPracownika,Imie,Nazwisko,Pesel,Miejscowosc,Adres,IdOddzialu,TypZatrudnienia,IdWynagrodzenia,Stanowisko,Email,Telefon,IdZmiany)
VALUES (@IdPracownika,@Imie,@Nazwisko,@Pesel,@Miejscowosc,@Adres,@IdOddzialu,@TypZatrudnienia,@IdWynagrodzenia,@Stanowisko,@Email,@Telefon,@IdZmiany)
GO

----  WykonawcaZabieg ----

CREATE PROCEDURE WykonawcaZabieg_wstaw
@IdPracownika int,
@IdWykonawcy int
AS
INSERT WykonawcaZabieg (IdPracownika,IdWykonawcy)
VALUES (@IdPracownika,@IdWykonawcy)
GO

---- Dostawa ----

CREATE PROCEDURE Dostawa_wstaw
@Nazwa char(25),
@GrKrwi char(25),
@Termin datetime,
@IdDostawy int,
@IdOdbiorcy int,
@Ilosc smallint,
@Uwagi char(128)
AS
INSERT Dostawa (Nazwa,GrKrwi,Termin,IdDostawy,IdOdbiorcy,Ilosc,Uwagi)
VALUES (@Nazwa,@GrKrwi,@Termin,@IdDostawy,@IdOdbiorcy,@Ilosc,@Uwagi)
GO

---- Oplaty ----

CREATE PROCEDURE Oplaty_wstaw
@Rodzaj char(25),
@IdRachunku int,
@IdOplaty int
AS
INSERT Oplaty (Rodzaj,IdRachunku,IdOplaty)
VALUES (@Rodzaj,@IdRachunku,@IdOplaty)
GO

---- Rachunki ----

CREATE PROCEDURE Rachunki_wstaw
@Nazwa char(25),
@IdRachunku int,
@TypRachunku char(25),
@KwotaRachunku smallmoney,
@NrKonta char(50)
AS
INSERT Rachunki (Nazwa,IdRachunku,TypRachunku,KwotaRachunku,NrKonta)
VALUES (@Nazwa,@IdRachunku,@TypRachunku,@KwotaRachunku,@NrKonta)
GO

---- Zmiany ----

CREATE PROCEDURE Zmiany_wstaw
@TypZmiany char(35),
@GodzinyZmiany char(35),
@IdZmiany int
AS
INSERT Zmiany (TypZmiany,GodzinyZmiany,IdZmiany)
VALUES (@TypZmiany,@GodzinyZmiany,@IdZmiany)
GO

---- Wynagrodzenie ----

CREATE PROCEDURE Wynagrodzenie_wstaw
@Nazwa char(25),
@IdRachunku int,
@IdWynagrodzenia int,
@IdPracownika int
AS
INSERT Wynagrodzenie (Nazwa,IdRachunku,IdWynagrodzenia,IdPracownika)
VALUES (@Nazwa,@IdRachunku,@IdWynagrodzenia,@IdPracownika)
GO

---- Zapis ----

CREATE PROCEDURE Zapis_wstaw
@IdZapisu int,
@IdZabiegu int,
@NrPacjenta int
AS
INSERT Zapis (IdZapisu,IdZabiegu,NrPacjenta)
VALUES (@IdZapisu,@IdZabiegu,@NrPacjenta)
GO

---- Bank ----

CREATE PROCEDURE Bank_wstaw
@GrKrwi char(25),
@Ilosc int
AS
INSERT Bank (GrKrwi,Ilosc)
VALUES (@GrKrwi,@Ilosc)
GO

--- Wykorzystanie skryptu dodającego dane do poszczególnych tabel ---
----------------------------------------------------------------------


---  Pacjent ---

SET DATEFORMAT YMD
GO

EXEC Pacjent_wstaw 'Sebastian','Blaszczyk','96112507793',5,'A+','Wroclaw','790531281','42',1,'2018-12-10',2
EXEC Pacjent_wstaw 'Marcin','Nowak','99111207793',3,'AB','Warszawa','33333333','31',2,'2013-11-12',1
EXEC Pacjent_wstaw 'Kamil','Kowal','91122007793',4,'B','Legnica','22222222','42',3,'2011-12-23',1
EXEC Pacjent_wstaw 'Tomek','Tysz','95011307793',3,'0','Gdynia','11111111','12',4,'2012-12-24',3

GO

--- Dawca ---

EXEC Dawca_wstaw 'Mateusz','Micha','123456789123',2,'B','Walbrzych','321321321','33',2,1
EXEC Dawca_wstaw 'Grzegorz','Radny','123456789123',2,'B','Gdyani','452452452','33',3,2
EXEC Dawca_wstaw 'Maciej','Kety','123456789123',2,'A','Wroclaw','931931931','33',1,3
GO

--- Oddzial ---

EXEC Oddzial_wstaw 'Sw. Tomasza',2,'Wroclaw','531281732','oddzialtomasza@email.pl'
EXEC Oddzial_wstaw 'Sw. Marcina',3,'Legnica','331342512','oddzialmarcina@email.pl'
EXEC Oddzial_wstaw 'Sw. Piotra',1,'Krakow','345678136','oddzialpiotra@email.pl'
GO

--- Zabieg ---

EXEC Zabieg_wstaw 'Bank Krwi',1,'2018-01-24','Bank',1
EXEC Zabieg_wstaw 'Bank Krwi',2,'2018-02-21','Dawca',2
EXEC Zabieg_wstaw 'Bank Krwi',3,'2018-03-20','Bank',3
GO

--- Zapis ---

EXEC Zapis_wstaw 1,2,1
EXEC Zapis_wstaw 2,3,3
EXEC Zapis_wstaw 3,2,2
GO

--- Pracownik ---

EXEC Pracownik_wstaw 1,'Gabriel','Blaszczyk','12343290812','Wroclaw','ul.Nudna 11',3,'Stale',2,'Doktor',NULL,NULL,1
EXEC Pracownik_wstaw 2,'Michal','Silny','00234567122','Wroclaw','ul.Piekna 44',2,'Tymczasowe',2,'Asystent',NULL,NULL,1
EXEC Pracownik_wstaw 3,'Amadeusz','Szybki','56423542189','Warszawa','ul.Kreta 2',2,'Stale',2,'Asystent',NULL,NULL,2
EXEC Pracownik_wstaw 4,'Wojtek','Wielki','031442113282','Warszawa','ul.Ruska 1',1,'Tymczasowe',1,'Doktor',NULL,NULL,3
GO

--- WykonawcaZabieg ---

EXEC WykonawcaZabieg_wstaw 1,1
EXEC WykonawcaZabieg_wstaw 2,2
EXEC WykonawcaZabieg_wstaw 3,3
GO

--- Dostawa ---

EXEC Dostawa_wstaw 'Dostawa GrA','A','2018-12-22',1,1,25,NULL
EXEC Dostawa_wstaw 'Dostawa GrB','B','2018-11-11',2,3,15,'Niekompletna dostawa'
GO

--- Oplaty ---

EXEC Oplaty_wstaw 'Czynsz',1,1
EXEC Oplaty_wstaw 'Pensja',2,2
EXEC Oplaty_wstaw 'Premia',3,3

GO

--- Rachunki ---

EXEC Rachunki_wstaw 'Rachunek',1,'Okresowy',3500,NULL
EXEC Rachunki_wstaw 'Rachunek',2,'Okresowy',2500,NULL
EXEC Rachunki_wstaw 'Premia',3,'Premia',500,NULL

GO

--- Zmiany ---

EXEC Zmiany_wstaw 'Pierwsza','06.00-14.00',1
EXEC Zmiany_wstaw 'Druga','14.00-22.00',2
EXEC Zmiany_wstaw 'Nocna','22.00-06-00',3
GO

--- Wynagrodzenie ---

EXEC Wynagrodzenie_wstaw 'Premia',3,1,1
EXEC Wynagrodzenie_wstaw 'Pensja',2,2,2
GO

--- Bank ---

EXEC Bank_wstaw 'A',50
EXEC Bank_wstaw 'B',200
EXEC Bank_wstaw 'A+',20
EXEC Bank_wstaw '0',15
EXEC Bank_wstaw 'AB',40
GO

---- Primary Keys ----
----------------------

--- Pacjent ---

ALTER TABLE [dbo].[Pacjent] WITH NOCHECK ADD
	CONSTRAINT [PK_Pacjent] PRIMARY KEY CLUSTERED
	(
	
	[NrPacjenta]
	
	) ON [PRIMARY]
GO

--- Dawca ---

ALTER TABLE [dbo].[Dawca] WITH NOCHECK ADD
	CONSTRAINT [PK_Dawca] PRIMARY KEY CLUSTERED
	(
	
	[KodDawcy]
	
	) ON [PRIMARY]
GO

--- Oddzial ---

ALTER TABLE [dbo].[Oddzial] WITH NOCHECK ADD
	CONSTRAINT [PK_Oddzial] PRIMARY KEY CLUSTERED
	(
	
	[IdOddzialu]
	
	) ON [PRIMARY]
GO

--- Zabieg ---

ALTER TABLE [dbo].[Zabieg] WITH NOCHECK ADD
	CONSTRAINT [PK_Zabieg] PRIMARY KEY CLUSTERED
	(
	
	[IdZabiegu]
	
	) ON [PRIMARY]
GO

--- Zapis ---

ALTER TABLE [dbo].[Zapis] WITH NOCHECK ADD
	CONSTRAINT [PK_Zapis] PRIMARY KEY CLUSTERED
	(
	
	[IdZapisu]
	
	) ON [PRIMARY]
GO

--- Pracownik ---

ALTER TABLE [dbo].[Pracownik] WITH NOCHECK ADD
	CONSTRAINT [PK_Pracownik] PRIMARY KEY CLUSTERED
	(
	
	[IdPracownika]
	
	) ON [PRIMARY]
GO

--- WykonawcaZabieg ---

ALTER TABLE [dbo].[WykonawcaZabieg] WITH NOCHECK ADD
	CONSTRAINT [PK_WykonawcaZabieg] PRIMARY KEY CLUSTERED
	(
	
	[IdWykonawcy]
	
	) ON [PRIMARY]
GO

--- Dostawa ---

ALTER TABLE [dbo].[Dostawa] WITH NOCHECK ADD
	CONSTRAINT [PK_Dostawa] PRIMARY KEY CLUSTERED
	(
	
	[IdDostawy]
	
	) ON [PRIMARY]
GO

--- Oplaty ---

ALTER TABLE [dbo].[Oplaty] WITH NOCHECK ADD
	CONSTRAINT [PK_Oplaty] PRIMARY KEY CLUSTERED
	(
	
	[IdOplaty]
	
	) ON [PRIMARY]
GO

--- Rachunki ---

ALTER TABLE [dbo].[Rachunki] WITH NOCHECK ADD
	CONSTRAINT [PK_Rachunki] PRIMARY KEY CLUSTERED
	(
	
	[IdRachunku]
	
	) ON [PRIMARY]
GO

--- Zmiany ---

ALTER TABLE [dbo].[Zmiany] WITH NOCHECK ADD
	CONSTRAINT [PK_Zmiany] PRIMARY KEY CLUSTERED
	(
	
	[IdZmiany]
	
	) ON [PRIMARY]
GO

--- Wynagrodzenie ---

ALTER TABLE [dbo].[Wynagrodzenie] WITH NOCHECK ADD
	CONSTRAINT [PK_Wynagrodzenie] PRIMARY KEY CLUSTERED
	(
	
	[IdWynagrodzenia]
	
	) ON [PRIMARY]
GO

--- Bank ---

ALTER TABLE [dbo].[Bank] WITH NOCHECK ADD
	CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED
	(

		[GrKrwi]

	) ON [PRIMARY]
GO


--- Definicje Foreign Keys ---
------------------------------

ALTER TABLE [dbo].[Pacjent] ADD
	CONSTRAINT [FK_Pacjent_Oddzial] FOREIGN KEY
	(
		[IdOddzialu]
		) REFERENCES [dbo].[Oddzial]
	(
		[IdOddzialu]
		)
GO

ALTER TABLE [dbo].[Dawca] ADD
	CONSTRAINT [FK_Dawca_Oddzial] FOREIGN KEY
	(
		[IdOddzialu]
		) REFERENCES [dbo].[Oddzial]
	(
		[IdOddzialu]
		)
GO

ALTER TABLE [dbo].[Zabieg] ADD
	CONSTRAINT [FK_Zabieg_Wykonawca] FOREIGN KEY
	(
		[IdWykonawcy]
	) REFERENCES [dbo].[WykonawcaZabieg]
	(
		[IdWykonawcy]
	)	
GO

ALTER TABLE [dbo].[Zapis] ADD
	CONSTRAINT [FK_Zapis_Zabieg] FOREIGN KEY
	(
		[IdZabiegu]
	) REFERENCES [dbo].[Zabieg]
	(
		[IdZabiegu]
	),
	CONSTRAINT [FK_Zapis_Pacjent] FOREIGN KEY
	(
		[NrPacjenta]
	) REFERENCES [dbo].[Pacjent]
	(	
		[NrPacjenta]
	)
GO

ALTER TABLE [dbo].[Pracownik] ADD
	CONSTRAINT [FK_Pracownik_Wynagrodzenie] FOREIGN KEY
	(
		[IdWynagrodzenia]
	) REFERENCES [dbo].[Wynagrodzenie]
	(
		[IdWynagrodzenia]
	),
	CONSTRAINT [FK_Pracowik_Oddzial] FOREIGN KEY
	(
		[IdOddzialu]
	) REFERENCES [dbo].[Oddzial]
	(
		[IdOddzialu]
	),
	CONSTRAINT [FK_Pracownik_Zmiana] FOREIGN KEY
	(
		[IdZmiany]
	) REFERENCES [dbo].[Zmiany]
	(
		[IdZmiany]
	)
GO

ALTER TABLE [dbo].[WykonawcaZabieg] ADD
	CONSTRAINT [FK_Wykonawca_Pracownik] FOREIGN KEY
	(
		[IdPracownika]
	) REFERENCES [dbo].[Pracownik]
	(
		[IdPracownika]
	)
GO

ALTER TABLE [dbo].[Dostawa] ADD
	CONSTRAINT [FK_Dostawa_Pracownik] FOREIGN KEY
	(
		[IdOdbiorcy]
	) REFERENCES [dbo].[Pracownik]
	(
		[IdPracownika]
	)
GO

ALTER TABLE [dbo].[Oplaty] ADD
	CONSTRAINT [FK_Oplaty_Rachunki] FOREIGN KEY
	(
		[IdRachunku]
	) REFERENCES [dbo].[Rachunki]
	(
		[IdRachunku]
	)
GO

ALTER TABLE [dbo].[Wynagrodzenie] ADD
	CONSTRAINT [FK_Wynagrodzenie_Rachunek] FOREIGN KEY
	(
		[IdRachunku]
	) REFERENCES [dbo].[Rachunki]
	(
		[IdRachunku]
	),
	CONSTRAINT [FK_Wynagrodzenie_Pracownik] FOREIGN KEY
	(
		[IdPracownika]
	) REFERENCES [dbo].[Pracownik]
	(
		[IdPracownika]
	)
GO
--- Definicje Indeksu ---

CREATE UNIQUE INDEX index_pracownik
ON Pracownik (IdPracownika)
GO

CREATE INDEX index_pacjent
ON Pacjent (NrPacjenta,GrKrwi)
GO

CREATE INDEX index_zabieg
ON Zabieg (IdZabiegu,IdWykonawcy)
GO

CREATE INDEX index_dawca
ON Dawca (KodDawcy,IdOddzialu)
GO

CREATE UNIQUE INDEX index_oddzial
ON Oddzial (IdOddzialu)
GO

CREATE INDEX index_zapis
ON Zapis (IdZapisu,IdZabiegu)
GO

CREATE INDEX index_dostawa
ON Dostawa (IdDostawy,IdOdbiorcy)
GO

CREATE INDEX index_oplaty
ON Oplaty (IdRachunku,IdOplaty)
GO

CREATE UNIQUE INDEX index_rachunki
ON Rachunki (IdRachunku)
GO

CREATE UNIQUE INDEX index_zmiany
ON Zmiany (IdZmiany)
GO

CREATE INDEX index_wynagrodzenie
ON Wynagrodzenie (IdRachunku,IdWynagrodzenia,IdPracownika)
GO



-------------------
---- Semestr 5 ----
-------------------

--- Rola/user/login Pacjent ---
--- Tworzenie oraz nadawanie uprawnien ---

CREATE ROLE Role_Pacjent
GO
CREATE LOGIN Login_Pacjent WITH PASSWORD = 'pacjent'
GO
CREATE USER User_Pacjent FOR LOGIN Login_Pacjent
GO

USE BloodBank
GO
GRANT SELECT (NrPacjenta, Imie, Nazwisko, Pesel) ON [dbo].[Pacjent] TO Role_Pacjent
GO
GRANT SELECT ON [dbo].[Zabieg] TO Role_Pacjent
GO
GRANT SELECT ON [dbo].[Zapis] TO Role_Pacjent
GO
GRANT SELECT (Imie,Nazwisko,Telefon,Email) ON [dbo].[Pracownik] TO Role_Pacjent
GO
EXECUTE sp_addrolemember Role_Pacjent, User_Pacjent
GO

--- Rola/user/login Lekarz ---
--- Tworzenie oraz nadawanie uprawnien ---

CREATE ROLE Role_Lekarz
GO
CREATE LOGIN Login_Lekarz WITH PASSWORD = 'lekarz'
GO
CREATE USER User_Lekarz FOR LOGIN Login_Lekarz
GO

USE BloodBank
GO
GRANT UPDATE, SELECT , INSERT , DELETE ON [dbo].[Zabieg] TO Role_Lekarz
GO
GRANT SELECT ON [dbo].[Zmiany] TO Role_Lekarz
GO
GRANT SELECT ON [dbo].[Oddzial] TO Role_Lekarz
GO
GRANT UPDATE,SELECT ON [dbo].[Dostawa] TO Role_Lekarz
GO
GRANT SELECT,UPDATE ON [dbo].[Dawca] TO Role_Lekarz
GO
GRANT SELECT,UPDATE ON [dbo].[Pacjent] TO Role_Lekarz
GO
GRANT SELECT ON [dbo].[Wynagrodzenie] TO Role_Lekarz
GO
EXECUTE sp_addrolemember Role_Lekarz,User_Lekarz
GO

--- Owner ---

CREATE ROLE Role_Owner AUTHORIZATION db_owner
GO
CREATE LOGIN Login_Zarzadca WITH PASSWORD = 'zarzadca'
GO
CREATE USER User_Zarzadca FOR LOGIN Login_Zarzadca
GO
EXECUTE sp_addrolemember Role_Owner, User_Zarzadca
GO

--- Procedura z transakcja ---
--- Zmiany stanu banku - pacjent/dawca/dostawa ---

--- Transakcja dodajaca stan krwi + dostawa ---

CREATE PROCEDURE Plus_Dostawa
@Nazwa char(25),
@GrKrwi char(25),
@Termin DATETIME,
@IdDostawy int,
@IdOdbiorcy int,
@Ilosc smallint,
@Uwagi char(128)
AS
BEGIN
	BEGIN TRANSACTION;
	SAVE TRANSACTION Zapis;
	BEGIN TRY
	INSERT INTO Dostawa(Nazwa,GrKrwi,Termin,IdDostawy,IdOdbiorcy,Ilosc,Uwagi)
	VALUES (@Nazwa,@GrKrwi,@Termin,@IdDostawy,@IdOdbiorcy,@Ilosc,@Uwagi);

	UPDATE Bank SET Ilosc = Ilosc + @Ilosc
	WHERE GrKrwi = @GrKrwi;
	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION Zapis; -- cofka do zapisu
        END
    END CATCH
	COMMIT TRANSACTION;
END;
GO

--- Transakcja dodajaca stan krwi + dawca ---

CREATE PROCEDURE Plus_Dawca
@Imie char(20),
@Nazwisko char(30),
@Pesel char (11),
@Ilosc int,
@GrKrwi char(10),
@Miejscowosc char(30),
@Telefon char(25),
@Wiek tinyint,
@IdOddzialu int,
@KodDawcy int
AS
BEGIN
	BEGIN TRANSACTION;
	SAVE TRANSACTION Zapis;
	BEGIN TRY
	INSERT INTO Dawca(Imie,Nazwisko,Pesel,Ilosc,GrKrwi,Miejscowosc,Telefon,Wiek,IdOddzialu,KodDawcy)
	VALUES (@Imie,@Nazwisko,@Pesel,@Ilosc,@GrKrwi,@Miejscowosc,@Telefon,@Wiek,@IdOddzialu,@KodDawcy);
	UPDATE Bank SET Ilosc = Ilosc + @Ilosc
	WHERE GrKrwi = @GrKrwi;

	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION Zapis; -- cofka do zapisu
        END
    END CATCH
	COMMIT TRANSACTION;
END;
GO

-- Transakcja odejmujaca stan krwi - pacjent --

CREATE PROCEDURE Minus_Pacjent
@Imie char(20),
@Nazwisko char(30),
@Pesel char(11),
@Ilosc int,
@GrKrwi char(10),
@Miejscowosc char(30),
@Telefon char(25),
@Wiek tinyint,
@NrPacjenta int,
@DataZapisu datetime,
@IdOddzialu int
AS
BEGIN
	BEGIN TRANSACTION;
	SAVE TRANSACTION Zapis;
	BEGIN TRY
	INSERT Pacjent (Imie,Nazwisko,Pesel,Ilosc,GrKrwi,Miejscowosc,Telefon,Wiek,NrPacjenta,DataZapisu,IdOddzialu)
	VALUES (@Imie,@Nazwisko,@Pesel,@Ilosc,@GrKrwi,@Miejscowosc,@Telefon,@Wiek,@NrPacjenta,@DataZapisu,@IdOddzialu);
	UPDATE Bank SET Ilosc = Ilosc - @Ilosc
	WHERE GrKrwi = @GrKrwi;
	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION Zapis; -- cofka do zapisu
        END
    END CATCH
	COMMIT TRANSACTION;
END;
GO

--- Przerwanie transakcji / waitfor delay --

CREATE PROCEDURE Dostawa_Delay
@Nazwa char(25),
@GrKrwi char(25),
@Termin DATETIME,
@IdDostawy int,
@IdOdbiorcy int,
@Ilosc smallint,
@Uwagi char(128)
AS
BEGIN
	BEGIN TRANSACTION;
	SAVE TRANSACTION Zapis;
	BEGIN TRY
	SELECT * FROM Dostawa
	SELECT * FROM Bank
	INSERT INTO Dostawa(Nazwa,GrKrwi,Termin,IdDostawy,IdOdbiorcy,Ilosc,Uwagi)
	VALUES (@Nazwa,@GrKrwi,@Termin,@IdDostawy,@IdOdbiorcy,@Ilosc,@Uwagi);
	WAITFOR DELAY '00:00:05'
	UPDATE Bank SET Ilosc = Ilosc + @Ilosc
	WHERE GrKrwi = @GrKrwi;
	SELECT * FROM Dostawa
	SELECT * FROM Bank
	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION Zapis; -- cofka do zapisu
        END
    END CATCH
	COMMIT TRANSACTION;
END;
GO

--- Uruchamianie wspolbiezne / waitfor time ---

CREATE PROCEDURE Dostawa_Time
@Nazwa char(25),
@GrKrwi char(25),
@Termin DATETIME,
@IdDostawy int,
@IdOdbiorcy int,
@Ilosc smallint,
@Uwagi char(128)
AS
BEGIN
	DECLARE @Opoznienie DATETIME
	SET @Opoznienie = DATEADD(s,5,GETDATE())
	BEGIN TRANSACTION;
	SAVE TRANSACTION Zapis;
	BEGIN TRY
	SELECT * FROM Dostawa
	SELECT * FROM Bank
	WAITFOR TIME @Opoznienie
	INSERT INTO Dostawa(Nazwa,GrKrwi,Termin,IdDostawy,IdOdbiorcy,Ilosc,Uwagi)
	VALUES (@Nazwa,@GrKrwi,@Termin,@IdDostawy,@IdOdbiorcy,@Ilosc,@Uwagi);
	UPDATE Bank SET Ilosc = Ilosc + @Ilosc
	WHERE GrKrwi = @GrKrwi;
	SELECT * FROM Dostawa
	SELECT * FROM Bank
	END TRY
	BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION Zapis; -- cofka do zapisu
        END
    END CATCH
	COMMIT TRANSACTION;
END;
GO

-- LINKED SERVERS --

-- Inicjowanie -- 

USE [master]  
GO  
EXEC master.dbo.sp_addlinkedserver   
    @server = N'DESKTOP-4AFUV69\SQLEXPRESS',   
    @srvproduct=N'SQL Server' ;  
GO  
EXEC master.dbo.sp_addlinkedsrvlogin   
    @rmtsrvname = N'DESKTOP-4AFUV69\SQLEXPRESS',   
    @locallogin = NULL ,   
    @useself = N'True' ;  
GO  

-- Procedura Sumująca stan krwi --

CREATE PROCEDURE Suma_Krwi @Grupa char(30)
AS
BEGIN
SELECT Sum(r.ilosc+a.ilosc) AS Stan FROM [BloodBank].[dbo].[Bank] r join
[DESKTOP-4AFUV69\SQLEXPRESS].[BloodBank2].[dbo].[Bank] a
ON a.[GrKrwi] = r.[GrKrwi] where a.[GrKrwi] = @Grupa
END;
GO

-- Procedura Odnajdujaca identyczne nazwisko w 2 tabelach --

CREATE PROCEDURE Wspolne_Nazw @Nazw char(30)
AS
BEGIN
SELECT Nazwisko FROM [DESKTOP-4AFUV69\SQLSERVER].[BloodBank].[dbo].[Pracownik] r join
[DESKTOP-4AFUV69\SQLEXPRESS].[BloodBank2].[dbo].[Pacjent] a
ON r.[Nazwisko] = a.[Nazwisko] WHERE r.[Nazwisko] = @Nazw
END;
GO