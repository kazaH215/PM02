USE [master]
GO

-- Удаляем базу, если она существует
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ServiceDeskDB')
BEGIN
    ALTER DATABASE [ServiceDeskDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [ServiceDeskDB];
END
GO

-- Создаём базу данных
CREATE DATABASE [ServiceDeskDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ServiceDeskDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ServiceDeskDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ServiceDeskDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ServiceDeskDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO

ALTER DATABASE [ServiceDeskDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ServiceDeskDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [ServiceDeskDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [ServiceDeskDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ServiceDeskDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ServiceDeskDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ServiceDeskDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ServiceDeskDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ServiceDeskDB] SET  MULTI_USER 
GO
ALTER DATABASE [ServiceDeskDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ServiceDeskDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ServiceDeskDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ServiceDeskDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ServiceDeskDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ServiceDeskDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [ServiceDeskDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [ServiceDeskDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO

USE [ServiceDeskDB]
GO

-- =============================================
-- 1. СОЗДАНИЕ ТАБЛИЦ
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Статусы заявок
CREATE TABLE [dbo].[Статусы](
	[КодСтатуса] [int] IDENTITY(1,1) NOT NULL,
	[Наименование] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[КодСтатуса] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Пользователи (для авторизации)
CREATE TABLE [dbo].[Пользователи](
	[КодПользователя] [int] IDENTITY(1,1) NOT NULL,
	[Логин] [nvarchar](50) NOT NULL,
	[ПарольHash] [nvarchar](255) NOT NULL,
	[Роль] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[КодПользователя] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Клиенты (заказчики)
CREATE TABLE [dbo].[Клиенты](
	[КодКлиента] [int] IDENTITY(1,1) NOT NULL,
	[Наименование] [nvarchar](255) NOT NULL,
	[ИНН] [nvarchar](12) NULL,
	[КонтактноеЛицо] [nvarchar](255) NULL,
	[Телефон] [nvarchar](20) NULL,
	[Email] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[КодКлиента] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Программисты (исполнители)
CREATE TABLE [dbo].[Программисты](
	[КодПрограммиста] [int] IDENTITY(1,1) NOT NULL,
	[ФИО] [nvarchar](255) NOT NULL,
	[Специализация] [nvarchar](100) NOT NULL,
	[Телефон] [nvarchar](20) NULL,
	[Email] [nvarchar](100) NULL,
	[КодПользователя] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[КодПрограммиста] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Услуги (работы по 1С)
CREATE TABLE [dbo].[Услуги](
	[КодУслуги] [int] IDENTITY(1,1) NOT NULL,
	[Наименование] [nvarchar](255) NOT NULL,
	[Цена] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[КодУслуги] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Заявки (основная таблица)
CREATE TABLE [dbo].[Заявки](
	[КодЗаявки] [int] IDENTITY(1,1) NOT NULL,
	[КодКлиента] [int] NOT NULL,
	[КодПрограммиста] [int] NOT NULL,
	[КодУслуги] [int] NOT NULL,
	[ДатаСоздания] [datetime] NOT NULL,
	[Статус] [int] NOT NULL,
	[Описание] [nvarchar](max) NULL,
	[СрокВыполнения] [date] NULL,
	[Сумма] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[КодЗаявки] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- История изменений заявок (аудит)
CREATE TABLE [dbo].[ИсторияИзменений](
	[КодИзменения] [int] IDENTITY(1,1) NOT NULL,
	[КодЗаявки] [int] NOT NULL,
	[Пользователь] [nvarchar](255) NOT NULL,
	[Действие] [nvarchar](255) NOT NULL,
	[ДатаИзменения] [datetime] NOT NULL,
	[СтарыйСтатус] [nvarchar](50) NULL,
	[НовыйСтатус] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[КодИзменения] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- =============================================
-- 2. ИНДЕКСЫ
-- =============================================

CREATE NONCLUSTERED INDEX [IX_Заявки_КодКлиента] ON [dbo].[Заявки]
(
	[КодКлиента] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Заявки_КодПрограммиста] ON [dbo].[Заявки]
(
	[КодПрограммиста] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Заявки_КодУслуги] ON [dbo].[Заявки]
(
	[КодУслуги] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Заявки_Статус] ON [dbo].[Заявки]
(
	[Статус] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Пользователи] ADD UNIQUE NONCLUSTERED 
(
	[Логин] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

-- =============================================
-- 3. DEFAULT ЗНАЧЕНИЯ
-- =============================================

ALTER TABLE [dbo].[Заявки] ADD  DEFAULT (getdate()) FOR [ДатаСоздания]
GO
ALTER TABLE [dbo].[Заявки] ADD  DEFAULT ((1)) FOR [Статус]
GO
ALTER TABLE [dbo].[Заявки] ADD  DEFAULT ((0)) FOR [Сумма]
GO
ALTER TABLE [dbo].[ИсторияИзменений] ADD  DEFAULT (getdate()) FOR [ДатаИзменения]
GO

-- =============================================
-- 4. ВНЕШНИЕ КЛЮЧИ
-- =============================================

ALTER TABLE [dbo].[Программисты]  WITH CHECK ADD  CONSTRAINT [FK_Программисты_Пользователи] FOREIGN KEY([КодПользователя])
REFERENCES [dbo].[Пользователи] ([КодПользователя])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Программисты] CHECK CONSTRAINT [FK_Программисты_Пользователи]
GO

ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [FK_Заявки_Клиенты] FOREIGN KEY([КодКлиента])
REFERENCES [dbo].[Клиенты] ([КодКлиента])
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [FK_Заявки_Клиенты]
GO

ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [FK_Заявки_Программисты] FOREIGN KEY([КодПрограммиста])
REFERENCES [dbo].[Программисты] ([КодПрограммиста])
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [FK_Заявки_Программисты]
GO

ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [FK_Заявки_Услуги] FOREIGN KEY([КодУслуги])
REFERENCES [dbo].[Услуги] ([КодУслуги])
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [FK_Заявки_Услуги]
GO

ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [FK_Заявки_Статусы] FOREIGN KEY([Статус])
REFERENCES [dbo].[Статусы] ([КодСтатуса])
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [FK_Заявки_Статусы]
GO

ALTER TABLE [dbo].[ИсторияИзменений]  WITH CHECK ADD  CONSTRAINT [FK_История_Заявки] FOREIGN KEY([КодЗаявки])
REFERENCES [dbo].[Заявки] ([КодЗаявки])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ИсторияИзменений] CHECK CONSTRAINT [FK_История_Заявки]
GO

-- =============================================
-- 5. ОГРАНИЧЕНИЯ CHECK
-- =============================================

ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [CHK_Заявки_Сумма] CHECK  (([Сумма]>=(0)))
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [CHK_Заявки_Сумма]
GO

ALTER TABLE [dbo].[Услуги]  WITH CHECK ADD  CONSTRAINT [CHK_Услуги_Цена] CHECK  (([Цена]>=(0)))
GO
ALTER TABLE [dbo].[Услуги] CHECK CONSTRAINT [CHK_Услуги_Цена]
GO

ALTER TABLE [dbo].[Пользователи]  WITH CHECK ADD  CONSTRAINT [CHK_Пользователи_Роль] CHECK  (([Роль]='Администратор' OR [Роль]='Менеджер' OR [Роль]='Программист' OR [Роль]='Клиент'))
GO
ALTER TABLE [dbo].[Пользователи] CHECK CONSTRAINT [CHK_Пользователи_Роль]
GO

-- =============================================
-- 6. ВСТАВКА ТЕСТОВЫХ ДАННЫХ (с IDENTITY_INSERT для точного соответствия)
-- =============================================

SET IDENTITY_INSERT [dbo].[Статусы] ON 
INSERT [dbo].[Статусы] ([КодСтатуса], [Наименование]) VALUES (1, N'Новая')
INSERT [dbo].[Статусы] ([КодСтатуса], [Наименование]) VALUES (2, N'В работе')
INSERT [dbo].[Статусы] ([КодСтатуса], [Наименование]) VALUES (3, N'На тестировании')
INSERT [dbo].[Статусы] ([КодСтатуса], [Наименование]) VALUES (4, N'Выполнено')
INSERT [dbo].[Статусы] ([КодСтатуса], [Наименование]) VALUES (5, N'Оплачено')
SET IDENTITY_INSERT [dbo].[Статусы] OFF
GO

SET IDENTITY_INSERT [dbo].[Пользователи] ON 
INSERT [dbo].[Пользователи] ([КодПользователя], [Логин], [ПарольHash], [Роль]) VALUES (1, N'admin', N'admin123', N'Администратор')
INSERT [dbo].[Пользователи] ([КодПользователя], [Логин], [ПарольHash], [Роль]) VALUES (2, N'manager1', N'manager123', N'Менеджер')
INSERT [dbo].[Пользователи] ([КодПользователя], [Логин], [ПарольHash], [Роль]) VALUES (3, N'dev.ivanov', N'dev123', N'Программист')
INSERT [dbo].[Пользователи] ([КодПользователя], [Логин], [ПарольHash], [Роль]) VALUES (4, N'client1', N'client123', N'Клиент')
SET IDENTITY_INSERT [dbo].[Пользователи] OFF
GO

SET IDENTITY_INSERT [dbo].[Клиенты] ON 
INSERT [dbo].[Клиенты] ([КодКлиента], [Наименование], [ИНН], [КонтактноеЛицо], [Телефон], [Email]) VALUES (1, N'ООО "Ромашка"', N'7701234567', N'Иванов И.И.', N'+7 (912) 123-45-67', N'ivanov@romashka.ru')
INSERT [dbo].[Клиенты] ([КодКлиента], [Наименование], [ИНН], [КонтактноеЛицо], [Телефон], [Email]) VALUES (2, N'ИП Петров', N'7709876543', N'Петров П.П.', N'+7 (913) 987-65-43', N'petrov@mail.ru')
INSERT [dbo].[Клиенты] ([КодКлиента], [Наименование], [ИНН], [КонтактноеЛицо], [Телефон], [Email]) VALUES (3, N'АО "ТехноПарк"', N'7705551234', N'Сидорова А.А.', N'+7 (914) 555-12-34', N'sidorova@technopark.ru')
INSERT [dbo].[Клиенты] ([КодКлиента], [Наименование], [ИНН], [КонтактноеЛицо], [Телефон], [Email]) VALUES (4, N'ООО "Вектор"', N'7705559876', N'Кузнецов В.В.', N'+7 (915) 555-98-76', N'kuznetsov@vektor.ru')
SET IDENTITY_INSERT [dbo].[Клиенты] OFF
GO

SET IDENTITY_INSERT [dbo].[Программисты] ON 
INSERT [dbo].[Программисты] ([КодПрограммиста], [ФИО], [Специализация], [Телефон], [Email], [КодПользователя]) VALUES (1, N'Иванов Иван Иванович', N'1С:Бухгалтерия', N'+7 (900) 111-22-33', N'ivanov@mastersoft.ru', 3)
INSERT [dbo].[Программисты] ([КодПрограммиста], [ФИО], [Специализация], [Телефон], [Email], [КодПользователя]) VALUES (2, N'Петров Петр Петрович', N'1С:Управление торговлей', N'+7 (900) 444-55-66', N'petrov@mastersoft.ru', NULL)
INSERT [dbo].[Программисты] ([КодПрограммиста], [ФИО], [Специализация], [Телефон], [Email], [КодПользователя]) VALUES (3, N'Сидорова Анна Алексеевна', N'1С:Зарплата и управление персоналом', N'+7 (900) 777-88-99', N'sidorova@mastersoft.ru', NULL)
INSERT [dbo].[Программисты] ([КодПрограммиста], [ФИО], [Специализация], [Телефон], [Email], [КодПользователя]) VALUES (4, N'Кузнецов Дмитрий Андреевич', N'1С:Управление небольшой фирмой', N'+7 (900) 123-45-67', N'kuznetsov@mastersoft.ru', NULL)
SET IDENTITY_INSERT [dbo].[Программисты] OFF
GO

SET IDENTITY_INSERT [dbo].[Услуги] ON 
INSERT [dbo].[Услуги] ([КодУслуги], [Наименование], [Цена]) VALUES (1, N'Консультация по 1С', CAST(1500.00 AS Decimal(10, 2)))
INSERT [dbo].[Услуги] ([КодУслуги], [Наименование], [Цена]) VALUES (2, N'Доработка отчёта', CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[Услуги] ([КодУслуги], [Наименование], [Цена]) VALUES (3, N'Обновление платформы', CAST(3500.00 AS Decimal(10, 2)))
INSERT [dbo].[Услуги] ([КодУслуги], [Наименование], [Цена]) VALUES (4, N'Настройка печатных форм', CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[Услуги] ([КодУслуги], [Наименование], [Цена]) VALUES (5, N'Обучение пользователей', CAST(4000.00 AS Decimal(10, 2)))
INSERT [dbo].[Услуги] ([КодУслуги], [Наименование], [Цена]) VALUES (6, N'Внедрение новой конфигурации', CAST(15000.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[Услуги] OFF
GO

SET IDENTITY_INSERT [dbo].[Заявки] ON 
INSERT [dbo].[Заявки] ([КодЗаявки], [КодКлиента], [КодПрограммиста], [КодУслуги], [ДатаСоздания], [Статус], [Описание], [СрокВыполнения], [Сумма]) VALUES (1, 1, 1, 2, CAST(N'2026-08-20T10:00:00.000' AS DateTime), 2, N'Сделать отчёт по продажам за квартал', CAST(N'2026-08-25' AS Date), CAST(5000.00 AS Decimal(10, 2)))
INSERT [dbo].[Заявки] ([КодЗаявки], [КодКлиента], [КодПрограммиста], [КодУслуги], [ДатаСоздания], [Статус], [Описание], [СрокВыполнения], [Сумма]) VALUES (2, 2, 2, 3, CAST(N'2026-08-21T11:30:00.000' AS DateTime), 1, N'Обновить платформу до 8.3.25', CAST(N'2026-08-28' AS Date), CAST(3500.00 AS Decimal(10, 2)))
INSERT [dbo].[Заявки] ([КодЗаявки], [КодКлиента], [КодПрограммиста], [КодУслуги], [ДатаСоздания], [Статус], [Описание], [СрокВыполнения], [Сумма]) VALUES (3, 3, 1, 4, CAST(N'2026-08-22T09:15:00.000' AS DateTime), 4, N'Исправить печать в счет-фактуре', CAST(N'2026-08-23' AS Date), CAST(2500.00 AS Decimal(10, 2)))
INSERT [dbo].[Заявки] ([КодЗаявки], [КодКлиента], [КодПрограммиста], [КодУслуги], [ДатаСоздания], [Статус], [Описание], [СрокВыполнения], [Сумма]) VALUES (4, 4, 3, 6, CAST(N'2026-08-22T13:00:00.000' AS DateTime), 2, N'Внедрение конфигурации "Управление небольшой фирмой"', CAST(N'2026-09-15' AS Date), CAST(15000.00 AS Decimal(10, 2)))
INSERT [dbo].[Заявки] ([КодЗаявки], [КодКлиента], [КодПрограммиста], [КодУслуги], [ДатаСоздания], [Статус], [Описание], [СрокВыполнения], [Сумма]) VALUES (5, 1, 4, 1, CAST(N'2026-08-23T10:00:00.000' AS DateTime), 1, N'Консультация по отчёту по зарплате', CAST(N'2026-08-24' AS Date), CAST(1500.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[Заявки] OFF
GO

SET IDENTITY_INSERT [dbo].[ИсторияИзменений] ON 
INSERT [dbo].[ИсторияИзменений] ([КодИзменения], [КодЗаявки], [Пользователь], [Действие], [ДатаИзменения], [СтарыйСтатус], [НовыйСтатус]) VALUES (1, 1, N'manager1', N'Создана заявка', CAST(N'2026-08-20T10:00:00.000' AS DateTime), NULL, N'Новая')
INSERT [dbo].[ИсторияИзменений] ([КодИзменения], [КодЗаявки], [Пользователь], [Действие], [ДатаИзменения], [СтарыйСтатус], [НовыйСтатус]) VALUES (2, 1, N'manager1', N'Назначен исполнитель', CAST(N'2026-08-20T10:05:00.000' AS DateTime), N'Новая', N'В работе')
INSERT [dbo].[ИсторияИзменений] ([КодИзменения], [КодЗаявки], [Пользователь], [Действие], [ДатаИзменения], [СтарыйСтатус], [НовыйСтатус]) VALUES (3, 3, N'dev.ivanov', N'Заявка выполнена', CAST(N'2026-08-22T15:00:00.000' AS DateTime), N'В работе', N'Выполнено')
INSERT [dbo].[ИсторияИзменений] ([КодИзменения], [КодЗаявки], [Пользователь], [Действие], [ДатаИзменения], [СтарыйСтатус], [НовыйСтатус]) VALUES (4, 4, N'manager1', N'Заявка взята в работу', CAST(N'2026-08-22T13:10:00.000' AS DateTime), N'Новая', N'В работе')
SET IDENTITY_INSERT [dbo].[ИсторияИзменений] OFF
GO

-- =============================================
-- 7. ТРИГГЕР ДЛЯ АУДИТА
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [trg_Заявки_История]
ON [dbo].[Заявки]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE([Статус])
    BEGIN
        INSERT INTO [dbo].[ИсторияИзменений] ([КодЗаявки], [Пользователь], [Действие], [ДатаИзменения], [СтарыйСтатус], [НовыйСтатус])
        SELECT 
            i.[КодЗаявки],
            ISNULL(SUSER_SNAME(), N'System'),
            N'Изменен статус',
            GETDATE(),
            (SELECT [Наименование] FROM [dbo].[Статусы] WHERE [КодСтатуса] = d.[Статус]),
            (SELECT [Наименование] FROM [dbo].[Статусы] WHERE [КодСтатуса] = i.[Статус])
        FROM inserted i
        INNER JOIN deleted d ON i.[КодЗаявки] = d.[КодЗаявки]
        WHERE i.[Статус] != d.[Статус];
    END
END
GO

ALTER TABLE [dbo].[Заявки] ENABLE TRIGGER [trg_Заявки_История]
GO

-- =============================================
-- 8. ПРЕДСТАВЛЕНИЯ ДЛЯ ОТЧЁТОВ
-- =============================================

CREATE VIEW [dbo].[v_АктивныеЗаявки]
AS
SELECT 
    z.[КодЗаявки],
    k.[Наименование] AS [Клиент],
    p.[ФИО] AS [Исполнитель],
    u.[Наименование] AS [Услуга],
    z.[ДатаСоздания],
    z.[СрокВыполнения],
    s.[Наименование] AS [Статус],
    z.[Сумма]
FROM [dbo].[Заявки] z
INNER JOIN [dbo].[Клиенты] k ON z.[КодКлиента] = k.[КодКлиента]
INNER JOIN [dbo].[Программисты] p ON z.[КодПрограммиста] = p.[КодПрограммиста]
INNER JOIN [dbo].[Услуги] u ON z.[КодУслуги] = u.[КодУслуги]
INNER JOIN [dbo].[Статусы] s ON z.[Статус] = s.[КодСтатуса]
WHERE z.[Статус] IN (1, 2, 3)
GO

CREATE VIEW [dbo].[v_ОтчетПоЗаявкам]
AS
SELECT 
    k.[Наименование] AS [Клиент],
    COUNT(z.[КодЗаявки]) AS [Количество заявок],
    SUM(z.[Сумма]) AS [Общая сумма]
FROM [dbo].[Заявки] z
INNER JOIN [dbo].[Клиенты] k ON z.[КодКлиента] = k.[КодКлиента]
WHERE z.[Статус] = 5
GROUP BY k.[Наименование]
GO

USE [master]
GO
ALTER DATABASE [ServiceDeskDB] SET  READ_WRITE 
GO