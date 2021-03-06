IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_insertar_usuario' AND type = 'P')
	DROP PROCEDURE pa_insertar_usuario
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Joseph Lenin G. IDE-SOLUTION
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Insertar usuario
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_insertar_usuario]	
(
@numDocumento VARCHAR(15),
				
	@p_nombres		VARCHAR(30),				
	@p_apePaterno	VARCHAR(20),			
	@p_apeMaterno	 VARCHAR(20),			
	@p_direccion	 VARCHAR(100),			
	@p_correo		VARCHAR(60),				
	@p_telefono		VARCHAR(15),
	@p_celular		CHAR(9),					
------------------------------------------------	
	@p_ubigeo		CHAR(6),
	@marcaBaja		 TINYINT,
	@fechProceso	date ,
	@horaProceso		time,
	----------------------------------------------------------------
	@p_usuario VARCHAR(20),				
	@p_ip VARCHAR(20),					
	@p_mac VARCHAR(20),
 ------------***************************-------------------------------------------------
	 --@p_codUsuario INTEGER,
	 @users  VARCHAR(20),
	 @codPerfil INT,
	 @codEstado TINYINT,
	 @codPersona INT,
	 @codSucursal int ,
	 @password varbinary

/*
	@p_usuario1 VARCHAR(20),				
	@p_ip1 VARCHAR(20),					
	@p_mac1 VARCHAR(20)		
*/	
)
AS
BEGIN
/*
		SET NOCOUNT ON;
		DECLARE @mensaje VARCHAR(100);		-- mensaje
		--DECLARE @flag INT;					--flag de proceso
		DECLARE @codPersona INT;			--codigo de persona
		
		--SET @flag = 0;
		SET @mensaje = 'CONSULTA EXITOSA';
		SET @codPersona = 0;
	*/	
		
	BEGIN TRY
	/*
		IF (@p_tipoPersona = 1 AND @p_tipoDocumento = 1)
			BEGIN
				SET @codPersona = @p_numDocumento;
			END

			*/
		--BEGIN TRANSACTION
			BEGIN

				INSERT INTO tblPersona (codPersona, tipoPersona, tipoDocumento, numeroDocumento, ruc, razonSocial, nombres, apellidoPaterno, 
				apellidoMaterno, direccion, correo, telefono, celular, codUbigeo, marcaBaja, usuario, ip, mac) 
				
				VALUES (@numDocumento, 1 , 1, @numDocumento, '', '', @p_nombres, @p_apePaterno, 
				@p_apeMaterno, @p_direccion,@p_correo,@p_telefono, @p_celular,'','' , 'jguivar', '210.163.32.12', 'BH:12:H5:2B') ;


				--INSERT INTO tblLocalizacion(codPersona,coordenadaX,coordenadaY,marcaBaja,usuario,ip,mac) 
				--VALUES(@codPersona,@p_coordenadaX,@p_coordenadaY,0, @p_usuario, @p_ip, @p_mac);
			/*
				@users 
				@codPerfil 
				@codEstado 
				@codPersona 
				@codSucursal
				@password 
			*/

				--INSERT INTO tblUsuario(ntraUsuario,users,codPersona , codPerfil, estado, marcaBaja, fechaProceso,horaProceso,horaProceso,usuario,ip,mac,password,codSucursal)
				--VALUES ('', @users , @codPerfil, @estado, @marcaBaja, @fechaProceso,@horaProceso,@password,@codSucursal);
			END



			Select * from tblUsuario
				--COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
	/*
	IF (XACT_STATE()) <> 0 
		BEGIN
			ROLLBACK TRANSACTION
		END
		SET @flag = ERROR_NUMBER();
		SET @mensaje = 'Error en pa_insertar_usuario ' + ERROR_MESSAGE();
		SET @codPersona = 0;
		
		SELECT @flag as flag , @mensaje as msje, @codPersona as codPersona
	END CATCH
	*/
	SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError; 
END CATCH
END

