
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_clientes' AND type = 'P')
	DROP PROCEDURE pa_listar_clientes
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 06/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Listar clientes 
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_clientes]	
(
	@p_tipoDocumento INT,			-- Tipo de docuemento
	@p_numDocumento VARCHAR(15),    -- Numero de docuemento
	@p_nombres VARCHAR(70)          -- Nombres del cliente
)

AS
	BEGIN
	SET NOCOUNT ON
		DECLARE @cod INT					-- codigo persona
		DECLARE @tper TINYINT				-- tipo persona
		DECLARE @tdoc TINYINT				-- tipo de documento
		DECLARE @ndoc VARCHAR(15)			-- numero de documento
		DECLARE @ruc VARCHAR(15)			-- ruc
		DECLARE @rSocial varchar(50)		-- razon social
		DECLARE @nomb VARCHAR(30)			-- nombres
		DECLARE @apellPaterno VARCHAR(20)	-- apellido Paterno
		DECLARE @apellMaterno VARCHAR(20)	-- apellido Materno
		DECLARE @direccion VARCHAR(100)		-- direccion
		DECLARE @correo VARCHAR(60)			-- correo
		DECLARE @telefono VARCHAR(15)		-- telefono
		DECLARE @celular CHAR(9)			-- celular
		DECLARE @perfil TINYINT				-- perfil de cliente
		DECLARE @clasificacion TINYINT		-- clasificacion de cliente
		DECLARE @frecuencia TINYINT			-- frecuencia de cliente
		DECLARE @tipolistaPrecio TINYINT	-- Tipo Lista precio del cliente
		DECLARE @codRuta INT				-- Codigo de Ruta del Cliente
		DECLARE @ordenAtencion SMALLINT		-- Orden de atencion de cliente
		DECLARE @ubigeoDomicilio CHAR(6);	-- Ubigeo Domicilio Fiscal
		DECLARE @coordenadaX VARCHAR(100)   -- CoordenadaX
		DECLARE @coordenadaY VARCHAR(100)   -- CoordenadaY

		DECLARE @flag INT;					-- flag de proceso
		DECLARE @msje VARCHAR(250);			-- mensaje de error
	
		BEGIN TRY		

			SET @cod = 0
			SET @tper = 0  
			SET @tdoc = 0 
			SET @ndoc = '' 
			SET @ruc = '' 
			SET @rSocial = '' 
			SET @nomb = '' 
			SET @apellPaterno = '' 
			SET @apellMaterno = '' 
			SET @direccion = '' 
			SET @correo = '' 
			SET @telefono = '' 
			SET @celular = ''
			SET @perfil = 0
			SET @clasificacion = 0
			SET @frecuencia = 0
			SET @tipolistaPrecio = 0
			SET @codRuta = 0
			SET @ordenAtencion = 0
			SET @ubigeoDomicilio = ''
			SET @flag = 0;
			SET @msje = 'Exito';
			
			IF @p_tipoDocumento = 0 AND @p_numDocumento = '' AND @p_nombres = '' 
			BEGIN
				SELECT p.codPersona, p.tipoPersona, p.tipoDocumento, p.numeroDocumento, p.ruc, p.razonSocial,
				p.nombres, p.apellidoPaterno, p.apellidoMaterno, p.direccion, p.correo, p.telefono, p.celular,
				c.perfilCliente, c.clasificacionCliente, c.frecuenciaCliente, c.tipoListaPrecio, c.codRuta,
				c.ordenAtencion, p.codUbigeo,l.coordenadaX, l.coordenadaY
				FROM tblPersona p INNER JOIN tblCliente c ON p.codPersona = c.codPersona
				INNER JOIN tblLocalizacion l on c.codPersona = l.codPersona
				WHERE p.marcaBaja = 0 AND c.marcaBaja = 0
				ORDER BY c.fechaProceso DESC, c.horaProceso DESC;
			END
			IF @p_numDocumento != '' AND @p_tipoDocumento != 0
			BEGIN	
				SELECT p.codPersona, p.tipoPersona, p.tipoDocumento, p.numeroDocumento, p.ruc, p.razonSocial,
				p.nombres, p.apellidoPaterno, p.apellidoMaterno, p.direccion, p.correo, p.telefono, p.celular,
				c.perfilCliente, c.clasificacionCliente, c.frecuenciaCliente, c.tipoListaPrecio, c.codRuta,
				c.ordenAtencion, p.codUbigeo,l.coordenadaX, l.coordenadaY
				FROM tblPersona p 
				INNER JOIN tblCliente c ON p.codPersona = c.codPersona
				INNER JOIN tblLocalizacion l on c.codPersona = l.codPersona
				WHERE P.tipoDocumento = @p_tipoDocumento AND (p.numeroDocumento = @p_numDocumento OR p.ruc = @p_numDocumento)
				AND p.marcaBaja = 0 AND c.marcaBaja = 0;
			END
			IF @p_nombres != '' AND @p_tipoDocumento = 0
			BEGIN
				SELECT codPersona, tipoPersona, tipoDocumento, numeroDocumento, ruc, razonSocial,
				nombres, apellidoPaterno, apellidoMaterno, direccion, correo, telefono, celular,
				perfilCliente, clasificacionCliente, frecuenciaCliente, tipoListaPrecio, codRuta,
				ordenAtencion, codUbigeo, coordenadaX, coordenadaY
				FROM v_listar_clientes
				WHERE nombreCompleto LIKE '%' + @p_nombres + '%' OR razonSocial LIKE '%' + @p_nombres + '%';
			END	

			SELECT @cod as 'p.codPersona', @tper as 'p.tipoPersona', @perfil as 'c.perfilCliente', @tdoc as 'p.tipoDocumento', @ndoc as 'p.numeroDocumento', @ruc as 'p.ruc', 
			@rSocial as 'p.razonSocial', @nomb as 'p.nombres', @apellPaterno as 'p.apellidoPaterno', @apellMaterno as 'apellidoMaterno',
			@direccion as 'p.direccion', @correo as 'p.correo', @telefono as 'p.telefono', @celular as 'p.celular',
			@perfil as 'c.perfilCliente', @clasificacion as 'clasificacionCliente', @frecuencia as 'c.frecuenciaCliente', @tipolistaPrecio as 'c.tipoListaPrecio',
			@codRuta as 'c.codRuta', @ordenAtencion as 'c.ordenAtencion', @ubigeoDomicilio as 'p.codUbigeo',@coordenadaX as 'l.coordenadaX', @coordenadaX as 'l.coordenadaY',@flag as 'flag' , @msje as 'msje'

		END TRY
		BEGIN CATCH

			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_listar_clientes ' + ERROR_MESSAGE();

			SELECT @cod as 'p.codPersona', @tper as 'p.tipoPersona', @perfil as 'c.perfilCliente', @tdoc as 'p.tipoDocumento', @ndoc as 'p.numeroDocumento', @ruc as 'p.ruc', 
			@rSocial as 'p.razonSocial', @nomb as 'p.nombres', @apellPaterno as 'p.apellidoPaterno', @apellMaterno as 'apellidoMaterno',
			@direccion as 'p.direccion', @correo as 'p.correo', @telefono as 'p.telefono', @celular as 'p.celular',
			@perfil as 'c.perfilCliente', @clasificacion as 'clasificacionCliente', @frecuencia as 'c.frecuenciaCliente', @tipolistaPrecio as 'c.tipoListaPrecio',
			@codRuta as 'c.codRuta', @ordenAtencion as 'c.ordenAtencion', @ubigeoDomicilio as 'p.codUbigeo',@coordenadaX as 'l.coordenadaX', @coordenadaY as 'l.coordenadaY', @flag as 'flag' , @msje as 'msje'

		END CATCH

END
GO