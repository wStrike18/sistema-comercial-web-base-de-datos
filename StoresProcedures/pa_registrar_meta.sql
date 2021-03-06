IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_meta' AND type = 'P')
DROP PROCEDURE pa_registrar_meta
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 30/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: registro de metas
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_registrar_meta
(
	@p_descripcion VARCHAR(250), -- descripcion
	@p_fechInicio date,		     -- fecha inicio
	@p_fechFin date,		     --fecha fin
	@p_usuario varchar(10),		 --usuario
	@resultado int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;	
		DECLARE @Proceso int;				    -- codigo proceso, en mejora de este pa
	
BEGIN TRY
	INSERT INTO tblMeta(descripcion, fechaInicio, fechaFin, usuario) values
					(@p_descripcion,@p_fechInicio,@p_fechFin,@p_usuario);		
	SELECT @resultado = 0
END TRY
	BEGIN CATCH
		SELECT @resultado = 1
		IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SELECT ERROR_NUMBER() as error, ERROR_MESSAGE() as MEN
	END CATCH
END
