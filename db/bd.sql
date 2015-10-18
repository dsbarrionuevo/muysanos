DROP DATABASE IF EXISTS muysanos;
CREATE DATABASE IF NOT EXISTS muysanos;
USE muysanos;

CREATE TABLE tipos_frecuencias(
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO tipos_frecuencias(nombre) VALUES 
    ("1 vez al día"),
    ("1 vez a la semana"),
    ("2 veces por semana"),
    ("3 veces por semana"),
    ("4 veces por semana"),
    ("5 veces por semana");

CREATE TABLE tipos_comidas(
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO tipos_comidas(nombre) VALUES 
    ("Desayuno"),
    ("Almuerzo"),
    ("Merienda"),
    ("Cena"),
    ("Colación");

CREATE TABLE tipos_unidades(
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO tipos_unidades(nombre) VALUES 
    ("Unidades"),
    ("Gramos"),
    ("Litros");

CREATE TABLE familias(
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

INSERT INTO familias(nombre) VALUES 
    ("Carnes"),
    ("Frutas"),
    ("Vegetales"),
    ("Cereales"),
    ("Lácteos");

CREATE TABLE alimentos(
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    id_familia INT NOT NULL,
    id_tipo_unidad INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_familia) REFERENCES familias(id),
    FOREIGN KEY(id_tipo_unidad) REFERENCES tipos_unidades(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE alimentos_patron(
    id INT NOT NULL AUTO_INCREMENT,
    id_alimento INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_alimento) REFERENCES alimentos(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE equivalencias_alimentos(
    id INT NOT NULL AUTO_INCREMENT,
    id_alimento_patron INT NOT NULL,
    id_alimento INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_alimento_patron) REFERENCES alimentos_patron(id),
    FOREIGN KEY(id_alimento) REFERENCES alimentos(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE dietas(
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    fecha_creacion DATE NULL,
    PRIMARY KEY(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE alimentos_x_dieta(
    id INT NOT NULL AUTO_INCREMENT,
    id_dieta INT NOT NULL,
    id_alimento_patron INT NOT NULL,
    id_tipo_frecuencia INT NOT NULL,
    cantidad INT NOT NULL, /* cantidad de veces que está la cantidad definida en patrón */
    PRIMARY KEY(id),
    FOREIGN KEY(id_dieta) REFERENCES dietas(id),
    FOREIGN KEY(id_alimento_patron) REFERENCES alimentos_patron(id),
    FOREIGN KEY(id_tipo_frecuencia) REFERENCES tipos_frecuencias(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE platos(
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT NULL,
    preparacion TEXT NULL,
    valoracion DECIMAL(2,1) NULL,
    dificultad DECIMAL(2,1) NULL,
    porciones INT NULL,
    fecha_creacion DATE NULL,
    PRIMARY KEY(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE alimentos_x_plato(
    id INT NOT NULL AUTO_INCREMENT,
    id_plato INT NOT NULL,
    id_alimento INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_plato) REFERENCES platos(id),
    FOREIGN KEY(id_alimento) REFERENCES alimentos(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE pacientes(
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NULL,
    /* peso y estatura se actualizarian a lo largo de mucho tiempo... */
    peso DECIMAL(4,2) NOT NULL,
    estatura DECIMAL(4,2) NOT NULL,
    PRIMARY KEY(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE comidas_x_paciente(
    id INT NOT NULL AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_tipo_comida INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_paciente) REFERENCES pacientes(id),
    FOREIGN KEY(id_tipo_comida) REFERENCES tipos_comidas(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE platos_x_paciente(
    id INT NOT NULL AUTO_INCREMENT,
    id_comida INT NOT NULL,
    id_plato INT NOT NULL,
    porciones INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_comida) REFERENCES comidas_x_paciente(id),
    FOREIGN KEY(id_plato) REFERENCES platos(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE alimentos_x_paciente(
    id INT NOT NULL AUTO_INCREMENT,
    id_comida INT NOT NULL,
    id_alimento INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_comida) REFERENCES comidas_x_paciente(id),
    FOREIGN KEY(id_alimento) REFERENCES alimentos(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE dietas_x_paciente(
    id INT NOT NULL AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_dieta INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    peso_inicial DECIMAL(4,2) NOT NULL,
    estatura_inicial DECIMAL(4,2) NOT NULL,
    peso_deseado DECIMAL(4,2) NOT NULL,
    fecha_fin DATE NULL,
    peso_final DECIMAL(4,2) NULL,
    estatura_final DECIMAL(4,2) NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_paciente) REFERENCES pacientes(id),
    FOREIGN KEY(id_dieta) REFERENCES dietas(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE TABLE historial_dieta_paciente(
    id INT NOT NULL AUTO_INCREMENT,
    id_dieta_paciente INT NOT NULL,
    nro_semana INT NULL,
    fecha DATE NOT NULL,
    peso DECIMAL(4,2) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_dieta_paciente) REFERENCES dietas_x_paciente(id)
)ENGINE InnoDB DEFAULT CHARACTER SET=utf8;

CREATE USER 'muysanos_user'@'localhost' IDENTIFIED BY 'ms_112233';
GRANT SELECT, INSERT, UPDATE ON muysanos.* TO 'muysanos_user'@'localhost';