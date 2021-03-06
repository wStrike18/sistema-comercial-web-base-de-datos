
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_rutas_asignadas' AND type = 'P')
	DROP PROCEDURE pa_insertar_rutas_asignadas
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Insertar rutas asignadas
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_insertar_rutas_asignadas]
(
	@codUsuario INT,
	@codRuta INT,
	@codOrden INT,
	@diaSemana SMALLINT,
	@resultado INT OUTPUT
)

AS
	BEGIN
	DECLARE @contRuta INT
	DECLARE @codUser INT 

BEGIN TRY
	SET @contRuta = 0
		SELECT @contRuta = count(codRuta), @codUser = codUsuario  FROM tblRutasAsignadas WHERE codRuta = @codRuta and marcaBaja = 0
		GROUP BY codUsuario

		IF @contRuta = 0
			BEGIN
			INSERT INTO tblRutasAsignadas
			(codUsuario,codRuta,codOrden,diaSemana,usuario)
			VALUES (@codUsuario,@codRuta,@codOrden,@diaSemana,'evasquez');

			SELECT @resultado = 0
				
		END
		ELSE 
			BEGIN
			SELECT @resultado = @codUser
		 END
END TRY
BEGIN CATCH

		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
END CATCH

END