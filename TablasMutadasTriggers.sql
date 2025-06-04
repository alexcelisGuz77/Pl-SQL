-- Crear un trigger que al actualizar la colupna fechaentrega 
-- de pedidos la compare con la fechaespera
--   -- Si fechaentrega es menor que fechaespera añadir a los comentarios
--      'Pedido entregado antes de lo espaerado'
--   -- si fechaentrega es mayor que fechaespera añadir a los comentarios 
--      'Pedido entregado con retrazo'


UPDATE pedidos set fechaentrega = to_date('01/01/15') WHERE codigopedido = 1;

create or REPLACE TRIGGER t_actualizar_comentarios_pedidos
before update of fechaentrega on pedidos FOR EACH ROW

-- NO SE PUEDE HACER UN UPDATE EN UN TRIGGER
-- QUE TOMA TABLA A LA QUE SE LA HACE UPDATE
-- ERROR TABLA MUTADA
DECLARE
BEGIN
    IF :NEW.fechaentrega is not null THEN
    IF :NEW.fechaentrega > :old.fechaesperada then 
       :NEW.comentarios := :old.comentarios || ' pediddo entregado con retraso';
    else 
       :NEW.comentarios := :old.comentarios || ' pedido entregado antes de los esperado';
    end if;
    end if;
END;
/

