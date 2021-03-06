IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_filtro_metas' AND type = 'P')
	DROP PROCEDURE pa_listar_filtro_metas
GO
----------------------------------------------------------------------------------
-- Author: Giancarlos Sanginez IDE-SOLUTION
-- Created: 14/04/2020  
-- Sistema: web virgen del Carmen
-- Descripción: Consultar metas por filtros
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_filtro_metas]
(
 @codProveedor INT ,
 @codEstado INT ,
 @fechaInicio DATE = NULL,
 @fechaFin DATE = NULL
)
AS
SET NOCOUNT ON

BEGIN
	DECLARE @g_const_0 INT -- valor 0
	DECLARE @g_const_1 SMALLINT -- valor 1
	DECLARE @g_const_9 SMALLINT -- valor 9
	DECLARE @g_const_12 SMALLINT -- valor 9
	DECLARE @g_const_3000 SMALLINT -- valor 3000
	DECLARE @g_const_2000 SMALLINT -- valor 2000
	DECLARE @g_caracter CHAR(1)
	DECLARE @codigo INT -- Codigo 
	DECLARE @mensaje VARCHAR(100) -- mensaje
	DECLARE @estado SMALLINT -- 0:EXITO, 1:error interno
	DECLARE @g_codMeta INT -- Codigo de Meta
	DECLARE @g_codProveedor INT --Codigo de Proveedor
	DECLARE @g_codEstado INT -- 0: EN PROCESO, 1: EN PAUSA, 2: ANULADO
	DECLARE @g_fechaInicio DATE   -- Fecha de inicio de la meta
	DECLARE @g_fechaFin DATE  -- Fecha final de la meta
	DECLARE @g_descProveedor    VARCHAR(200) -- descripcion del proveedor
	DECLARE @g_descripcion    VARCHAR(200) --Descripcion de meta
	CREATE TABLE #listMeta 
		(codMeta INT, codProveedor INT,codEstado INT,fechaInicio DATE,fechaFin DATE,descProveedor VARCHAR(200),descripcion VARCHAR(200),
		 codigo INT,estado SMALLINT,mensaje VARCHAR(100)); --tabla temporal
BEGIN TRY
	SET @g_const_0 = 0;
	SET @g_const_1 = 1;
	SET @g_const_9 = 9;
	SET @g_const_12 = 12;
	SET @g_const_2000 = 2000;
	SET @g_const_3000 = 3000;
	SET @g_caracter = ''
	SET @mensaje = 'EXITO';
	SET @estado = 0;

	SET @g_codMeta = 0;
	SET @g_codProveedor = 0; 
	SET @g_codEstado = 0;
	SET @g_fechaInicio  = NULL;
	SET @g_fechaFin = NULL;
	SET @g_descProveedor = NULL;
	SET @g_descripcion = NULL;

	DECLARE qcur_metas CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		SELECT tblMeta.codMeta AS CodMeta, tblMeta.descripcion AS Descripcion, tblMeta.fechaInicio AS CodFechaini,
		tblMeta.fechaFin AS CodFechaFin
		FROM tblMeta 
		WHERE tblMeta.marcaBaja = 0 ;
	OPEN qcur_metas;
		FETCH NEXT FROM qcur_metas
		INTO @g_codMeta,@g_descripcion,@g_fechaInicio,@g_fechaFin; 
		WHILE @@FETCH_STATUS = @g_const_0
		BEGIN
			SELECT @g_descProveedor = descripcion FROM tblProveedor WHERE ntraProveedor = @g_codProveedor AND marcaBaja = @g_const_0;
			INSERT INTO #listMeta

			SELECT @g_codMeta,@g_codProveedor,@g_codEstado,@g_fechaInicio,@g_fechaFin,@g_descProveedor,@g_descripcion,@g_const_2000,@g_const_0,@mensaje
			SET @g_codMeta = NULL;

			FETCH NEXT FROM qcur_metas 
			INTO @g_codMeta,@g_descripcion,@g_fechaInicio,@g_fechaFin;   
		 END
	CLOSE qcur_metas;
	DEALLOCATE qcur_metas;	
	IF  @codProveedor = @g_const_0 AND @codEstado = @g_const_0 AND @fechaInicio IS NULL AND @fechaFin IS NULL
		BEGIN 
			SELECT codMeta,codProveedor,fechaInicio,fechaFin,descProveedor,descripcion,codigo,estado,mensaje
			FROM #listMeta ORDER BY codMeta DESC;		 
		END
	IF @codProveedor = @g_const_0 AND @codEstado = @g_const_0 AND @fechaInicio IS NOT NULL AND @fechaFin IS NOT NULL
		BEGIN 
			SELECT codMeta,codProveedor,fechaInicio,fechaFin,descProveedor,descripcion,codigo,estado,mensaje
			FROM #listMeta WHERE fechaInicio = @fechaInicio AND fechaFin = @fechaFin;
		END	
END TRY
BEGIN CATCH
	SET @codigo = @g_const_3000;
	SET @estado = @g_const_1;
	SET @mensaje = ERROR_MESSAGE();
	SELECT '' AS codmeta,@g_const_0 as codproveedor,@g_const_0 as codEstado,'' as descproveedor,'' as descripcion,
	@codigo as codigo, @estado as estado,@mensaje as mensaje
END CATCH
END