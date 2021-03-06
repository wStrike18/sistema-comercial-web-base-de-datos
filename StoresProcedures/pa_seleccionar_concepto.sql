USE [DB_virgendelcarmen]
GO
/****** Object:  StoredProcedure [dbo].[pa_listar_conceptos]    Script Date: 30/12/2019 12:54:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author:  Jonathan Macalupu S - IDE-SOLUTION
-- Created: 30/12/2019  
-- Sistema: WEB
-- Modulo: General
-- Descripción: Seleccionar concepto
-- Log Modificaciones: 
-- CODIGO    REQUERIMIENTO          NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[pa_listar_conceptos]
(
	@p_codigo INT,
	@p_estado INT
)	

AS
	BEGIN
	SET NOCOUNT ON
	    DECLARE @corr TINYINT -- correlativo del concepto
		DECLARE @desc VARCHAR(250) -- descripcion del concepto
	
		BEGIN TRY		

			SET @corr = 0;
			SET @desc = '';

			SELECT correlativo, descripcion FROM tblConcepto 
			WHERE codConcepto = @p_codigo AND estado = @p_estado AND correlativo > 0;
			
			--SET @estado_sel = 1
		    --SET @msje = 'SELECCION EXITOSA.'

			SELECT @corr as 'correlativo', @desc as 'descripcion'

		END TRY
		BEGIN CATCH
		    --SET @estado_sel = -1
			--SET @msje = ERROR_MESSAGE()
			SET @desc = ERROR_MESSAGE()

			SELECT @corr as 'correlativo', @desc as 'descripcion'

		END CATCH

END