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
