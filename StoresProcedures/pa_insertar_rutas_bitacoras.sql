
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_rutas_bitacoras' AND type = 'P')
	DROP PROCEDURE pa_insertar_rutas_bitacoras
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
CREATE PROCEDURE [dbo].[pa_insertar_rutas_bitacoras]
(
	@codRuta INT,
	@codCliente VARCHAR(12),
	@fecha DATE,
	@visita SMALLINT,
	@motivo VARCHAR(500),
	@usuario VARCHAR(20),
	@ip VARCHAR(20),
	@mac VARCHAR(20),
	@cordenadaX VARCHAR(100),
	@cordenadaY VARCHAR (100),
	@estado SMALLINT,
	@resultado INT OUTPUT,
	@msje VARCHAR(250) OUTPUT,
	@codRutaResputa INT OUTPUT
)

AS
BEGIN
	SET NOCOUNT ON;	

	SET @msje = 'Exito';
	SET @codRutaResputa = @codRuta;
	SET @resultado = 0;

BEGIN TRY
	/*SET @contRuta = 0
		SELECT @contRuta = count(codRuta), @codUser = codUsuario  FROM tblRutasAsignadas WHERE codRuta = @codRuta and marcaBaja = 0
		GROUP BY codUsuario*/

		--IF @contRuta = 0
			--BEGIN
			BEGIN TRANSACTION
			INSERT INTO tblRutaBitacora
			(codRuta,codCliente,fecha,visita,motivo,marcaBaja,usuario,cordenadaX,cordenadaY,estado)
			VALUES (@codRuta,@codCliente,GETDATE(),@visita,@motivo,0,'11111111',@cordenadaX,@cordenadaY,0);
			COMMIT TRANSACTION

			SELECT @resultado as resultado ,  @msje as msje, @codRutaResputa as codRuta			
		/*END
		ELSE 
			BEGIN
			SELECT @resultado = @codUser
		 END*/
END TRY
BEGIN CATCH
IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @resultado = ERROR_NUMBER();
		SET @msje = 'Error en pa_insertar_rutas_bitacoras ' + ERROR_MESSAGE();
		SET @codRutaResputa = 0;
		SELECT @resultado as resultado , @msje as msje, @codRutaResputa as codRutaResputa
END CATCH

END