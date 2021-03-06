IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_meta' AND type = 'P')
DROP PROCEDURE pa_actualizar_meta
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 30/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: actualizacion de metas
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_meta]
(
	@p_descripcion VARCHAR(250), -- descripcion
	@p_fechInicio date,		     -- fecha inicio
	@p_fechFin date,		     --fecha fin
	@p_codMeta int,				 -- codigo de meta
	@resultado int OUTPUT
)
AS
BEGIN TRY
		
		UPDATE tblMeta SET descripcion=@p_descripcion,fechaInicio=@p_fechInicio,fechaFin=@p_fechFin
			WHERE codMeta = @p_codMeta;		
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

