IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_datos_select_x_flag' AND type = 'P')
	DROP PROCEDURE pa_listar_datos_select_x_flag
GO
----------------------------------------------------------------------------------
-- Author: WILSON IDE-SOLUTION
-- Created: 13/01/2020  
-- Sistema: ws_wa_DistribuidoraVDC
-- Descripción: Traer lista de datos por flag
-- Log Modificaciones: 
-- CODIGO        NOMBRE                    FECHA       MOTIVO  
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[pa_listar_datos_select_x_flag]   
( 
@flag integer    
)
AS   
BEGIN
    IF @flag = 1 
	SELECT u.ntraUsuario, CONCAT(p.nombres,' ', p.apellidoPaterno,' ',p.apellidoMaterno) as vendedor FROM tblUsuario u
    INNER JOIN tblPersona p on u.codPersona = p.codPersona
	INNER JOIN tblPerfil pe on u.codPerfil = pe.codigo
	WHERE p.marcaBaja = 0 AND u.marcaBaja = 0 and u.codPerfil = 1
	
	IF @flag = 2
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 2 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 3
		SELECT ntraRutas,descripcion,pseudonimo FROM tblRutas
		WHERE marcaBaja = 0;
	
	IF @flag = 4
	SELECT correlativo, descripcion FROM tblConcepto 
	WHERE codConcepto = 8 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 5
	begin
	SELECT ntraCategoria as correlativo,descripcion FROM tblCategoria WHERE marcaBaja = 0;
	end

	IF @flag = 6
	begin
	SELECT ntraSubcategoria as correlativo,descripcion FROM tblSubcategoria WHERE marcaBaja = 0;
	end

	IF @flag = 7
		SELECT codDepartamento, nombre FROM tblDepartamento WHERE marcaBaja = 0;

	IF @flag = 8
		SELECT codDepartamento, codProvincia, nombre FROM tblProvincia WHERE marcaBaja = 0;

	IF @flag = 9
		SELECT codDepartamento, codProvincia,  codDistrito, nombre FROM tblDistrito WHERE marcaBaja = 0;
	IF @flag = 10
    SELECT correlativo,descripcion FROM tblConcepto 
	WHERE codConcepto = 11 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 11
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 1 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 12
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 3 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 13
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 4 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 14
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 5 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 15
		SELECT correlativo, descripcion FROM tblConcepto 
		WHERE codConcepto = 7 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 16
		SELECT ntraRutas as correlativo, descripcion FROM tblRutas
		WHERE marcaBaja = 0;
	IF @flag = 17
	   select ntraAlmacen as correlativo,upper(descripcion) as descripcion from tblAlmacen where marcaBaja = 0;

	IF @flag = 18
		SELECT ntraSucursal,descripcion FROM tblSucursal WHERE marcaBaja = 0;
	
	IF @flag = 19 -- estados de la preventa
		SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 17 AND correlativo > 0 AND marcaBaja = 0;
	IF @flag = 20 -- origen de venta de la preventa
		SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 18 AND correlativo > 0 AND marcaBaja = 0;
	IF @flag = 21 -- tipo venta de la preventa
		SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 19 AND correlativo > 0 AND marcaBaja = 0;
	IF @flag = 22 -- tipo documento de la preventa
		SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 20 AND correlativo > 0 AND marcaBaja = 0;

	IF @flag = 23 --PROVEEDORES
		SELECT ntraProveedor, descripcion, abreviatura FROM tblProveedor WHERE marcaBaja = 0;

	IF @flag = 23 --DATOS DE LA PROMOCION
		SELECT ntraPromocion, descripcion, fechaInicial, fechaFin, horaInicial, horaFin FROM tblPromociones WHERE marcaBaja = 0;

	IF @flag = 24 -- Listar estado  usuarios

	SELECT correlativo, descripcion FROM tblConcepto WHERE codConcepto = 14 AND correlativo > 0 AND marcaBaja = 0;
			
	IF @flag = 25 -- TIPO DE VENTA
		SELECT ntraConcepto, codConcepto, correlativo, descripcion FROM tblConcepto where codConcepto = 19 and marcaBaja = 0

	IF @flag = 26 -- TIPO UNIDAD DE PRODUCTO 
		SELECT  correlativo, descripcion FROM tblConcepto where codConcepto = 12 and marcaBaja = 0 correlativo > 0

	IF @flag = 27 -- FABRICANTE
		SELECT  ntraFabricante, descripcion FROM tblFabricante where marcaBaja = 0

	IF @flag = 28 -- ESTADO DE PROMOCION
		SELECT ntraConcepto, codConcepto, correlativo, descripcion FROM tblConcepto where codConcepto = 24 AND correlativo >0 and marcaBaja = 0
	
	IF @flag = 29 -- TIPO DE PRUCTO 
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 23 and marcaBaja = 0 AND correlativo >0
	IF @flag = 30 -- ESTADOS DE FACTURA
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 28 and marcaBaja = 0 AND correlativo >0
		
	IF @flag = 31 -- MEDIOS DE PAGO
	SELECT ntraMedioPago as correlativo, descripcion FROM tblMediosDePago where  marcaBaja = 0

	IF @flag = 32 -- PERFILES DE USUARIOS
	SELECT codigo, descripcion FROM tblPerfil WHERE marcaBaja = 0

	IF @flag = 33 -- ESTADO DEL DESCUENTO
		SELECT correlativo as codigo, descripcion FROM tblConcepto where codConcepto = 30 and correlativo>0 and marcaBaja = 0
	
	IF @flag = 34 -- ESTADOS DE TRANSACCION DE PAGO
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 33 and correlativo>0 and marcaBaja = 0
		
	IF @flag = 35 -- TIPO DE INDICADOR DE OBJETIVO
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 35 and marcaBaja = 0 AND correlativo >0
	
	IF @flag = 36 -- FLAG DE METAS Y OBJETIVOS
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 36 and marcaBaja = 0 AND correlativo >0
	
	IF @flag = 37 -- TIPOS DE REGISTROS
		SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 39 and marcaBaja = 0 AND correlativo >0
	
	IF @flag = 38 -- ESTADOS DE CAJA
	SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 41 and marcaBaja = 0 AND correlativo >0
	IF @flag = 52 -- TIPO DE MONEDA
	SELECT correlativo, descripcion FROM tblConcepto where codConcepto = 21 and marcaBaja = 0 AND correlativo >0
END