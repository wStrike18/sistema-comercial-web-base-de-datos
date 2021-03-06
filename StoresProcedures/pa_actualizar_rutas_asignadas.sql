
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_actualizar_rutas_asignadas
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
CREATE PROCEDURE [dbo].[pa_actualizar_rutas_asignadas]
(
	@codUsuario INT,
	@codRuta INT,
	@diaSemana INT,
	@codRutaAnterior INT,
	@resultado INT OUTPUT
)

AS
	BEGIN
	DECLARE @contRuta INT
	DECLARE @codUser INT 
	DECLARE @dia INT
	DECLARE @ruta INT 
	  
BEGIN TRY
		SET @contRuta = 0

		SELECT @contRuta = count(codRuta), @codUser = codUsuario , @dia = diaSemana, @ruta = codRuta FROM tblRutasAsignadas WHERE codRuta = @codRuta and marcaBaja = 0
		GROUP BY codUsuario, diaSemana, codRuta

		IF @contRuta = 0
		BEGIN
		UPDATE tblRutasAsignadas SET codRuta = @codRuta, diaSemana = @diaSemana WHERE codUsuario = @codUsuario and codRuta = @codRutaAnterior
		SELECT @resultado = 0
		END
		ELSE 
			BEGIN
			IF @contRuta > 0 AND @diaSemana <> @dia AND @codUsuario = @codUser AND @ruta = @codRutaAnterior
			BEGIN 
			UPDATE tblRutasAsignadas SET  diaSemana = @diaSemana WHERE codUsuario = @codUsuario and codRuta = @codRutaAnterior
			SELECT @resultado = 0
			END
			ELSE
			BEGIN 
			SELECT @resultado = @codUser
			END
			
		END 
		
END TRY
BEGIN CATCH
		SELECT @resultado = 0
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END