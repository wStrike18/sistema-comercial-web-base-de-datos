
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_estado_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_actualizar_estado_rutas_asignadas
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Actualizar estado
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_estado_rutas_asignadas]
(
	
	@estado INT,
	@codRuta INT,
	@codUsuario INT,
	@resultado INT OUTPUT,
	@msje VARCHAR(250) OUTPUT,
	@codRutaResputa INT OUTPUT

)

AS
DECLARE @counestado INT
BEGIN
	SET NOCOUNT ON;	

	SET @msje = 'Exito';
	SET @codRutaResputa = @codRuta;
	SET @resultado = 0;
	SET @counestado = 0;

BEGIN TRY

			BEGIN TRANSACTION

			UPDATE  tblRutasAsignadas SET estado = @estado WHERE codRuta = @codRuta

			SELECT @counestado = COUNT(*) FROM tblRutasAsignadas WHERE estado = 0 and codUsuario = @codUsuario and marcaBaja = 0

			IF @counestado = 0
				BEGIN
				UPDATE tblRutasAsignadas SET estado = 0 WHERE  codUsuario = @codUsuario
			END 
			COMMIT TRANSACTION

			SELECT @resultado as resultado ,  @msje as msje, @codRutaResputa as codRuta			
	
END TRY
BEGIN CATCH
IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @resultado = ERROR_NUMBER();
		SET @msje = 'Error en pa_actualizar_estado_rutas_asignadas ' + ERROR_MESSAGE();
		SET @codRutaResputa = 0;
		SELECT @resultado as resultado , @msje as msje, @codRutaResputa as codRutaResputa
END CATCH

END