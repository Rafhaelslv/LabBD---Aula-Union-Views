USE master
DROP DATABASE AulaUnion_E_Views
GO
CREATE DATABASE AulaUnion_E_Views
GO
USE AulaUnion_E_Views
GO

CREATE TABLE CURSO (
cod_curso				INT						NOT NULL,
nome_curso				VARCHAR(70)				NOT NULL,
sigla_curso				VARCHAR(10)				NOT NULL
PRIMARY KEY (cod_curso)
)
GO

CREATE TABLE PALESTRANTE (
cod_palestrante				INT					IDENTITY,
nome_palestrante			VARCHAR(250)		NOT NULL,
empresa_palestrante			VARCHAR(100)		NOT NULL
PRIMARY KEY (cod_palestrante)
)
GO

CREATE TABLE ALUNO (
ra_aluno					CHAR(7)			NOT NULL,
nome_aluno					VARCHAR(70)		NOT NULL,
codigo_curso				INT				NOT NULL
PRIMARY KEY (ra_aluno),
FOREIGN KEY (codigo_curso) REFERENCES CURSO (cod_curso)
)
GO

CREATE TABLE PALESTRA (
codigo_palestra					INT 			IDENTITY,
titulo_palestra					VARCHAR			NOT NULL,
carga_palestra					INT				NULL,
data_palestra					DATETIME		NOT NULL,
codigo_palestrante				INT				NOT NULL,

PRIMARY KEY (codigo_palestra),
FOREIGN KEY (codigo_palestrante) REFERENCES PALESTRANTE (cod_palestrante)
)
GO

CREATE TABLE ALUNOS_INCRITOS(
ra_aluno					CHAR(7)			NOT NULL,
codigo_palestra				INT 			IDENTITY

FOREIGN KEY (ra_aluno) REFERENCES ALUNO (ra_aluno),
FOREIGN KEY (codigo_palestra) REFERENCES PALESTRA (codigo_palestra)
)
GO

CREATE TABLE NAO_ALUNOS (
rg_naluno					VARCHAR(9)		NOT NULL,
orgao_exp_naluno			CHAR(5)			NOT NULL,
nome_naluno					VARCHAR(250)	NOT NULL
PRIMARY KEY (rg_naluno, orgao_exp_naluno)
)
GO

CREATE TABLE NAO_ALUNOS_INCRITOS (
codigo_palestra				INT 			IDENTITY,
rg_naluno					VARCHAR(9)		NOT NULL,
orgao_exp_naluno			CHAR(5)			NOT NULL,

PRIMARY KEY (codigo_palestra, rg_naluno, orgao_exp_naluno),
FOREIGN KEY (codigo_palestra) REFERENCES PALESTRA (codigo_palestra),
FOREIGN KEY (rg_naluno, orgao_exp_naluno) REFERENCES NAO_ALUNOS (rg_naluno, orgao_exp_naluno)

)
GO

CREATE VIEW v_alunos
AS
SELECT ra_aluno
FROM ALUNOS_INCRITOS

CREATE VIEW v_Nalunos
AS
SELECT rg_naluno, orgao_exp_naluno
FROM NAO_ALUNOS_INCRITOS

CREATE VIEW v_participantes
AS
SELECT ra_aluno AS Num_Documento, nome_aluno AS Nome_Pessoa, 
	'aluno' AS tipo
FROM ALUNO
UNION ALL --UNION remove duplicidades | UNION ALL apresenta todas as linhas
SELECT CONCAT(nai.rg_naluno, ' ' ,nai.orgao_exp_naluno) AS Num_Documento, nome_naluno AS Nome_Pessoa,
	'naluno' AS tipo
FROM NAO_ALUNOS_INCRITOS nai
INNER JOIN NAO_ALUNOS na on na.rg_naluno = nai.rg_naluno

SELECT * FROM v_participantes
ORDER BY Nome_Pessoa

CREATE VIEW lista_presenca
AS
SELECT p.titulo_palestra AS Titulo_Palestra, pa.nome_palestrante AS Nome_Palestrante, p.carga_palestra AS Carga_Horária, P.data_palestra AS Data
FROM PALESTRA p
INNER JOIN palestrante pa on pa.cod_palestrante = p.codigo_palestrante

SELECT * FROM lista_presenca, v_participantes








