-- Trigger para actualizar el stock de productos de despues
-- de insercion en la tabla de detallepedidos 

SELECT codigoproducto, nombre, cantidadenstock
from productos where codigoproducto = 'FR-4';

INSERT into DETALLEPEDIDOS VALUES(1, 'FR-4', 10, 10, 6);


create or replace trigger productos_actualizarr_stock
after insert on DETALLEPEDIDOS for each row 
declare 
begin 
    update productos
    set cantidadenstock = cantidadenstock - :new.cantidad
    where codigoproducto = : new.codigoproducto;
end;
/

