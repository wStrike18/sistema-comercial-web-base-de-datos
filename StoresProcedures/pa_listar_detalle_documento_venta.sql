IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_detalle_documento_venta' AND type = 'P')
	DROP PROCEDURE pa_listar_detalle_documento_venta
GO
----------------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 24/03/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: listar detalle documento venta
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_detalle_documento_venta]   
(

--@p_codVendedor INTEGER,
@p_flagFiltro SMALLINT,
@p_fechaActual INT =  NULL ,
@p_estado SMALLINT =  NULL,
@p_cliente INT =  NULL,
@p_vendedor INT =  NULL,
@p_fechaInicial DATE =  NULL,
@p_fechaFinal DATE =  NULL,
@p_codTipoDoc INT = NULL,
@p_codFactura INT = NULL,
@p_serie  VARCHAR(20) = NULL,
@p_nroDocumento INT = NULL
)			
AS   
BEGIN
    IF @p_flagFiltro = 1
	BEGIN
		SELECT * FROM v_listar_detalle_documento_venta
		WHERE MONTH(fechaTransaccion) = @p_fechaActual and estadov = 1  
		ORDER BY fechaTransaccion DESC
	END

	IF @p_flagFiltro = 2
	BEGIN
		IF @p_fechaInicial != ''
		BEGIN
			SELECT * FROM v_listar_detalle_documento_venta
			WHERE
			(@p_estado = 0 OR @p_estado = estadov)
			AND (@p_cliente = 0 OR @p_cliente = codCliente)
			AND (@p_vendedor = 0 OR @p_vendedor = codVendedor)
			AND (@p_fechaInicial IS NULL OR fechaTransaccion >= @p_fechaInicial)
			AND (@p_fechaFinal IS NULL OR fechaTransaccion <= @p_fechaFinal)
			AND (@p_codTipoDoc = 0 OR @p_codTipoDoc = tipodocumento)
			AND (@p_codFactura = 0 OR ntraVenta = @p_codFactura)
			AND (@p_serie IS NULL or serie = @p_serie )
			AND (@p_nroDocumento = 0 or nroDocumento = @p_nroDocumento )
			ORDER BY fechaTransaccion DESC
		END
		ELSE
		BEGIN
			SELECT * FROM v_listar_detalle_documento_venta
			WHERE
			(@p_estado = 0 OR @p_estado = estadov)
			AND (@p_cliente = 0 OR @p_cliente = codCliente)
			AND (@p_vendedor = 0 OR @p_vendedor = codVendedor)
			AND (MONTH(fechaTransaccion) = @p_fechaActual)
			AND (@p_codTipoDoc = 0 OR @p_codTipoDoc = tipodocumento)
			AND (@p_codFactura = 0 OR ntraVenta = @p_codFactura)
			AND (@p_serie IS NULL or serie = @p_serie )
			AND (@p_nroDocumento = 0 or nroDocumento = @p_nroDocumento )
			ORDER BY fechaTransaccion DESC
		END

	END

END
GO


