IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_busqueda_cronograma_prestamo' AND type = 'P')
	DROP PROCEDURE pa_busqueda_cronograma_prestamo
----------------------------------------------------------------------------------
-- Author: WilSON IDE-SOLUTION
-- Created: 16/04/2020  
-- Sistema: Web VirgenCarmenMantenedor
-- Descripción: buscar el cronograma de un prestamo
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_busqueda_cronograma_prestamo]   
(

--@p_codVendedor INTEGER,
@p_flagFiltro SMALLINT,			   -- flag de accion
@p_ntraVenta INT				    --codigo de venta
)			
AS   
BEGIN
	SET NOCOUNT ON;

	
	DECLARE @ntraPrestamo INT;
	BEGIN TRY
		IF @p_flagFiltro = 1
		BEGIN
			
			SELECT @ntraPrestamo = ntraPrestamo FROM tblPrestamo 
			WHERE codVenta = @p_ntraVenta;

			SELECT cr.codPrestamo as codPrestamo  ,cr.fechaPago as fechaPago,cr.nroCuota as nroCuota,cr.importe as importe,
			cr.estado as estado, c.descripcion	 as descestado FROM tblCronograma cr
			INNER JOIN tblConcepto c on c.correlativo = cr.estado 
			WHERE codPrestamo = @ntraPrestamo and c.codConcepto = 32 and c.correlativo != 0
			ORDER BY cr.nroCuota ASC
		END
	END TRY	
	BEGIN CATCH
			SELECT ERROR_NUMBER() as 'codOperacion', 'pa_busqueda_cronograma_prestamo' + 
			ERROR_MESSAGE() as 'codOperacion', '' as 'fechaPago', '' as 'nroCuota', '' as 'importe', ''  as 'estado','' 
	END CATCH
END
GO
