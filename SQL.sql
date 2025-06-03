-- HOLA MUNDO 

begin
    dbms_output.put_line('Hola mundo XD');
end;

-- -- decara una variable y mostart si es mayor o menor 
-- Siempre declar las variables primero p tantes de todo 


DECLARE
    sr_numero NUMBER(8) := 11;

begin

    if (sr_numero > 10) then
        dbms_output.put_line('el numero es mayor de 10');
    else
        dbms_output.put_line('el numero es menor de 10');    
    end if; 
end;


-- declara una variable numerica, pedir su valor y mostarlo
-- &numero cada ves que se podnga un aperson & sotara una ventana que pedira el valor 

DECLARE
    sr_numero NUMBER(8) := &numero;
begin
        dbms_output.put_line('el valor introducido es: ' || sr_numero);
end;

-- mostart los numeros del 1 al 100 con un while.


DECLARE
    sr_numero NUMBER(8) := &numero;

begin

    while (sr_numero<=10)
    loop
        dbms_output.put_line(sr_numero);
        sr_numero := sr_numero+1;
    end loop;
end;


-- mostart los numeros del 1 al 100 con un for.

begin

    for i in 1..10
    loop
        dbms_output.put_line(i);
    end loop;
end;


begin

    for i in reverse 1..10
    loop
        dbms_output.put_line(i);
    end loop;
end;

-- mostart los numeros del 1 al 100 con un loop.


declare
    i number(8) := 1;
    
begin

    loop
        dbms_output.put_line(i);
        i := i+1;
        exit when i=10;
    end loop;
end;



-- mustar el nombre de un cliente dado su codigo. 

select * from clientes;
declare
    v_codigo_cliente clientes.codigocliente%TYPE := &codigo;
    v_nombre_cliente clientes.nombrecliente%TYPE;
    
begin

    select nombrecliente into v_nombre_cliente
    from clientes
    WHERE codigocliente = v_codigo_cliente;
    
    dbms_output.put_line('el nombre es ' || v_nombre_cliente);

end;

-- mostar el precio veta y la gama de un producto dado su codigo.


declare 
    v_codigoproducto productos.codigoproducto%TYPE := 'P001';
    v_nombreproducto productos.nombre%TYPE;
    v_gamaProducto productos.gama%TYPE;
    
begin
    SELECT nombre, gama into v_nombreproducto, v_gamaproducto
    from productos
    where codigoproducto = v_codigoproducto;
    
        dbms_output.put_line('El nombre del producto es: ' || v_nombreproducto ||
        'su gama es: ' || v_gamaproducto );

end;


-- mostar toda la informacion de un pedido dado su codigo (fecha , entreaga fechapedido, estado,comentarios)


declare 
    v_codigopedido pedido.codigopedido%TYPE := &codigo;
    v_pedido pedido%rowtype;
begin
    SELECT * into v_pedido
    from pedido
    where codigopedido = v_codigopedido;
    
        dbms_output.put_line('El nombre del pedido es: ' || v_pedido.nombrepedido
        || 'La fecha pedido: ' || v_pedido.fechapedido
        || 'La fecha esperada: ' || v_pedido.fechaesperada
        || 'La fecha entrega: ' || v_pedido.fechaentrega
        || 'Estado: ' || v_pedido.estado
        || 'Comentarios: ' || v_pedido.comentarios
        );
end;


 