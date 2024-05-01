DROP TABLE IF EXISTS PESSOAS_TAREFAS
DROP TABLE IF EXISTS TAREFAS
DROP TABLE IF EXISTS PESSOAS
DROP TABLE IF EXISTS USUARIOS

CREATE TABLE USUARIOS (
	ID INT NOT NULL IDENTITY CONSTRAINT PK_USUARIOS_ID PRIMARY KEY,
	DATA_CRIACAO DATETIME NOT NULL,
	EMAIL VARCHAR(100) NOT NULL,
	SENHA VARCHAR(20) NOT NULL
)

CREATE TABLE PESSOAS (
	ID INT NOT NULL IDENTITY CONSTRAINT PK_PESSOAS_ID PRIMARY KEY,
	DATA_CRIACAO DATETIME NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	ID_USUARIO INT NULL CONSTRAINT FK_USUARIOS_ID FOREIGN KEY REFERENCES USUARIOS (ID)
)

CREATE TABLE TAREFAS (
	ID INT NOT NULL IDENTITY CONSTRAINT PK_TAREFAS_ID PRIMARY KEY,
	DATA_CRIACAO DATETIME NOT NULL,
	TITULO VARCHAR(100) NOT NULL,
	DATA_INICIO DATETIME NOT NULL,
	DATA_FIM DATETIME NOT NULL,
	ID_CRIADOR INT NOT NULL CONSTRAINT FK_PESSOAS_ID FOREIGN KEY REFERENCES PESSOAS (ID)
)

CREATE TABLE PESSOAS_TAREFAS (
	ID INT NOT NULL IDENTITY CONSTRAINT PK_PESSOAS_TAREFAS_ID PRIMARY KEY,
	ID_PESSOA INT NOT NULL CONSTRAINT FK_PES_TAR_PESSOAS_ID FOREIGN KEY REFERENCES PESSOAS (Id),
	ID_TAREFA INT NOT NULL CONSTRAINT FK_PES_TAR_TAREFAS_ID FOREIGN KEY REFERENCES TAREFAS (Id)
)

INSERT INTO USUARIOS VALUES (GETDATE(), 'ulysses@email.com.br', 'MTIzNDU2')
INSERT INTO PESSOAS VALUES (GETDATE(), 'PessoaTeste', NULL), (GETDATE(), 'Ulysses', (SELECT ID FROM USUARIOS WHERE EMAIL = 'ulysses@email.com.br'))
INSERT INTO TAREFAS VALUES (GETDATE(), 'Criar aplica��o', '26/04/2024 10:00:00', '26/04/2024 12:30:00', (SELECT ID FROM PESSOAS WHERE NOME = 'PessoaTeste'))
INSERT INTO PESSOAS_TAREFAS VALUES ((SELECT ID FROM PESSOAS WHERE NOME = 'Ulysses'), (SELECT ID FROM TAREFAS WHERE TITULO = 'Criar aplica��o'))

SELECT*FROM USUARIOS
SELECT*FROM PESSOAS
SELECT*FROM TAREFAS
SELECT*FROM PESSOAS_TAREFAS

SELECT*FROM PESSOAS P
INNER JOIN PESSOAS_TAREFAS PT ON P.ID = PT.ID_PESSOA
INNER JOIN TAREFAS T ON T.ID = PT.ID_TAREFA
