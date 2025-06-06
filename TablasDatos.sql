

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


 CREATE TABLE "EMPLEADOS" 
   (	"CODIGOEMPLEADO" NUMBER(*,0), 
	"NOMBRE" VARCHAR2(50 BYTE), 
	"APELLIDO1" VARCHAR2(50 BYTE), 
	"APELLIDO2" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"EXTENSION" VARCHAR2(10 BYTE), 
	"EMAIL" VARCHAR2(100 BYTE), 
	"CODIGOOFICINA" VARCHAR2(10 BYTE), 
	"CODIGOJEFE" NUMBER(*,0) DEFAULT NULL, 
	"PUESTO" VARCHAR2(50 BYTE) DEFAULT NULL
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

  
REM INSERTING into EMPLEADOS
SET DEFINE OFF;
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (1,'Marcos','Magaña','Perez','3897','marcos@jardineria.es','TAL-ES',null,'Director General');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (2,'Ruben','López','Martinez','2899','rlopez@jardineria.es','TAL-ES',1,'Subdirector Marketing');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (3,'Alberto','Soria','Carrasco','2837','asoria@jardineria.es','TAL-ES',2,'Subdirector Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (4,'Maria','Solís','Jerez','2847','msolis@jardineria.es','TAL-ES',2,'Secretaria');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (5,'Felipe','Rosas','Marquez','2844','frosas@jardineria.es','TAL-ES',3,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (6,'Juan Carlos','Ortiz','Serrano','2845','cortiz@jardineria.es','TAL-ES',3,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (7,'Carlos','Soria','Jimenez','2444','csoria@jardineria.es','MAD-ES',3,'Director Oficina');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (8,'Mariano','López','Murcia','2442','mlopez@jardineria.es','MAD-ES',7,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (9,'Lucio','Campoamor','Martín','2442','lcampoamor@jardineria.es','MAD-ES',7,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (10,'Hilario','Rodriguez','Huertas','2444','hrodriguez@jardineria.es','MAD-ES',7,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (11,'Emmanuel','Magaña','Perez','2518','manu@jardineria.es','BCN-ES',3,'Director Oficina');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (12,'José Manuel','Martinez','De la Osa','2519','jmmart@hotmail.es','BCN-ES',11,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (13,'David','Palma','Aceituno','2519','dpalma@jardineria.es','BCN-ES',11,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (14,'Oscar','Palma','Aceituno','2519','opalma@jardineria.es','BCN-ES',11,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (15,'Francois','Fignon',null,'9981','ffignon@gardening.com','PAR-FR',3,'Director Oficina');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (16,'Lionel','Narvaez',null,'9982','lnarvaez@gardening.com','PAR-FR',15,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (17,'Laurent','Serra',null,'9982','lserra@gardening.com','PAR-FR',15,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (18,'Michael','Bolton',null,'7454','mbolton@gardening.com','SFC-USA',3,'Director Oficina');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (19,'Walter Santiago','Sanchez','Lopez','7454','wssanchez@gardening.com','SFC-USA',18,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (20,'Hilary','Washington',null,'7565','hwashington@gardening.com','BOS-USA',3,'Director Oficina');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (21,'Marcus','Paxton',null,'7565','mpaxton@gardening.com','BOS-USA',20,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (22,'Lorena','Paxton',null,'7665','lpaxton@gardening.com','BOS-USA',20,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (23,'Nei','Nishikori',null,'8734','nnishikori@gardening.com','TOK-JP',3,'Director Oficina');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (24,'Narumi','Riko',null,'8734','nriko@gardening.com','TOK-JP',23,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (25,'Takuma','Nomura',null,'8735','tnomura@gardening.com','TOK-JP',23,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (26,'Amy','Johnson',null,'3321','ajohnson@gardening.com','LON-UK',3,'Director Oficina');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (27,'Larry','Westfalls',null,'3322','lwestfalls@gardening.com','LON-UK',26,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (28,'John','Walton',null,'3322','jwalton@gardening.com','LON-UK',26,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (29,'Kevin','Fallmer',null,'3210','kfalmer@gardening.com','SYD-AU',3,'Director Oficina');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (30,'Julian','Bellinelli',null,'3211','jbellinelli@gardening.com','SYD-AU',29,'Representante Ventas');
Insert into EMPLEADOS (CODIGOEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODIGOOFICINA,CODIGOJEFE,PUESTO) values (31,'Mariko','Kishi',null,'3211','mkishi@gardening.com','SYD-AU',29,'Representante Ventas');



 ALTER TABLE "EMPLEADOS" MODIFY ("CODIGOEMPLEADO" NOT NULL ENABLE);
  ALTER TABLE "EMPLEADOS" MODIFY ("NOMBRE" NOT NULL ENABLE);
  ALTER TABLE "EMPLEADOS" MODIFY ("APELLIDO1" NOT NULL ENABLE);
  ALTER TABLE "EMPLEADOS" MODIFY ("EXTENSION" NOT NULL ENABLE);
  ALTER TABLE "EMPLEADOS" MODIFY ("EMAIL" NOT NULL ENABLE);
  ALTER TABLE "EMPLEADOS" MODIFY ("CODIGOOFICINA" NOT NULL ENABLE);
  ALTER TABLE "EMPLEADOS" ADD PRIMARY KEY ("CODIGOEMPLEADO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;

    ALTER TABLE "CLIENTES" ADD CONSTRAINT "CLIENTES_EMPLEADOSFK" FOREIGN KEY ("CODIGOEMPLEADOREPVENTAS")
	  REFERENCES "EMPLEADOS" ("CODIGOEMPLEADO") ENABLE;

      
  ALTER TABLE "EMPLEADOS" ADD CONSTRAINT "EMPLEADOS_OFICINASFK" FOREIGN KEY ("CODIGOOFICINA")
	  REFERENCES "OFICINAS" ("CODIGOOFICINA") ENABLE;
  ALTER TABLE "EMPLEADOS" ADD CONSTRAINT "EMPLEADOS_EMPLEADOSFK" FOREIGN KEY ("CODIGOJEFE")
	  REFERENCES "EMPLEADOS" ("CODIGOEMPLEADO") ENABLE;

        CREATE TABLE "OFICINAS" 
   (	"CODIGOOFICINA" VARCHAR2(10 BYTE), 
	"CIUDAD" VARCHAR2(30 BYTE), 
	"PAIS" VARCHAR2(50 BYTE), 
	"REGION" VARCHAR2(50 BYTE) DEFAULT NULL, 
	"CODIGOPOSTAL" VARCHAR2(10 BYTE), 
	"TELEFONO" VARCHAR2(20 BYTE), 
	"LINEADIRECCION1" VARCHAR2(50 BYTE), 
	"LINEADIRECCION2" VARCHAR2(50 BYTE) DEFAULT NULL
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

  Insert into OFICINAS (CODIGOOFICINA,CIUDAD,PAIS,REGION,CODIGOPOSTAL,TELEFONO,LINEADIRECCION1,LINEADIRECCION2) values ('BCN-ES','Barcelona','España','Barcelona','08019','+34 93 3561182','Avenida Diagonal, 38','3A escalera Derecha');
Insert into OFICINAS (CODIGOOFICINA,CIUDAD,PAIS,REGION,CODIGOPOSTAL,TELEFONO,LINEADIRECCION1,LINEADIRECCION2) values ('BOS-USA','Boston','EEUU','MA','02108','+1 215 837 0825','1550 Court Place','Suite 102');
Insert into OFICINAS (CODIGOOFICINA,CIUDAD,PAIS,REGION,CODIGOPOSTAL,TELEFONO,LINEADIRECCION1,LINEADIRECCION2) values ('LON-UK','Londres','Inglaterra','EMEA','EC2N 1HN','+44 20 78772041','52 Old Broad Street','Ground Floor');
Insert into OFICINAS (CODIGOOFICINA,CIUDAD,PAIS,REGION,CODIGOPOSTAL,TELEFONO,LINEADIRECCION1,LINEADIRECCION2) values ('MAD-ES','Madrid','España','Madrid','28032','+34 91 7514487','Bulevar Indalecio Prieto, 32',null);
Insert into OFICINAS (CODIGOOFICINA,CIUDAD,PAIS,REGION,CODIGOPOSTAL,TELEFONO,LINEADIRECCION1,LINEADIRECCION2) values ('PAR-FR','Paris','Francia','EMEA','75017','+33 14 723 4404','29 Rue Jouffroy d''abbans',null);
Insert into OFICINAS (CODIGOOFICINA,CIUDAD,PAIS,REGION,CODIGOPOSTAL,TELEFONO,LINEADIRECCION1,LINEADIRECCION2) values ('SFC-USA','San Francisco','EEUU','CA','94080','+1 650 219 4782','100 Market Street','Suite 300');
Insert into OFICINAS (CODIGOOFICINA,CIUDAD,PAIS,REGION,CODIGOPOSTAL,TELEFONO,LINEADIRECCION1,LINEADIRECCION2) values ('SYD-AU','Sydney','Australia','APAC','NSW 2010','+61 2 9264 2451','5-11 Wentworth Avenue','Floor #2');
Insert into OFICINAS (CODIGOOFICINA,CIUDAD,PAIS,REGION,CODIGOPOSTAL,TELEFONO,LINEADIRECCION1,LINEADIRECCION2) values ('TAL-ES','Talavera de la Reina','España','Castilla-LaMancha','45632','+34 925 867231','Francisco Aguirre, 32','5º piso (exterior)');
Insert into OFICINAS (CODIGOOFICINA,CIUDAD,PAIS,REGION,CODIGOPOSTAL,TELEFONO,LINEADIRECCION1,LINEADIRECCION2) values ('TOK-JP','Tokyo','Japón','Chiyoda-Ku','102-8578','+81 33 224 5000','4-1 Kioicho',null);




  ALTER TABLE "OFICINAS" MODIFY ("CODIGOOFICINA" NOT NULL ENABLE);
  ALTER TABLE "OFICINAS" MODIFY ("CIUDAD" NOT NULL ENABLE);
  ALTER TABLE "OFICINAS" MODIFY ("PAIS" NOT NULL ENABLE);
  ALTER TABLE "OFICINAS" MODIFY ("CODIGOPOSTAL" NOT NULL ENABLE);
  ALTER TABLE "OFICINAS" MODIFY ("TELEFONO" NOT NULL ENABLE);
  ALTER TABLE "OFICINAS" MODIFY ("LINEADIRECCION1" NOT NULL ENABLE);
  ALTER TABLE "OFICINAS" ADD PRIMARY KEY ("CODIGOOFICINA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;


  ALTER TABLE productos ADD cantidadenstock NUMBER(10,2);

UPDATE productos SET cantidadenstock = 25 WHERE codigoproducto = 'P001';
UPDATE productos SET cantidadenstock = 10 WHERE codigoproducto = 'P002';
UPDATE productos SET cantidadenstock = 50 WHERE codigoproducto = 'P003';
UPDATE productos SET cantidadenstock = 5  WHERE codigoproducto = 'P004';
UPDATE productos SET cantidadenstock = 30 WHERE codigoproducto = 'P005';

