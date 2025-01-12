CREATE SCHEMA IF NOT EXISTS Streaming;

SET search_path TO Streaming;

CREATE TABLE Moeda (
    ISO VARCHAR(3) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    fator_conv DECIMAL(10, 6) NOT NULL
);

CREATE TABLE Pais (
    DDI INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    ISO_moeda VARCHAR(3) NOT NULL,
    FOREIGN KEY (ISO_moeda) REFERENCES Moeda(ISO)
);

CREATE TABLE Empresa (
    num_seq SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    id_nacional VARCHAR(20) NOT NULL,
    razao_social VARCHAR(255)
);

CREATE TABLE Empresa_PaisOrigem (
    DDI_pais INT,
    num_seq INT,
    ID_nacional VARCHAR(20) NOT NULL,
    PRIMARY KEY (DDI_pais, num_seq),
    FOREIGN KEY (DDI_pais) REFERENCES Pais(DDI),
    FOREIGN KEY (num_seq) REFERENCES Empresa(num_seq)
);

CREATE TABLE Plataforma (
    num_seq SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_fund DATE,
    num_fundadora INT,
    num_responsavel INT NOT NULL,
    FOREIGN KEY (num_fundadora) REFERENCES Empresa(num_seq),
    FOREIGN KEY (num_responsavel) REFERENCES Empresa(num_seq)
);

CREATE TABLE Usuario (
    nick VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    data_nasc DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

CREATE TABLE User_plat (
    num_usuario SERIAL PRIMARY KEY,
    nick_usuario VARCHAR(255) NOT NULL,
    num_plataforma INT NOT NULL,
    FOREIGN KEY (nick_usuario) REFERENCES Usuario(nick),
    FOREIGN KEY (num_plataforma) REFERENCES Plataforma(num_seq)
);

CREATE TABLE Residencia_usuario (
    cod_postal VARCHAR(20),
    DDI_Pais INT NOT NULL,
    nick_usuario VARCHAR(255) NOT NULL,
    PRIMARY KEY (cod_postal, DDI_Pais, nick_usuario),
    FOREIGN KEY (DDI_Pais) REFERENCES Pais(DDI),
    FOREIGN KEY (nick_usuario) REFERENCES Usuario(nick)
);

CREATE TABLE Streamer_passaporte (
    num_passaporte SERIAL PRIMARY KEY,
    nick_usuario VARCHAR(50) NOT NULL,
    DDI_Pais INT NOT NULL,
    FOREIGN KEY (DDI_Pais) REFERENCES Pais(DDI),
    FOREIGN KEY (nick_usuario) REFERENCES Usuario(nick)
);

CREATE TABLE Canal (
    id_canal SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    data_inicio DATE NOT NULL,
    descrição TEXT,
    tipo VARCHAR(50),
    nick_streamer VARCHAR(50) NOT NULL,
    num_plat INT NOT NULL,
    num_usuer INT NOT NULL,
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick),
    FOREIGN KEY (num_plat) REFERENCES Plataforma(num_seq),
    FOREIGN KEY (num_usuer) REFERENCES User_plat(num_usuario)
);

CREATE TABLE Membership (
    id_canal SERIAL,
    nivel INT NOT NULL,
    valor REAL NOT NULL,
    gif_nivel VARCHAR(50),
    nome_nivel VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_canal, nivel),
    FOREIGN KEY (id_canal) REFERENCES Canal(id_canal)
);

CREATE TABLE Afiliação (
    num_usuario INT NOT NULL,
    id_canal INT NOT NULL,
    nivel INT NULL,
    PRIMARY KEY (num_usuario, id_canal, nivel),
    FOREIGN KEY (num_usuario) REFERENCES User_plat(num_usuario),
    FOREIGN KEY (id_canal, nivel) REFERENCES Membership(id_canal, nivel)
);

CREATE TABLE Patrocínio (
    id_canal SERIAL,
    num_empresa INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_canal, num_empresa),
    FOREIGN KEY (id_canal) REFERENCES Canal(id_canal),
    FOREIGN KEY (num_empresa) REFERENCES Empresa(num_seq)
);

CREATE TABLE Video (
    id_video SERIAL PRIMARY KEY,
    titulo_video VARCHAR(50) NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    max_view INT,
    total_view INT,
    tema VARCHAR(50),
    id_canal SERIAL,
    FOREIGN KEY (id_canal) REFERENCES Canal(id_canal)
);

CREATE TABLE Part_especial (
    nick_streamer VARCHAR(50) NOT NULL,
    id_video INT NOT NULL,
    PRIMARY KEY (nick_streamer, id_video),
    FOREIGN KEY (nick_streamer) REFERENCES Usuario(nick),
    FOREIGN KEY (id_video) REFERENCES Video(id_video)
);

CREATE TABLE Comentario (
    num_seq SERIAL PRIMARY KEY,
    data_hora_coment TIMESTAMP NOT NULL,
    tipo_interacao VARCHAR(255),
    num_usuario INT NOT NULL,
    id_video INT NOT NULL,
    FOREIGN KEY (num_usuario) REFERENCES User_plat(num_usuario),
    FOREIGN KEY (id_video) REFERENCES Video(id_video)
);

CREATE TABLE Doacao (
    NSU SERIAL PRIMARY KEY,
    valor DECIMAL(10, 2) NOT NULL,
    status VARCHAR(255) NOT NULL,
    NSU_coment INT NOT NULL,
    FOREIGN KEY (NSU_coment) REFERENCES Comentario(num_seq)
);

CREATE TABLE Pagamento (
    valor_pgto DECIMAL(10, 2) NOT NULL,
    num_seq SERIAL PRIMARY KEY,
    FOREIGN KEY (num_seq) REFERENCES Doacao(NSU)
);

CREATE TABLE Cartao_Credito (
    num_cartao VARCHAR(16) PRIMARY KEY,
    bandeira VARCHAR(255) NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    valor_pgto DECIMAL(10, 2) NOT NULL,
    num_doacao INT NOT NULL,
    FOREIGN KEY (num_doacao) REFERENCES Doacao(NSU)
);

CREATE TABLE PayPal (
    IdPayPal SERIAL PRIMARY KEY,
    valor_pgto DECIMAL(10, 2) NOT NULL,
    num_doacao INT NOT NULL,
    FOREIGN KEY (num_doacao) REFERENCES Doacao(NSU)
);

CREATE TABLE Bitcoin (
    TxID SERIAL PRIMARY KEY,
    valor_pgto DECIMAL(10, 2) NOT NULL,
    num_doacao INT NOT NULL,
    FOREIGN KEY (num_doacao) REFERENCES Doacao(NSU)
);

CREATE TABLE Pgto_plataforma (
    num_seq_plat SERIAL PRIMARY KEY,
    valor_pgto DECIMAL(10, 2) NOT NULL,
    num_doacao INT NOT NULL,
    FOREIGN KEY (num_doacao) REFERENCES Doacao(NSU)
);
