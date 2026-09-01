USE [master]
GO

-- Удаляем базу, если она уже существует (для пересоздания)
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ServiceDeskDB')
BEGIN
    ALTER DATABASE [ServiceDeskDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [ServiceDeskDB];
END
GO

-- Создаём новую базу данных
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

-- Устанавливаем параметры базы данных
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
-- 1. СПРАВОЧНИКИ
-- =============================================

-- Таблица: Статусы (аналог Отделения)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Статусы](
	[КодСтатуса] [int] IDENTITY(1,1) NOT NULL,
	[Наименование] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[КодСтатуса] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Таблица: Пользователи (для авторизации)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

-- Таблица: Клиенты (аналог Пациенты)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

-- Таблица: Программисты (аналог Врачи)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

-- Таблица: Услуги
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

-- =============================================
-- 2. ОСНОВНАЯ ТАБЛИЦА ЗАЯВОК
-- =============================================

-- Таблица: Заявки (аналог ЗаказНаряды)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

-- Таблица: История изменений заявок (аналог отсутствует, но нужен для ПМ.02)
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
-- 3. ИНДЕКСЫ И ОГРАНИЧЕНИЯ
-- =============================================

-- Индексы для внешних ключей
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

-- Уникальный индекс на логин
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Пользователи] ADD UNIQUE NONCLUSTERED 
(
	[Логин] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

-- =============================================
-- 4. DEFAULT ЗНАЧЕНИЯ
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
-- 5. ВНЕШНИЕ КЛЮЧИ (СВЯЗИ)
-- =============================================

-- Программист -> Пользователь
ALTER TABLE [dbo].[Программисты]  WITH CHECK ADD  CONSTRAINT [FK_Программисты_Пользователи] FOREIGN KEY([КодПользователя])
REFERENCES [dbo].[Пользователи] ([КодПользователя])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Программисты] CHECK CONSTRAINT [FK_Программисты_Пользователи]
GO

-- Заявка -> Клиент
ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [FK_Заявки_Клиенты] FOREIGN KEY([КодКлиента])
REFERENCES [dbo].[Клиенты] ([КодКлиента])
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [FK_Заявки_Клиенты]
GO

-- Заявка -> Программист
ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [FK_Заявки_Программисты] FOREIGN KEY([КодПрограммиста])
REFERENCES [dbo].[Программисты] ([КодПрограммиста])
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [FK_Заявки_Программисты]
GO

-- Заявка -> Услуга
ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [FK_Заявки_Услуги] FOREIGN KEY([КодУслуги])
REFERENCES [dbo].[Услуги] ([КодУслуги])
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [FK_Заявки_Услуги]
GO

-- Заявка -> Статус
ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [FK_Заявки_Статусы] FOREIGN KEY([Статус])
REFERENCES [dbo].[Статусы] ([КодСтатуса])
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [FK_Заявки_Статусы]
GO

-- История -> Заявка
ALTER TABLE [dbo].[ИсторияИзменений]  WITH CHECK ADD  CONSTRAINT [FK_История_Заявки] FOREIGN KEY([КодЗаявки])
REFERENCES [dbo].[Заявки] ([КодЗаявки])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ИсторияИзменений] CHECK CONSTRAINT [FK_История_Заявки]
GO

-- =============================================
-- 6. ОГРАНИЧЕНИЯ CHECK
-- =============================================

-- Сумма заявки не может быть отрицательной
ALTER TABLE [dbo].[Заявки]  WITH CHECK ADD  CONSTRAINT [CHK_Заявки_Сумма] CHECK  (([Сумма]>=(0)))
GO
ALTER TABLE [dbo].[Заявки] CHECK CONSTRAINT [CHK_Заявки_Сумма]
GO

-- Цена услуги не может быть отрицательной
ALTER TABLE [dbo].[Услуги]  WITH CHECK ADD  CONSTRAINT [CHK_Услуги_Цена] CHECK  (([Цена]>=(0)))
GO
ALTER TABLE [dbo].[Услуги] CHECK CONSTRAINT [CHK_Услуги_Цена]
GO

-- Роль пользователя строго из списка
ALTER TABLE [dbo].[Пользователи]  WITH CHECK ADD  CONSTRAINT [CHK_Пользователи_Роль] CHECK  (([Роль]='Администратор' OR [Роль]='Менеджер' OR [Роль]='Программист' OR [Роль]='Клиент'))
GO
ALTER TABLE [dbo].[Пользователи] CHECK CONSTRAINT [CHK_Пользователи_Роль]
GO

-- =============================================
-- 7. ТЕСТОВЫЕ ДАННЫЕ (SEED)
-- =============================================

-- Статусы
INSERT INTO [dbo].[Статусы] ([Наименование]) VALUES (N'Новая')
INSERT INTO [dbo].[Статусы] ([Наименование]) VALUES (N'В работе')
INSERT INTO [dbo].[Статусы] ([Наименование]) VALUES (N'На тестировании')
INSERT INTO [dbo].[Статусы] ([Наименование]) VALUES (N'Выполнено')
INSERT INTO [dbo].[Статусы] ([Наименование]) VALUES (N'Оплачено')
GO

-- Пользователи (пароль: 123456)
INSERT INTO [dbo].[Пользователи] ([Логин], [ПарольHash], [Роль]) VALUES 
(N'admin', N'$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr7wqY6j5JkZ3vP6q4L8x9Y5Q2wE7Ku', N'Администратор'),
(N'manager1', N'$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr7wqY6j5JkZ3vP6q4L8x9Y5Q2wE7Ku', N'Менеджер'),
(N'dev.ivanov', N'$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr7wqY6j5JkZ3vP6q4L8x9Y5Q2wE7Ku', N'Программист'),
(N'client1', N'$2a$10$N9qo8uLOickgx2ZMRZoMy.Mr7wqY6j5JkZ3vP6q4L8x9Y5Q2wE7Ku', N'Клиент')
GO

-- Клиенты
INSERT INTO [dbo].[Клиенты] ([Наименование], [ИНН], [КонтактноеЛицо], [Телефон], [Email]) VALUES 
(N'ООО "Ромашка"', N'7701234567', N'Иванов И.И.', N'+7 (912) 123-45-67', N'ivanov@romashka.ru'),
(N'ИП Петров', N'7709876543', N'Петров П.П.', N'+7 (913) 987-65-43', N'petrov@mail.ru'),
(N'АО "ТехноПарк"', N'7705551234', N'Сидорова А.А.', N'+7 (914) 555-12-34', N'sidorova@technopark.ru')
GO

-- Программисты
INSERT INTO [dbo].[Программисты] ([ФИО], [Специализация], [Телефон], [Email], [КодПользователя]) VALUES 
(N'Иванов Иван Иванович', N'1С:Бухгалтерия', N'+7 (900) 111-22-33', N'ivanov@mastersoft.ru', 3),
(N'Петров Петр Петрович', N'1С:Управление торговлей', N'+7 (900) 444-55-66', N'petrov@mastersoft.ru', NULL),
(N'Сидорова Анна Алексеевна', N'1С:Зарплата и управление персоналом', N'+7 (900) 777-88-99', N'sidorova@mastersoft.ru', NULL)
GO

-- Услуги
INSERT INTO [dbo].[Услуги] ([Наименование], [Цена]) VALUES 
(N'Консультация по 1С', 1500.00),
(N'Доработка отчёта', 5000.00),
(N'Обновление платформы', 3500.00),
(N'Настройка печатных форм', 2500.00),
(N'Обучение пользователей', 4000.00)
GO

-- Заявки
INSERT INTO [dbo].[Заявки] ([КодКлиента], [КодПрограммиста], [КодУслуги], [ДатаСоздания], [Статус], [Описание], [СрокВыполнения], [Сумма]) VALUES 
(1, 1, 2, '2026-08-20 10:00:00', 2, N'Сделать отчёт по продажам за квартал', '2026-08-25', 5000.00),
(2, 2, 3, '2026-08-21 11:30:00', 1, N'Обновить платформу до 8.3.25', '2026-08-28', 3500.00),
(3, 1, 4, '2026-08-22 09:15:00', 4, N'Исправить печать в счет-фактуре', '2026-08-23', 2500.00)
GO

-- История изменений
INSERT INTO [dbo].[ИсторияИзменений] ([КодЗаявки], [Пользователь], [Действие], [ДатаИзменения], [СтарыйСтатус], [НовыйСтатус]) VALUES 
(1, N'manager1', N'Создана заявка', '2026-08-20 10:00:00', NULL, N'Новая'),
(1, N'manager1', N'Назначен исполнитель', '2026-08-20 10:05:00', N'Новая', N'В работе'),
(3, N'dev.ivanov', N'Заявка выполнена', '2026-08-22 15:00:00', N'В работе', N'Выполнено')
GO

-- =============================================
-- 8. ТРИГГЕР ДЛЯ АВТОМАТИЧЕСКОГО АУДИТА
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Триггер: при изменении статуса заявки автоматически пишем в историю
CREATE TRIGGER [trg_Заявки_История]
ON [dbo].[Заявки]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Если статус изменился, фиксируем это в истории
    IF UPDATE([Статус])
    BEGIN
        INSERT INTO [dbo].[ИсторияИзменений] ([КодЗаявки], [Пользователь], [Действие], [ДатаИзменения], [СтарыйСтатус], [НовыйСтатус])
        SELECT 
            i.[КодЗаявки],
            ISNULL(SUSER_SNAME(), N'System'), -- Имя пользователя SQL Server
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

-- Включаем триггер
ALTER TABLE [dbo].[Заявки] ENABLE TRIGGER [trg_Заявки_История]
GO

-- =============================================
-- 9. ПРЕДСТАВЛЕНИЯ ДЛЯ ОТЧЁТОВ
-- =============================================

-- Представление: Активные заявки (соединение всех таблиц)
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
WHERE z.[Статус] IN (1, 2, 3) -- Новая, В работе, На тестировании
GO

-- Представление: Отчёт по выручке за период
CREATE VIEW [dbo].[v_ОтчетПоЗаявкам]
AS
SELECT 
    k.[Наименование] AS [Клиент],
    COUNT(z.[КодЗаявки]) AS [Количество заявок],
    SUM(z.[Сумма]) AS [Общая сумма]
FROM [dbo].[Заявки] z
INNER JOIN [dbo].[Клиенты] k ON z.[КодКлиента] = k.[КодКлиента]
WHERE z.[Статус] = 5 -- Оплачено
GROUP BY k.[Наименование]
GO

-- Проверка работы триггера (обновим статус у заявки №3)
-- UPDATE [dbo].[Заявки] SET [Статус] = 5 WHERE [КодЗаявки] = 3
-- SELECT * FROM [dbo].[ИсторияИзменений]
GO

USE [master]
GO
ALTER DATABASE [ServiceDeskDB] SET  READ_WRITE 
GO