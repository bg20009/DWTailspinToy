create database DWTailspinToys;
go
use DWTailspinToys;
go

CREATE TABLE DimTiempo (
  FechaKey       INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- YYYYMMDD
  Fecha          DATE NOT NULL,
  Dia           TINYINT,
  Mes         TINYINT,
  Anio          SMALLINT,
);
go
CREATE TABLE DimEstado (
  EstadoKey       INT IDENTITY(1,1) PRIMARY KEY,
  EstadoID       INT, -- business key from source
  EstadoCodigo     NVARCHAR(2),
  EstadoNombre     NVARCHAR(50),
  NombreRegion NVARCHAR(100),
  FechaInicio DATE,
  FechaFin   DATE,
  Estado     BIT,
);
go
CREATE TABLE DimProductoFlag(
	ProductoFlagKey INT IDENTITY(1,1) PRIMARY KEY,
	ProductoCategoria NVARCHAR(50),
	ItemGroup NVARCHAR(50),
	TipoKit NVARCHAR(50),
	Demographic NVARCHAR(50),
	FechaInicial DATE,
	FechaFin DATE,
	Estado BIT,
);
go
CREATE TABLE [dbo].[DimProducto](
	[ProductoKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductoID] [int] NULL,
	[ProductoSKU] [nvarchar](50) NULL,
	[ProductoNombre] [nvarchar](200) NULL,
	[Canal] [tinyint] NULL,
	[PrecioRetail] [float] NULL,
	[ProductoFlagKey] [int] NULL,
	[FechaInicio] [date] NULL,
	[FechaFin] [date] NULL,
	[Estado] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductoKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DimProducto]  WITH CHECK ADD  CONSTRAINT [FK_DimProducto_DimProductoFlag] FOREIGN KEY([ProductoFlagKey])
REFERENCES [dbo].[DimProductoFlag] ([ProductoFlagKey])
GO

ALTER TABLE [dbo].[DimProducto] CHECK CONSTRAINT [FK_DimProducto_DimProductoFlag]
GO

go

CREATE TABLE [dbo].[FactVentas](
	[FactVentaKey] [bigint] IDENTITY(1,1) NOT NULL,
	[NumeroOrden] [nchar](10) NULL,
	[FechaOrdenKey] [int] NULL,
	[FechaEnvioKey] [int] NULL,
	[ProductoKey] [int] NULL,
	[ClienteEstadoKey] [int] NULL,
	[PromocionCode] [nchar](100) NULL,
	[Cantidad] [int] NULL,
	[PrecioUnitario] [decimal](9, 2) NULL,
	[Descuento] [decimal](9, 2) NULL,
	[Total] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[FactVentaKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FactVentas]  WITH NOCHECK ADD  CONSTRAINT [FK_FactVentas_DimEstado] FOREIGN KEY([ClienteEstadoKey])
REFERENCES [dbo].[DimEstado] ([EstadoKey])
GO

ALTER TABLE [dbo].[FactVentas] CHECK CONSTRAINT [FK_FactVentas_DimEstado]
GO

ALTER TABLE [dbo].[FactVentas]  WITH NOCHECK ADD  CONSTRAINT [FK_FactVentas_DimProducto] FOREIGN KEY([ProductoKey])
REFERENCES [dbo].[DimProducto] ([ProductoKey])
GO

ALTER TABLE [dbo].[FactVentas] CHECK CONSTRAINT [FK_FactVentas_DimProducto]
GO

ALTER TABLE [dbo].[FactVentas]  WITH NOCHECK ADD  CONSTRAINT [FK_FactVentas_DimTime_Envio] FOREIGN KEY([FechaEnvioKey])
REFERENCES [dbo].[DimTiempo] ([FechaKey])
GO

ALTER TABLE [dbo].[FactVentas] CHECK CONSTRAINT [FK_FactVentas_DimTime_Envio]
GO

ALTER TABLE [dbo].[FactVentas]  WITH NOCHECK ADD  CONSTRAINT [FK_FactVentas_FactVentas] FOREIGN KEY([FactVentaKey])
REFERENCES [dbo].[FactVentas] ([FactVentaKey])
GO

ALTER TABLE [dbo].[FactVentas] CHECK CONSTRAINT [FK_FactVentas_FactVentas]
GO

ALTER TABLE [dbo].[FactVentas]  WITH NOCHECK ADD  CONSTRAINT [FK_FactVentas_FactVentas_Orden] FOREIGN KEY([FechaOrdenKey])
REFERENCES [dbo].[DimTiempo] ([FechaKey])
GO

ALTER TABLE [dbo].[FactVentas] CHECK CONSTRAINT [FK_FactVentas_FactVentas_Orden]
GO

ALTER TABLE [dbo].[FactVentas]  WITH NOCHECK ADD  CONSTRAINT [FK_FactVentas_FactVentas1] FOREIGN KEY([FactVentaKey])
REFERENCES [dbo].[FactVentas] ([FactVentaKey])
GO

ALTER TABLE [dbo].[FactVentas] CHECK CONSTRAINT [FK_FactVentas_FactVentas1]
GO