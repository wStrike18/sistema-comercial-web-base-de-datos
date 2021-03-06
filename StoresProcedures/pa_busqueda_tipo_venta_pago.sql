IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_busqueda_tipo_venta_pago' AND type = 'P')
	DROP PROCEDURE pa_busqueda_tipo_venta_pago
GO
-----------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 24/03/2020  
-- Sistema: Web VirgenCarmenMantenedor
-- Descripción: buscar la venta segun su tipo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_busqueda_tipo_venta_pago]   
(

--@p_codVendedor INTEGER,
@p_flagFiltro SMALLINT,
@p_ntraVenta INT
)			
AS   
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		IF @p_flagFiltro = 1
		BEGIN
			select ntra, codOperacion ,importe, fechaCobro , c.estado as estado,  v.tipoCambio as tipoCambiov from tblCuentaCobro c
			INNER JOIN tblVenta v on c.codOperacion = v.ntraVenta
			where codModulo = 1 and prefijo = 1 and codOperacion = @p_ntraVenta  and c.estado = 1
		END

		/*IF @p_flagFiltro = 2
		BEGIN
			select ntraVenta as ntra , ntraVenta as codOperacion ,importeTotal as importe, fechaPago as fechaCobro , estado, tipoCambio as tipoCambiov from tblVenta 
			where ntraVenta =  @p_ntraVenta  and estado = 1
		END*/
	END TRY
	BEGIN CATCH
			SELECT ERROR_NUMBER() as 'codOperacion', 'pa_busqueda_tipo_venta_pago' + 
			ERROR_MESSAGE() as 'codOperacion', '' as 'importe', '' as 'fechaCobro', '' as 'estado'
	END CATCH
END
GO
	