USE Ansible;
GO

IF OBJECT_ID('dbo.Classes', 'U') IS NULL
CREATE TABLE dbo.Classes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    schedule TEXT,
    instructor VARCHAR(255)
);
GO

IF OBJECT_ID('dbo.Objectives', 'U') IS NULL
CREATE TABLE dbo.Objectives (
    id INT IDENTITY(1,1) PRIMARY KEY,
    class_id INT,
    objective TEXT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES dbo.Classes(id) ON DELETE CASCADE
);
GO

IF OBJECT_ID('dbo.Curriculum', 'U') IS NULL
CREATE TABLE dbo.Curriculum (
    id INT IDENTITY(1,1) PRIMARY KEY,
    class_id INT,
    topic TEXT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES dbo.Classes(id) ON DELETE CASCADE
);
GO
