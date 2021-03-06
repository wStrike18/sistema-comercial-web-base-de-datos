
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_buscar_usuario' AND type = 'P')
	DROP PROCEDURE pa_buscar_usuario
GO

/****** Object:  StoredProcedure [dbo].[pa_buscar_usuario]    Script Date: 30/03/2020 1:00:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Guivar Rimapa Joseph
-- Created: 25/03/2020
-- Sistema: VirgenDelCarmenMantenedor
-- Descripcion: buscar usuarios
-- Log Modificaciones:
-- 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_buscar_usuario]
(
	                                  
	@p_codUsuario		INT					= NULL,		--Numero de documento Persona
	@p_codEstado		INT					= NULL,		--
	@p_flagFiltro		SMALLINT
)
AS
BEGIN 
	SET NOCOUNT ON;
	BEGIN TRY
	IF @p_flagFiltro = 1
		BEGIN 
			SELECT *  FROM v_listar_usuario
			ORDER BY usuarioPersona 
		END 
	IF @p_flagFiltro = 2
		BEGIN 
			
			SELECT *  FROM v_listar_usuario
			WHERE	
				 (@p_codEstado		= 0 OR  @p_codEstado = codEstado)
			AND (@p_codUsuario		= 0 OR   @p_codUsuario = codPersona)
		END 
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() , 'Error en pa_buscar_usuario ' + ERROR_MESSAGE() 
	END CATCH
END 