IF EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_listar_filtros_product' AND type = 'P')
DROP PROCEDURE pa_listar_filtros_product
GO
----------------------------------------------------------------------------------
-- Author: Dany Gelacio -IDE SOLUTION
-- Created: 19/03/2020
-- Sistema: web virgen del Carmen
-- Descripcion: Filtros de producto
-- Log Modificaciones:
-- CODIGO NOMBRE FECHA MOTIVO
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
CREATE PROCEDURE pa_listar_filtros_product
(
 @codCategoria INT, 
 @codSubcategoria INT,
 @codProveedor INT,
 @codFabricante INT,
 @descripcion VARCHAR(200)
 )
AS
SET NOCOUNT ON

BEGIN

        DECLARE @g_const_0 INT				       -- valor 0
		DECLARE @g_const_1 SMALLINT			       -- valor 1
		DECLARE @g_const_9 SMALLINT			       -- valor 9
		DECLARE @g_const_12 SMALLINT               -- valor 12
		DECLARE @g_const_23 SMALLINT               -- valor 23
		DECLARE @g_const_3000 SMALLINT             -- valor 3000
		DECLARE @g_const_2000 SMALLINT             -- valor 2000
		DECLARE @g_caracter CHAR(1)			      
		DECLARE @codigo INT                        -- Codigo 
		DECLARE @mensaje VARCHAR(250)              -- mensaje
		DECLARE @estado SMALLINT                   -- 0:EXITO, 1:error interno
        DECLARE @g_descCategoria    VARCHAR(200)   -- descripcion de categoria
		DECLARE @g_descSubcategoria VARCHAR(200)   -- descripcion de subcategoria
		DECLARE @g_descProveedor    VARCHAR(200)   -- descripcion de proveedor
		DECLARE @g_descFabricante   VARCHAR(200)   -- descripcion de fabricante
		DECLARE @g_descUnidadBase   VARCHAR(50)    -- descripcion de unidad base
		DECLARE @g_undbase         INT             --Codigo de Unidad Base
		DECLARE @g_tipoProducto SMALLINT           --codigo tipo de producto (1:venta, 2:promocion)
		DECLARE @g_desctipoProduct VARCHAR(200)    -- Descripcion tipo de producto de tabla concepto
		DECLARE @g_flagVenta SMALLINT              --flag de venta 1: venta, 0:agregado
		DECLARE @g_codproducto     VARCHAR(10)     --Codigo de producto
		DECLARE @g_codcategoria    INT             --Codigo de categoria
		DECLARE @g_codsubcategoria INT             --Codigo de sub categoria
		DECLARE @g_codProveedor    INT             --Codigo de Proveedor
		DECLARE @g_codFabricante   INT             --Codigo de Fabricante
		DECLARE @g_descripcion    VARCHAR(200)      --Descripcion de producto
				

		CREATE TABLE #listProducto 
		(codProducto VARCHAR(10),codCategoria INT,descCategoria VARCHAR(200),codSubcategoria INT,descSubcategoria VARCHAR(200),
		                            codProveedor INT,descProveedor VARCHAR(200),codFabricante INT,descFabricante VARCHAR(200),descripcion VARCHAR(200),
									descUnidadBase VARCHAR(50),tipoProducto SMALLINT, desctipoProducto VARCHAR(200),flagVenta SMALLINT) --tabla temporal
								
																		
BEGIN TRY      
           SET @g_const_0 = 0;
		   SET @g_const_1 = 1;
		   SET @g_const_9 = 9;
		   SET @g_const_12 = 12;
		   SET @g_const_23 = 23;
		   SET @g_const_2000 = 2000;
		   SET @g_const_3000 = 3000;

		   SET @g_caracter = ''		
		   SET @g_descCategoria = NULL;
		   SET @g_descSubcategoria = NULL;
		   SET @g_descProveedor = NULL;
		   SET @g_descFabricante = NULL;
		   SET @g_descUnidadBase = NULL;
		   SET @g_undbase = 0;
		   SET @g_tipoProducto = 0;
		   SET @g_desctipoProduct = NULL;
		   SET @g_flagVenta = 1;
		   SET @g_codproducto = 0;
		   SET @g_codcategoria = 0;
		   SET @g_codsubcategoria = 0;
		   SET @g_codProveedor = 0;
		   SET @g_codFabricante = 0;
		   SET @g_descripcion = NULL;	 


DECLARE qcur_productos CURSOR LOCAL STATIC READ_ONLY FORWARD_ONLY FOR 
		 SELECT tblProducto.codProducto AS Codproducto,
          tblProducto.codCategoria      AS Codcategoria,
		  tblProducto.codSubcategoria   AS Codsubcategoria,		
		  tblAbastecimento.codProveedor AS CodProveedor,		
		  tblProducto.codFabricante     AS CodFabricante,
		  tblProducto.descripcion       AS descProducto,		  
		  tblProducto.codUnidadBaseventa AS undBase,
		  tblProducto.tipoProducto AS tipoProducto,		  
		  tblProducto.flagVenta AS flagVenta
		  from tblProducto INNER JOIN tblAbastecimento on tblAbastecimento.codProducto=tblProducto.codProducto 
		  where tblProducto.marcaBaja = @g_const_0 ;

		
OPEN qcur_productos;  
 FETCH NEXT FROM qcur_productos 
 INTO @g_codproducto,@g_codcategoria,@g_codsubcategoria,@g_codProveedor,@g_codFabricante,@g_descripcion,@g_undbase, @g_tipoProducto,@g_flagVenta;
 WHILE @@FETCH_STATUS = @g_const_0  
	BEGIN
		SELECT @g_descCategoria = descripcion FROM tblCategoria WHERE ntraCategoria = @g_codcategoria AND marcaBaja = @g_const_0;
		SELECT @g_descSubcategoria = descripcion FROM tblSubcategoria WHERE ntraSubcategoria = @g_codsubcategoria AND marcaBaja = @g_const_0;
		SELECT @g_descProveedor = descripcion  FROM tblProveedor INNER JOIN tblAbastecimento on codProveedor=ntraProveedor WHERE codProveedor = @g_codProveedor AND tblAbastecimento.marcaBaja = @g_const_0; --(@#)1-A
		SELECT @g_descFabricante = descripcion FROM tblFabricante WHERE ntraFabricante = @g_codFabricante AND marcaBaja = @g_const_0;	
	 	SELECT @g_descUnidadBase = descripcion FROM tblConcepto WHERE codConcepto = @g_const_12 AND correlativo = @g_undbase; 
		SELECT @g_desctipoProduct = descripcion FROM tblConcepto WHERE codConcepto = @g_const_23 AND correlativo = @g_tipoProducto; 
	
		
		INSERT INTO #listProducto
		SELECT @g_codproducto,@g_codcategoria,@g_descCategoria,@g_codsubcategoria,@g_descSubcategoria,@g_codProveedor,@g_descProveedor,
		@g_codFabricante,@g_descFabricante,@g_descripcion,@g_descUnidadBase, @g_tipoProducto,@g_desctipoProduct,@g_flagVenta
		
		SET @g_codproducto = NULL;
		
		FETCH NEXT FROM qcur_productos 
		INTO @g_codproducto,@g_codcategoria,@g_codsubcategoria,@g_codProveedor,@g_codFabricante,@g_descripcion,@g_undbase, @g_tipoProducto,@g_flagVenta;   
	 END
 CLOSE qcur_productos;  
 DEALLOCATE qcur_productos;	
	 	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN 
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,descFabricante,
		descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
	
		FROM #listProducto;		 
		END	
	 
	 IF @codCategoria > @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN 
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor
		,codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria = @codCategoria;		 
		END		
	 IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria = @codSubcategoria; 
		END
	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codProveedor=@codProveedor;
		 END
	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codFabricante=@codFabricante;
	    END
    IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,
		descProveedor,codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE descripcion LIKE '%' + TRIM(@descripcion) + '%';
			END
		
	IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria AND codSubcategoria=@codSubcategoria;
		
		END
	IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,
		descProveedor,codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria=@codSubcategoria  AND codProveedor=@codProveedor;
		END
    IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codProveedor=@codProveedor AND codFabricante=@codFabricante;
		END
    IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codFabricante=@codFabricante  AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END
    IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor<> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto	 WHERE codCategoria=@codCategoria AND codProveedor=@codProveedor;
		 END
	IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor= @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto	 WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante;
		END
	IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria = @codCategoria AND descripcion LIKE '%' + TRIM(@descripcion) + '%';			
		END 
	IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN

		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria= @codSubcategoria AND codFabricante= @codFabricante;
		END
	IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN		
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria= @codSubcategoria AND descripcion LIKE '%' + TRIM(@descripcion) + '%';			
		END
	 IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN	
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codProveedor=@codProveedor AND descripcion LIKE '%' + TRIM(@descripcion) + '%';	
		END
	IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante = @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN		
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria AND codSubcategoria=@codSubcategoria AND codProveedor=@codProveedor;		
		END
    IF @codCategoria = @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN 
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codSubcategoria=@codSubcategoria AND codProveedor=@codProveedor AND codFabricante=@codFabricante;	
		END
	IF @codCategoria = @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN	
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codProveedor=@codProveedor AND codFabricante=@codFabricante AND descripcion LIKE '%' + TRIM(@descripcion) + '%';	
		END	
   IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria AND codProveedor= @codProveedor AND codFabricante=@codFabricante;	
		END
 IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor= @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END

 IF @codCategoria <> @g_const_0 AND @codSubcategoria = @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codProveedor=@codProveedor  AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END

 IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor = @g_const_0
		AND @codFabricante <> @g_const_0 AND  (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
	
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codSubcategoria=@codSubcategoria;
		END
   IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND  (LEN(TRIM(@descripcion)) = @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,
		codFabricante,descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
	
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codSubcategoria=@codSubcategoria AND  codProveedor=@codProveedor ;
		END
   IF @codCategoria <> @g_const_0 AND @codSubcategoria <> @g_const_0 AND @codProveedor <> @g_const_0
		AND @codFabricante <> @g_const_0 AND  (LEN(TRIM(@descripcion)) <> @g_const_0)
		BEGIN
		SELECT codProducto,codCategoria,descCategoria,codSubcategoria,descSubcategoria,codProveedor,descProveedor,codFabricante,
		descFabricante,descripcion,descUnidadBase,tipoProducto,desctipoProducto, flagVenta
		
		FROM #listProducto WHERE codCategoria=@codCategoria  AND codFabricante=@codFabricante AND codSubcategoria=@codSubcategoria AND  codProveedor=@codProveedor 
		AND descripcion LIKE '%' + TRIM(@descripcion) + '%';
		END

		
END TRY
BEGIN CATCH
                SET @codigo = @g_const_3000;
				SET @estado = @g_const_1;
				SET @mensaje = ERROR_MESSAGE();
			SELECT '' AS codproducto,@g_const_0 as codCategoria,'' as descCategoria,@g_const_0 as codSubcategoria,'' as descSubcategoria,@g_const_0 as codProveedor,'' as descProveedor,
			@g_const_0 as codFabricante,'' as descFabricante,'' as descripcion, '' as descUnidadBase, @g_const_0 as tipoProducto,' ' as desctipoProducto,@g_const_0 as flagVenta
			
END CATCH
END
