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

-- Tabla Cliente
CREATE TABLE clientes (
    codigocliente     NUMBER PRIMARY KEY,
    nombrecliente      VARCHAR2(100),
    nombrecontacto     VARCHAR2(100),
    apellidocliente    VARCHAR2(100),
    telefono           VARCHAR2(20),
    fax                VARCHAR2(20),
    lineadireccion     VARCHAR2(200)
);


INSERT INTO clientes (codigocliente, nombrecliente, nombrecontacto, apellidocliente, telefono, fax, lineadireccion) VALUES (1, 'Empresa Uno', 'Carlos', 'Pérez', '555-1234', '555-5678', 'Av. Principal 123');
INSERT INTO clientes (codigocliente, nombrecliente, nombrecontacto, apellidocliente, telefono, fax, lineadireccion) VALUES (2, 'Distribuciones Dos', 'Laura', 'Gómez', '555-2345', '555-6789', 'Calle 45 #67-89');
INSERT INTO clientes (codigocliente, nombrecliente, nombrecontacto, apellidocliente, telefono, fax, lineadireccion) VALUES (3, 'Importadora Tres', 'Miguel', 'Rodríguez', '555-3456', NULL, 'Carrera 8 #12-34');
INSERT INTO clientes (codigocliente, nombrecliente, nombrecontacto, apellidocliente, telefono, fax, lineadireccion) VALUES (4, 'Servicios Cuatro', 'Ana', 'Martínez', '555-4567', '555-7890', 'Av. Las Flores 50');


-- Tabla productos

CREATE TABLE productos (
    codigoproducto    VARCHAR2(15) PRIMARY KEY,
    nombre            VARCHAR2(100),
    gama              VARCHAR2(50),
    dimensiones       VARCHAR2(50),
    proveedor         VARCHAR2(100),
    descripcion       VARCHAR2(500)
);

INSERT INTO productos (codigoproducto, nombre, gama, dimensiones, proveedor, descripcion) VALUES
('P001', 'Silla Ejecutiva', 'Oficina', '60x60x110 cm', 'Muebles Global', 'Silla ergonómica con soporte lumbar y ruedas.');

INSERT INTO productos (codigoproducto, nombre, gama, dimensiones, proveedor, descripcion) VALUES
('P002', 'Escritorio Recto', 'Oficina', '120x60x75 cm', 'Maderas Alfa', 'Escritorio de melamina con estructura metálica.');

INSERT INTO productos (codigoproducto, nombre, gama, dimensiones, proveedor, descripcion) VALUES
('P003', 'Lámpara LED', 'Iluminación', '15x15x30 cm', 'LuzTech', 'Lámpara de escritorio con brazo flexible y 3 niveles de intensidad.');

INSERT INTO productos (codigoproducto, nombre, gama, dimensiones, proveedor, descripcion) VALUES
('P004', 'Archivador Metálico', 'Oficina', '45x60x75 cm', 'OfficeMax', 'Archivador de 3 cajones con cerradura.');

INSERT INTO productos (codigoproducto, nombre, gama, dimensiones, proveedor, descripcion) VALUES
('P005', 'Silla Visita', 'Recepción', '55x55x90 cm', 'Muebles Global', 'Silla acolchada con patas cromadas para áreas de espera.');

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