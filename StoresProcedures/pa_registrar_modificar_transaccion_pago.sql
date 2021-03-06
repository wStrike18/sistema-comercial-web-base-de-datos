IF  EXISTS (SELECT * FROM sys.objects WHERE name = 'pa_registrar_modificar_transaccion_pago' AND type = 'P')
	DROP PROCEDURE pa_registrar_modificar_transaccion_pago
----------------------------------------------------------------------------------
	-- Author: Wilson  Vasquez IDE-SOLUTION
	-- Created: 30/03/2020
	-- Sistema: ws_wa_DistribuidoraVDC
	-- Descripción: Registrar y modificar transaccion de pago
	-- Log Modificaciones:
	-- CODIGO NOMBRE FECHA MOTIVO
	-----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------
	CREATE PROCEDURE [dbo].[pa_registrar_modificar_transaccion_pago]
	(
		@p_flag TINYINT,					--proceso 1:registro 2:modificacion
		@p_codPrestamo INTEGER = NULL,		--codigo del prestamo
		@p_nroCuota INTEGER = NULL,			--numero de cuota
		@p_codVenta INTEGER,				--codigo de venta 
		@p_ntraMedioPago TINYINT,			--mediode pago
		@p_tipoCambio MONEY,				--tipo de cambio
		@p_tipoMoneda TINYINT,				--tipo  de moneda
		@p_igv MONEY,						--igv 
		@p_estado TINYINT,					--estado de transaccion
		@p_importe MONEY,					-- importe pagado
		@p_vuelto MONEY = NULL,					-- vuelto de lo pagado pagado
		@p_nroTransferencia VARCHAR(50) = NULL,     -- numero de transferencia.
		@p_cuentaTransferencia VARCHAR(100) = NULL, -- cuenta de transferencia
        @p_banco VARCHAR(100) = NULL,				-- banco
        @p_fechaTransferencia DATE = NULL,		-- fecha de transferencia
		@resultado INT OUTPUT				--resultado de la transaccion (codVenta)


	)
	AS
	BEGIN
		SET NOCOUNT ON;
		DECLARE @flag INT;			--flag de proceso
		DECLARE @msje VARCHAR(250);		--mensaje de error
		DECLARE @codVenta INT;		--codigo de persona
		DECLARE @ntraTP INT ;        --ntra de transaccion de pago
		DECLARE @count INT ;        --contador de estados de cuotas

		SET @flag = 0;
		SET @msje = 'Exito';
		SET @codVenta = 0;
		SET @ntraTP = 0;

	

			BEGIN TRY
			IF(@p_flag = 1)		--proceso registro
			BEGIN
				BEGIN TRANSACTION
					INSERT INTO tblTranssaccionesPago(codVenta, ntraMedioPago, 
					tipoCambio, tipoMoneda, IGV,estado,fechaTransaccion,horaTransaccion, usuario,ip, mac) 
					VALUES(@p_codVenta, @p_ntraMedioPago,
					@p_tipoCambio, @p_tipoMoneda, @p_igv,1,GETDATE(),SYSDATETIME(),'','','');

					SELECT TOP 1  @ntraTP = ntraTransaccionPago FROM tblTranssaccionesPago
					ORDER BY ntraTransaccionPago DESC;					 
	
					IF (@p_ntraMedioPago = 1)
					BEGIN
					INSERT INTO tblPagoEfectivo(ntraTransaccionPago,importe,vuelto,tipoMoneda,estado,usuario,ip,mac)
					VALUES(@ntraTP,@p_importe,@p_vuelto,@p_tipoMoneda,1,'','','')

					UPDATE tblCuentaCobro SET estado = @p_estado WHERE codOperacion = @p_codVenta and estado = 1

					--UPDATE tblVenta SET estado = @p_estado WHERE ntraVenta = @p_codVenta
					SELECT @resultado = @p_estado;
					END
					IF (@p_ntraMedioPago = 2)
					BEGIN
					INSERT INTO tblPagoTransferencia(ntraTransaccionPago,nroTransferencia,cuentaTransferencia,banco,importe,tipoMoneda,
					fechaTransferencia,estado,usuario,ip,mac)
					VALUES(@ntraTP,@p_nroTransferencia,@p_cuentaTransferencia,@p_banco,@p_importe,@p_tipoMoneda,
					@p_fechaTransferencia,1,'','','')

					UPDATE tblCuentaCobro SET estado = @p_estado WHERE codOperacion = @p_codVenta and estado = 1

					--UPDATE tblVenta SET estado = @p_estado WHERE ntraVenta = @p_codVenta

					SELECT @resultado = @p_estado;
					END
				COMMIT TRANSACTION
			END
			IF(@p_flag = 2)		--proceso registro
			BEGIN
				BEGIN TRANSACTION
				 	
					INSERT INTO tblTranssaccionesPago(codPrestamo,nroCuota,codVenta, ntraMedioPago, 
					tipoCambio, tipoMoneda, IGV,estado,fechaTransaccion,horaTransaccion, usuario,ip, mac) 
					VALUES(@p_codPrestamo,@p_nroCuota,@p_codVenta, @p_ntraMedioPago,
					@p_tipoCambio, @p_tipoMoneda, @p_igv,1,GETDATE(),SYSDATETIME(),'','','');

					SELECT TOP 1  @ntraTP = ntraTransaccionPago FROM tblTranssaccionesPago
					ORDER BY ntraTransaccionPago DESC;					 
	
					IF (@p_ntraMedioPago = 1)
					BEGIN
						INSERT INTO tblPagoEfectivo(ntraTransaccionPago,importe,vuelto,tipoMoneda,estado,usuario,ip,mac)
						VALUES(@ntraTP,@p_importe,@p_vuelto,@p_tipoMoneda,1,'','','')

						UPDATE tblCronograma SET estado = 2 WHERE codPrestamo = @p_codPrestamo and nroCuota = @p_nroCuota
						
						SELECT @count = COUNT(estado) FROM tblCronograma WHERE estado = 1 AND codPrestamo = @p_codPrestamo

						IF (@count = 0)
						BEGIN
							UPDATE tblPrestamo SET estado = 2 WHERE ntraPrestamo = @p_codPrestamo
							SELECT @resultado = @p_estado;
						END	
						ELSE
						BEGIN
							SELECT @resultado = 1;
						END
					END
					IF (@p_ntraMedioPago = 2)
					BEGIN
						INSERT INTO tblPagoTransferencia(ntraTransaccionPago,nroTransferencia,cuentaTransferencia,banco,importe,tipoMoneda,
						fechaTransferencia,estado,usuario,ip,mac)
						VALUES(@ntraTP,@p_nroTransferencia,@p_cuentaTransferencia,@p_banco,@p_importe,@p_tipoMoneda,
						@p_fechaTransferencia,1,'','','')

						UPDATE tblCronograma SET estado = 2 WHERE codPrestamo = @p_codPrestamo and nroCuota = @p_nroCuota
						
						SELECT @count = COUNT(estado) FROM tblCronograma WHERE estado = 1 AND codPrestamo = @p_codPrestamo

						IF (@count = 0)
						BEGIN
							UPDATE tblPrestamo SET estado = 2 WHERE ntraPrestamo = @p_codPrestamo
							SELECT @resultado = @p_estado;
						END	
						ELSE
						BEGIN
							SELECT @resultado = 1;
						END
					END
				COMMIT TRANSACTION
			END
			
		END TRY
		BEGIN CATCH
			IF (XACT_STATE()) <> 0 
			BEGIN
				ROLLBACK TRANSACTION
			END
			SET @flag = ERROR_NUMBER();
			SET @msje = 'Error en pa_registrar_modificar_transaccion_pago ' + ERROR_MESSAGE();
			SET @codVenta = 0;
			SELECT @flag as flag , @msje as msje, @codVenta as codVenta
		END CATCH
	END
	GO
