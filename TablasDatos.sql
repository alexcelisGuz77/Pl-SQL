

-- Borro tablas si existen para evitar errores al crear
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE pedido CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE productos CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE clientes CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE detallePedido CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

-- Crear tabla clientes
CREATE TABLE clientes (
    codigocliente     NUMBER PRIMARY KEY,
    nombrecliente      VARCHAR2(100),
    nombrecontacto     VARCHAR2(100),
    apellidocliente    VARCHAR2(100),
    telefono           VARCHAR2(20),
    fax                VARCHAR2(20),
    lineadireccion     VARCHAR2(200)
);

-- Insertar datos clientes
INSERT INTO clientes (codigocliente, nombrecliente, nombrecontacto, apellidocliente, telefono, fax, lineadireccion) VALUES
(1, 'Empresa Uno', 'Carlos', 'Pérez', '555-1234', '555-5678', 'Av. Principal 123'),
(2, 'Distribuciones Dos', 'Laura', 'Gómez', '555-2345', '555-6789', 'Calle 45 #67-89'),
(3, 'Importadora Tres', 'Miguel', 'Rodríguez', '555-3456', NULL, 'Carrera 8 #12-34'),
(4, 'Servicios Cuatro', 'Ana', 'Martínez', '555-4567', '555-7890', 'Av. Las Flores 50');

COMMIT;

-- Crear tabla productos
CREATE TABLE productos (
    codigoproducto    VARCHAR2(15) PRIMARY KEY,
    nombre            VARCHAR2(100),
    gama              VARCHAR2(50),
    dimensiones       VARCHAR2(50),
    proveedor         VARCHAR2(100),
    descripcion       VARCHAR2(500)
);

-- Insertar datos productos
INSERT INTO productos (codigoproducto, nombre, gama, dimensiones, proveedor, descripcion) VALUES
('P001', 'Silla Ejecutiva', 'Oficina', '60x60x110 cm', 'Muebles Global', 'Silla ergonómica con soporte lumbar y ruedas.'),
('P002', 'Escritorio Recto', 'Oficina', '120x60x75 cm', 'Maderas Alfa', 'Escritorio de melamina con estructura metálica.'),
('P003', 'Lámpara LED', 'Iluminación', '15x15x30 cm', 'LuzTech', 'Lámpara de escritorio con brazo flexible y 3 niveles de intensidad.'),
('P004', 'Archivador Metálico', 'Oficina', '45x60x75 cm', 'OfficeMax', 'Archivador de 3 cajones con cerradura.'),
('P005', 'Silla Visita', 'Recepción', '55x55x90 cm', 'Muebles Global', 'Silla acolchada con patas cromadas para áreas de espera.');

COMMIT;

-- Crear tabla pedido
CREATE TABLE pedido (
    codigopedido     NUMBER PRIMARY KEY,
    nombrepedido     VARCHAR2(100),
    telefono         VARCHAR2(20),
    fax              VARCHAR2(20),
    lineadireccion   VARCHAR2(200),
    fechapedido      DATE,
    fechaesperada    DATE,
    fechaentrega     DATE,
    estado           VARCHAR2(50),
    comentarios      VARCHAR2(4000)
);

-- Insertar datos pedido
INSERT INTO pedido VALUES
(1, 'Pedido A', '555-1234', '555-4321', 'Calle 123, Ciudad', TO_DATE('2025-06-01', 'YYYY-MM-DD'), TO_DATE('2025-06-10', 'YYYY-MM-DD'), TO_DATE('2025-06-09', 'YYYY-MM-DD'), 'Enviado', 'Primera orden de pedido.'),
(2, 'Pedido B', '555-5678', NULL, 'Av. Central 456, Ciudad', TO_DATE('2025-06-02', 'YYYY-MM-DD'), TO_DATE('2025-06-12', 'YYYY-MM-DD'), NULL, 'Pendiente', 'Pedido urgente.'),
(3, 'Pedido C', '555-8765', '555-8765', 'Boulevard 789, Ciudad', TO_DATE('2025-06-03', 'YYYY-MM-DD'), TO_DATE('2025-06-13', 'YYYY-MM-DD'), TO_DATE('2025-06-15', 'YYYY-MM-DD'), 'Entregado', NULL),
(4, 'Pedido D', '555-4321', '555-1234', 'Paseo 101, Ciudad', TO_DATE('2025-06-04', 'YYYY-MM-DD'), TO_DATE('2025-06-14', 'YYYY-MM-DD'), NULL, 'En proceso', 'Esperando confirmación del cliente.'),
(5, 'Pedido E', '555-0000', NULL, 'Calle Nueva 202, Ciudad', TO_DATE('2025-06-05', 'YYYY-MM-DD'), TO_DATE('2025-06-15', 'YYYY-MM-DD'), NULL, 'Cancelado', 'Pedido cancelado por falta de stock.');

COMMIT;

CREATE TABLE pagos (
    codigopago       NUMBER PRIMARY KEY,
    codigocliente    NUMBER NOT NULL,
    codigopedido     NUMBER,
    fecha_pago       DATE NOT NULL,
    cantidad         NUMBER(12,2) NOT NULL,
    metodo_pago      VARCHAR2(50),
    comentarios      VARCHAR2(400),

    -- Claves foráneas para integridad referencial
    CONSTRAINT fk_pago_cliente FOREIGN KEY (codigocliente)
        REFERENCES clientes (codigocliente),

    CONSTRAINT fk_pago_pedido FOREIGN KEY (codigopedido)
        REFERENCES pedido (codigopedido)
);


INSERT INTO pagos VALUES (1, 1, 1, TO_DATE('2025-06-05', 'YYYY-MM-DD'), 1500.00, 'Transferencia', 'Pago inicial');
INSERT INTO pagos VALUES (2, 2, 2, TO_DATE('2025-06-10', 'YYYY-MM-DD'), 2000.00, 'Efectivo', NULL);
INSERT INTO pagos VALUES (3, 1, 1, TO_DATE('2025-06-15', 'YYYY-MM-DD'), 500.00, 'Tarjeta', 'Pago saldo');
INSERT INTO pagos VALUES (4, 3, NULL, TO_DATE('2025-06-20', 'YYYY-MM-DD'), 1200.00, 'Efectivo', 'Pago sin pedido asignado');

--Detalle Pedido

CREATE TABLE detallePedido (
    codigodetallepedido NUMBER PRIMARY KEY,
    codigopedido        NUMBER NOT NULL,
    codigoproducto      VARCHAR2(15) NOT NULL,
    cantidad            NUMBER(10,2) NOT NULL,
    precio_unitario     NUMBER(12,2) NOT NULL,
    descuento           NUMBER(5,2) DEFAULT 0, 
    
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (codigopedido)
        REFERENCES pedido (codigopedido),

    CONSTRAINT fk_detalle_producto FOREIGN KEY (codigoproducto)
        REFERENCES productos (codigoproducto)
);

INSERT INTO detallePedido VALUES (1, 1, 'P001', 2, 150.00, 10);
INSERT INTO detallePedido VALUES (2, 1, 'P002', 1, 300.00, 0);
INSERT INTO detallePedido VALUES (3, 2, 'P003', 5, 75.00, 5);
INSERT INTO detallePedido VALUES (4, 3, 'P004', 1, 200.00, 0);
INSERT INTO detallePedido VALUES (5, 3, 'P005', 2, 100.00, 0);
