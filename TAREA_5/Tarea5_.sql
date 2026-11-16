-- PROYECTO: RED SOCIAL ESTUDIANTIL PASCUALINA
-- TAREA 5: CONSULTAS DML Y CREACION DE VISTAS
-- SGBD: PostgreSQL
-- IMPORTANTE: DROP TABLE ... CASCADE elimina las tablas existentes.
-- Ejecutar solo en una base de datos de pruebas o vacia.

-- PARTE 0. ESTRUCTURA DDL
DROP TABLE IF EXISTS reaccion, comentario, publicacion_estudiante, publicacion, seguir,
mentoria, estudiante_evento, estudiante_grupo, estudiante_interes, estudiante_habilidad,
interes, habilidad, evento, grupo, estudiante CASCADE;

CREATE TABLE estudiante (
 id_estudiante SERIAL PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 email VARCHAR(150) UNIQUE NOT NULL,
 contrasena VARCHAR(255) NOT NULL,
 programa VARCHAR(100),
 area_estudio VARCHAR(100),
 semestre SMALLINT CHECK (semestre IS NULL OR semestre > 0),
 ciudad VARCHAR(100),
 biografia VARCHAR(500),
 foto_url VARCHAR(255),
 fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE,
 fecha_actualizacion TIMESTAMP
);

CREATE TABLE habilidad (
 id_habilidad SERIAL PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE interes (
 id_interes SERIAL PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE grupo (
 id_grupo SERIAL PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 descripcion VARCHAR(500),
 categoria VARCHAR(50)
);

CREATE TABLE evento (
 id_evento SERIAL PRIMARY KEY,
 titulo VARCHAR(150) NOT NULL,
 descripcion VARCHAR(500),
 fecha_hora TIMESTAMP,
 lugar VARCHAR(150)
);

CREATE TABLE publicacion (
 id_publicacion SERIAL PRIMARY KEY,
 contenido TEXT NOT NULL,
 fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 tipo VARCHAR(50) NOT NULL
);

CREATE TABLE estudiante_habilidad (
 id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante),
 id_habilidad INT NOT NULL REFERENCES habilidad(id_habilidad),
 nivel VARCHAR(30) NOT NULL CHECK (nivel IN ('principiante','intermedio','avanzado')),
 fecha_agregado DATE NOT NULL DEFAULT CURRENT_DATE,
 PRIMARY KEY (id_estudiante, id_habilidad)
);

CREATE TABLE estudiante_interes (
 id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante),
 id_interes INT NOT NULL REFERENCES interes(id_interes),
 fecha_agregado DATE NOT NULL DEFAULT CURRENT_DATE,
 PRIMARY KEY (id_estudiante, id_interes)
);

CREATE TABLE estudiante_grupo (
 id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante),
 id_grupo INT NOT NULL REFERENCES grupo(id_grupo),
 rol VARCHAR(30) NOT NULL CHECK (rol IN ('miembro','administrador')),
 fecha_union DATE NOT NULL DEFAULT CURRENT_DATE,
 PRIMARY KEY (id_estudiante, id_grupo)
);

CREATE TABLE estudiante_evento (
 id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante),
 id_evento INT NOT NULL REFERENCES evento(id_evento),
 estado VARCHAR(30) NOT NULL CHECK (estado IN ('organizador','invitado','asistente')),
 PRIMARY KEY (id_estudiante, id_evento)
);

CREATE TABLE publicacion_estudiante (
 id_publicacion INT NOT NULL REFERENCES publicacion(id_publicacion),
 id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante),
 rol_autor VARCHAR(50),
 fecha_autoria DATE NOT NULL DEFAULT CURRENT_DATE,
 PRIMARY KEY (id_publicacion, id_estudiante)
);

CREATE TABLE comentario (
 id_comentario SERIAL PRIMARY KEY,
 id_publicacion INT NOT NULL REFERENCES publicacion(id_publicacion),
 id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante),
 texto TEXT NOT NULL,
 fecha_comentario TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reaccion (
 id_publicacion INT NOT NULL REFERENCES publicacion(id_publicacion),
 id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante),
 tipo_reaccion VARCHAR(50) NOT NULL
 CHECK (tipo_reaccion IN ('me gusta','me encanta','me divierte','apoyo','interesante')),
 fecha_reaccion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (id_publicacion, id_estudiante)
);

CREATE TABLE seguir (
 id_seguidor INT NOT NULL REFERENCES estudiante(id_estudiante),
 id_seguido INT NOT NULL REFERENCES estudiante(id_estudiante),
 CHECK (id_seguidor <> id_seguido),
 PRIMARY KEY (id_seguidor, id_seguido)
);

CREATE TABLE mentoria (
 id_mentor INT NOT NULL REFERENCES estudiante(id_estudiante),
 id_aprendiz INT NOT NULL REFERENCES estudiante(id_estudiante),
 id_habilidad INT NOT NULL REFERENCES habilidad(id_habilidad),
 fecha_inicio DATE NOT NULL,
 estado VARCHAR(30) NOT NULL CHECK (estado IN ('en proceso','completada','cancelada')),
 CHECK (id_mentor <> id_aprendiz),
 PRIMARY KEY (id_mentor, id_aprendiz, id_habilidad)
);

-- PARTE 1. DATOS DE PRUEBA
INSERT INTO estudiante (nombre,email,contrasena,programa,area_estudio,semestre,ciudad,biografia) VALUES
('Ana Gómez','ana@pascualbravo.edu.co','hash123','Tecnología en Desarrollo de Software','Ingeniería',4,'Medellín','Interesada en programación y tecnología.'),
('Carlos Pérez','carlos@pascualbravo.edu.co','hash123','Ingeniería de Software','Ingeniería',6,'Medellín','Interesado en bases de datos.'),
('Luisa Martínez','luisa@pascualbravo.edu.co','hash123','Diseño Gráfico','Artes',2,'Medellín','Interesada en diseño UX/UI.'),
('Pedro Rojas','pedro@pascualbravo.edu.co','hash123','Tecnología en Desarrollo de Software','Ingeniería',3,'Bello','Interesado en desarrollo.');

INSERT INTO habilidad(nombre) VALUES ('Programación en Python'),('Bases de Datos'),('Diseño UX/UI'),('Fútbol');
INSERT INTO interes(nombre) VALUES ('Inteligencia Artificial'),('Videojuegos'),('Desarrollo Web');
INSERT INTO estudiante_habilidad VALUES
(1,1,'avanzado','2023-10-01'),(2,2,'avanzado','2023-10-02'),
(3,3,'intermedio','2023-10-03'),(4,1,'avanzado','2023-10-04');
INSERT INTO estudiante_interes VALUES
(1,1,'2023-10-01'),(2,2,'2023-10-02'),(3,3,'2023-10-03');
INSERT INTO grupo(nombre,descripcion,categoria) VALUES
('Club de Programación','Grupo de estudio para hackathones','Estudio'),
('Diseño y Café','Club de diseño gráfico','Club');
INSERT INTO estudiante_grupo VALUES
(1,1,'administrador','2023-10-05'),(2,1,'miembro','2023-10-06'),(3,2,'administrador','2023-10-07');
INSERT INTO evento(titulo,descripcion,fecha_hora,lugar) VALUES
('Taller de SQL','Aprende consultas avanzadas','2026-11-20 14:00:00','Laboratorio 201'),
('Hackathon Pascualino','Maratón de programación','2026-11-25 08:00:00','Auditorio Principal');
INSERT INTO estudiante_evento VALUES
(1,1,'asistente'),(2,1,'organizador'),(3,2,'invitado'),(4,1,'asistente');
INSERT INTO publicacion(contenido,tipo) VALUES
('¿Alguien me ayuda con un error en Python?','Pregunta'),
('Les comparto este recurso de SQL','Recurso'),
('Meme de la vida universitaria','Meme');
INSERT INTO publicacion_estudiante(id_publicacion,id_estudiante,rol_autor) VALUES
(1,1,'autor'),(2,2,'autor'),(3,3,'autor');
INSERT INTO comentario(id_publicacion,id_estudiante,texto) VALUES
(1,2,'Yo te ayudo'),(1,3,'Mándame mensaje'),(3,1,'Jajaja muy bueno');
INSERT INTO reaccion(id_publicacion,id_estudiante,tipo_reaccion) VALUES
(1,2,'me gusta'),(1,3,'me gusta'),(2,1,'me encanta'),(3,2,'me divierte');
INSERT INTO seguir VALUES (1,2),(2,1),(3,1),(4,1),(3,2);
INSERT INTO mentoria VALUES (1,3,1,'2026-10-15','en proceso'),(2,4,2,'2026-10-20','en proceso');

-- PARTE 2. SEIS CONSULTAS DML
-- Consulta 1: estudiantes con habilidades avanzadas
SELECT e.nombre AS nombre_estudiante, e.programa AS programa_academico,
 h.nombre AS nombre_habilidad, eh.nivel AS nivel_dominio
FROM estudiante e
JOIN estudiante_habilidad eh ON e.id_estudiante=eh.id_estudiante
JOIN habilidad h ON eh.id_habilidad=h.id_habilidad
WHERE eh.nivel='avanzado'
ORDER BY e.nombre,h.nombre;

-- Consulta 2: cinco estudiantes con mas seguidores
SELECT e.nombre AS nombre_estudiante, e.programa AS programa_academico,
 COUNT(s.id_seguidor) AS total_seguidores
FROM estudiante e LEFT JOIN seguir s ON e.id_estudiante=s.id_seguido
GROUP BY e.id_estudiante,e.nombre,e.programa
ORDER BY total_seguidores DESC,e.nombre ASC LIMIT 5;

-- Consulta 3: grupos, miembros y administradores
SELECT g.nombre AS nombre_grupo,g.categoria AS categoria_grupo,
 COUNT(eg.id_estudiante) AS cantidad_miembros,
 COALESCE(STRING_AGG(e.nombre,', ') FILTER (WHERE eg.rol='administrador'),
 'Sin administrador registrado') AS administradores
FROM grupo g
LEFT JOIN estudiante_grupo eg ON g.id_grupo=eg.id_grupo
LEFT JOIN estudiante e ON eg.id_estudiante=e.id_estudiante
GROUP BY g.id_grupo,g.nombre,g.categoria
ORDER BY cantidad_miembros DESC,g.nombre;

-- Consulta 4: eventos y cantidad de asistentes
SELECT ev.titulo AS nombre_evento,ev.fecha_hora AS fecha_programada,ev.lugar,
 COUNT(ee.id_estudiante) FILTER (WHERE ee.estado='asistente') AS total_asistentes
FROM evento ev LEFT JOIN estudiante_evento ee ON ev.id_evento=ee.id_evento
GROUP BY ev.id_evento,ev.titulo,ev.fecha_hora,ev.lugar
ORDER BY total_asistentes DESC,ev.fecha_hora;

-- Consulta 5: mentorias en proceso
SELECT mentor.nombre AS nombre_mentor,aprendiz.nombre AS nombre_aprendiz,
 h.nombre AS habilidad_mentorizada,m.fecha_inicio AS fecha_inicio_mentoria,
 m.estado AS estado_mentoria
FROM mentoria m
JOIN estudiante mentor ON m.id_mentor=mentor.id_estudiante
JOIN estudiante aprendiz ON m.id_aprendiz=aprendiz.id_estudiante
JOIN habilidad h ON m.id_habilidad=h.id_habilidad
WHERE m.estado='en proceso'
ORDER BY m.fecha_inicio DESC;

-- Consulta 6: promedio de reacciones y comentarios por tipo de publicacion
WITH reacciones_por_pub AS (
 SELECT id_publicacion,COUNT(*) AS total_reacciones
 FROM reaccion GROUP BY id_publicacion
),
comentarios_por_pub AS (
 SELECT id_publicacion,COUNT(*) AS total_comentarios
 FROM comentario GROUP BY id_publicacion
)
SELECT p.tipo AS tipo_publicacion,
 ROUND(AVG(COALESCE(r.total_reacciones,0)),2) AS promedio_reacciones,
 ROUND(AVG(COALESCE(c.total_comentarios,0)),2) AS promedio_comentarios
FROM publicacion p
LEFT JOIN reacciones_por_pub r ON p.id_publicacion=r.id_publicacion
LEFT JOIN comentarios_por_pub c ON p.id_publicacion=c.id_publicacion
GROUP BY p.tipo
ORDER BY promedio_reacciones DESC,promedio_comentarios DESC;

-- PARTE 3. CUATRO VISTAS Y CONSULTAS DE PRUEBA
-- Vista 1: perfiles consolidados
CREATE OR REPLACE VIEW vw_perfiles_consolidados AS
SELECT e.id_estudiante,e.nombre AS nombre_completo,e.programa,e.area_estudio,e.semestre,
 COALESCE(STRING_AGG(DISTINCT h.nombre,', '),'Sin habilidades registradas') AS habilidades,
 COALESCE(STRING_AGG(DISTINCT i.nombre,', '),'Sin intereses registrados') AS intereses
FROM estudiante e
LEFT JOIN estudiante_habilidad eh ON e.id_estudiante=eh.id_estudiante
LEFT JOIN habilidad h ON eh.id_habilidad=h.id_habilidad
LEFT JOIN estudiante_interes ei ON e.id_estudiante=ei.id_estudiante
LEFT JOIN interes i ON ei.id_interes=i.id_interes
GROUP BY e.id_estudiante,e.nombre,e.programa,e.area_estudio,e.semestre;
SELECT * FROM vw_perfiles_consolidados ORDER BY nombre_completo;

-- Vista 2: metricas de grupos
CREATE OR REPLACE VIEW vw_metricas_grupos AS
SELECT g.id_grupo,g.nombre AS nombre_grupo,g.categoria AS categoria_grupo,
 COUNT(eg.id_estudiante) AS total_miembros,
 COUNT(eg.id_estudiante) FILTER (WHERE eg.rol='administrador') AS total_administradores
FROM grupo g LEFT JOIN estudiante_grupo eg ON g.id_grupo=eg.id_grupo
GROUP BY g.id_grupo,g.nombre,g.categoria;
SELECT * FROM vw_metricas_grupos ORDER BY total_miembros DESC;

-- Vista 3: red de mentorias
CREATE OR REPLACE VIEW vw_red_mentorias AS
SELECT m.id_mentor,mentor.nombre AS nombre_mentor,mentor.programa AS programa_mentor,
 m.id_aprendiz,aprendiz.nombre AS nombre_aprendiz,aprendiz.semestre AS semestre_aprendiz,
 h.nombre AS tema_mentoria,m.fecha_inicio,m.estado AS estado_mentoria
FROM mentoria m
JOIN estudiante mentor ON m.id_mentor=mentor.id_estudiante
JOIN estudiante aprendiz ON m.id_aprendiz=aprendiz.id_estudiante
JOIN habilidad h ON m.id_habilidad=h.id_habilidad;
SELECT * FROM vw_red_mentorias
WHERE estado_mentoria='en proceso' ORDER BY fecha_inicio DESC;

-- Vista 4: resumen de eventos
CREATE OR REPLACE VIEW vw_resumen_eventos AS
SELECT ev.id_evento,ev.titulo,ev.fecha_hora,ev.lugar,
 COUNT(ee.id_estudiante) FILTER (WHERE ee.estado='invitado') AS total_invitados,
 COUNT(ee.id_estudiante) FILTER (WHERE ee.estado='asistente') AS total_asistentes,
 COUNT(ee.id_estudiante) FILTER (WHERE ee.estado='organizador') AS total_organizadores
FROM evento ev LEFT JOIN estudiante_evento ee ON ev.id_evento=ee.id_evento
GROUP BY ev.id_evento,ev.titulo,ev.fecha_hora,ev.lugar;
SELECT * FROM vw_resumen_eventos ORDER BY fecha_hora;

-- FIN DEL SCRIPT
