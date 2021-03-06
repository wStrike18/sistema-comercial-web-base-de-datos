IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'fu_buscar_descripcion_concepto' AND type = 'FN')
	DROP FUNCTION fu_buscar_descripcion_concepto
GO
/****** Object:  UserDefinedFunction [dbo].[fu_buscar_descripcion_concepto]    Script Date: 20/01/2020 20:22:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Jonathan Macalupu S. IDE-SOLUTION
-- Created: 20/01/2020  
-- Sistema: Sistema Distribuidora Virgen del Carmen
-- Modulo: General
-- Descripción: Funcion que trae descripciones 
-----------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[fu_buscar_descripcion_concepto] 
(   @p_flag SMALLINT,   --Flag de proceso
	@p_codigo INT,      --Codigo de Concepto
	@p_correlativo INT  --Correlativo de Concepto
) RETURNS VARCHAR(250)
AS
BEGIN
   DECLARE @Valor_Retorno AS VARCHAR(250)  --Valor de la descripcion

   IF @p_flag = 1
	   SELECT @Valor_Retorno = descripcion 
	   FROM tblConcepto 
	   WHERE codConcepto = @p_codigo AND correlativo = @p_correlativo AND marcaBaja = 0;
   IF @p_flag = 2
	   SELECT @Valor_Retorno = descripcion
	   FROM tblRutas
	   WHERE ntraRutas = @p_codigo AND marcaBaja = 0;

   RETURN @Valor_Retorno
END