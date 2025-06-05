-- Modifica el anterior pero solo ejecute si fechaentrega es mayor que la fechaesperada

UPDATE pedidos set fechaentrega = to_date('01/01/15') WHERE codigopedido = 1;

create or REPLACE TRIGGER t_actualizar_comentarios_pedidos
before update of fechaentrega on pedidos FOR EACH ROW

-- WHEN "CUANDO QUIERE QUE SE EJECUTE"
WHEN( NEW.fechaentrega IS NOT NULL AND NEW.fechaentrega > OLD.fechaesperada)
-- NO SE PUEDE HACER UN UPDATE EN UN TRIGGER
-- QUE TOMA TABLA A LA QUE SE LA HACE UPDATE
-- ERROR TABLA MUTADA
DECLARE
BEGIN
       :NEW.comentarios := :old.comentarios || ' pediddo entregado con retraso';
END;
/

-- modifica el trigger del video 11 el stock que vamos a modificar se quedo a cero o menor 
-- devolver una excepcion de ora

SELECT codigoproducto, nombre, cantidadenstock
from productos where codigoproducto = 'FR-4';

INSERT into DETALLEPEDIDOS VALUES(100, 'FR-40', 10000, 10, 6);


create or replace trigger productos_actualizarr_stock
BEFORE insert on DETALLEPEDIDOS for each row 
declare 
    v_stock_actual productos.cantidadenstock%type; 
begin 
    
    SELECT cantidadenstock into v_stock_actual
    FROM productos
    where codigoproducto = :new.codigoproducto;
    
    if v_stock_actual - :new.cantidad >0 then
        update productos
        set cantidadenstock = cantidadenstock - :new.cantidad
        where codigoproducto = : new.codigoproducto;
    else
        raise_application(-20001, 'No hay suficiente en el stock');
    end if;
end;
/


