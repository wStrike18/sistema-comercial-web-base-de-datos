
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_eliminar_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_eliminar_rutas_asignadas
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de datos por flag
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_eliminar_rutas_asignadas]
(
	@codUsuario INT,
	@codRuta INT,
	@resultado INT OUTPUT
)

AS
	BEGIN
		BEGIN TRY
			UPDATE tblRutasAsignadas SET marcaBaja = 9  WHERE codUsuario = @codUsuario and codRuta = @codRuta
			SELECT @resultado = @codUsuario			
		END TRY
		BEGIN CATCH
				SELECT  
					ERROR_NUMBER() AS NumeroDeError   
				   ,ERROR_STATE() AS NumeroDeEstado    
				   ,ERROR_LINE() AS  NumeroDeLinea  
				   ,ERROR_MESSAGE() AS MensajeDeError;  
		END CATCH
END