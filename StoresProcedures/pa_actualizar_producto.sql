IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_actualizar_producto' AND type = 'P')
DROP PROCEDURE pa_actualizar_producto
GO
---------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 30/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: 
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_actualizar_producto]
(	
	@p_descripcion VARCHAR(200), -- descripcion
	@p_codUndBaseVenta int,		 -- unidad base de venta
	@p_codCategoria int,		 -- codigo de categoria
	@p_codSubCat int,			 -- codigo de subcategoria
	@p_tipoProduc int,			 -- tipo de producto
	@p_flagVent smallint,		 -- flag de venta
	@p_codFabricante int,		 -- codigo de fabricante
	@p_proveedor int,			 --codigo de proveedor
	@p_codProd VARCHAR(10),		 -- codigo de producto
	@resultado INT OUTPUT
	
)
AS
BEGIN TRY	
		UPDATE tblProducto SET descripcion = @p_descripcion,codUnidadBaseventa=@p_codUndBaseVenta,
			codCategoria=@p_codCategoria,codSubcategoria= @p_codSubCat,tipoProducto=@p_tipoProduc,
			flagVenta=@p_flagVent, codFabricante=@p_codFabricante WHERE codProducto = @p_codProd
		
		UPDATE tblAbastecimento SET codProveedor=@p_proveedor WHERE codProducto=@p_codProd				
		SELECT @resultado=0;

END TRY
BEGIN CATCH
		SELECT @resultado=1
		SELECT  
			ERROR_NUMBER() AS NumeroDeError   
            ,ERROR_STATE() AS NumeroDeEstado    
            ,ERROR_LINE() AS  NumeroDeLinea  
            ,ERROR_MESSAGE() AS MensajeDeError;  
			
END CATCH
