-- crea una funcion a la que le pasaremos como parametros de entrada
-- MATRICULA NUEVOPRECIO_COMPRA .FUNCION MODIFICAR LOS DATOS EL COCHE 
-- QU TENGA LA MATRICULA INTRODUCIDA ACTUALIZANDO EL PRECIO_COMPRA DE LA 
-- SIGIENTE FORMA 

--- - SI  el precio_compra es nulo --> hacer un update en el campo precio_compra 
-- asignadole el valor precio compra 

--- - SI NO --> hacer un update en el campo precio_compra asinado el valor del pprecio_compra+
--(precio_compre-nuevo_)precio_compra

-- La funcion devilvera el numero de filas actualizadas 
-- crea un bloque anonimo que ejecute la funcion anterior y muestr el resultado devuelto por la funcion 


CREATE OR REPLACE FUNCTION F_AtualizarPrecioCoche(
    v_matricula coche.matricula%type,
    v_nuevo_precio_compra coche.PRECIO_COMPRA%TYPE)
RETURN NUMBER
AS
    v_precio_compra coche.PRECIO_COMPRA%TYPE;
BEGIN
    SELECT precio_compra INTO v_precio_compra
    FROM coche
    WHERE matricula = v_matricula;

    IF v_precio_compra IS NULL THEN 
        UPDATE coche
        SET precio_compra = v_nuevo_precio_compra
        WHERE matricula = v_matricula;
    ELSE 
        UPDATE coche
        SET precio_compra = precio_compra + (precio_compra - v_nuevo_precio_compra)
        WHERE matricula = v_matricula;
    END IF;
    
    RETURN SQL%ROWCOUNT;
END;
/

DECLARE
    v_matricula coche.matricula%type := &matricula;
    v_nuevo_precio_compra coche.precio_compra%type := &nuevo_precio;
    v_total_filas number(8);
BEGIN
    v_total_filas := f_atualizarpreciocoche(v_matricula, v_nuevo_precio_compra);
    dbms_output.put_line('Se han modificado' || v_total_filas || ' filas');

END;

