
IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'fu_buscar_conceptos_generales' AND type = 'IF')
	DROP FUNCTION fu_buscar_conceptos_generales
GO
/****** Object:  UserDefinedFunction [dbo].[fu_buscar_conceptos_generales]    Script Date: 10/02/2020 10:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------------------------------------------------------------
-- Author: Luis Llatas IDE-SOLUTION
-- Created: 10/02/2020  
-- Sistema: WEB
-- Modulo: General
-- Descripción: buscar conceptos generales (todos) 
-----------------------------------------------------------------------------------

CREATE FUNCTION fu_buscar_conceptos_generales
 (@p_codigo INT)
 RETURNS TABLE
 AS
 RETURN (
 SELECT correlativo, descripcion FROM tblConcepto 
 WHERE codConcepto = @p_codigo AND marcaBaja = 0 AND correlativo > 0
 )