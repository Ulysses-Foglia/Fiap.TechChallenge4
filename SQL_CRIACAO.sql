DROP TABLE IF EXISTS PESSOAS_TAREFAS
DROP TABLE IF EXISTS USUARIOS_TAREFAS
DROP TABLE IF EXISTS PESSOAS
DROP TABLE IF EXISTS TAREFAS
DROP TABLE IF EXISTS USUARIOS

CREATE TABLE USUARIOS (
	ID INT NOT NULL IDENTITY CONSTRAINT PK_USUARIOS_ID PRIMARY KEY,
	DATA_CRIACAO DATETIME NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	EMAIL VARCHAR(100) NOT NULL,
	SENHA VARCHAR(20) NOT NULL,
	PAPEL VARCHAR(20) NOT NULL
)

CREATE TABLE TAREFAS (
	ID INT NOT NULL IDENTITY CONSTRAINT PK_TAREFAS_ID PRIMARY KEY,
	DATA_CRIACAO DATETIME NOT NULL,
	TITULO VARCHAR(100) NOT NULL,
	DESCRICAO VARCHAR(2000) NOT NULL,
	PRAZO_VALOR INT NOT NULL,
	PRAZO_UNIDADE CHAR(1) NOT NULL, -- M / H / D
	[STATUS] VARCHAR(20) NOT NULL,
	DATA_INICIO DATETIME NULL,
	DATA_FIM DATETIME NULL,
	ID_CRIADOR INT NOT NULL CONSTRAINT FK_TAR_USU_CRIADOR_ID FOREIGN KEY REFERENCES USUARIOS (ID),
	ID_RESPONSAVEL INT NULL CONSTRAINT FK_TAR_USU_RESPONSAVEL_ID FOREIGN KEY REFERENCES USUARIOS (ID)
)

INSERT INTO USUARIOS VALUES (GETDATE(), 'UsuTeste1', 'usuTeste1@email.com.br', 'MTIzNDU2', 'Admin')
INSERT INTO USUARIOS VALUES (GETDATE(), 'UsuTeste2', 'usuTeste2@email.com.br', 'MTIzNDU2', 'Comum')
INSERT INTO USUARIOS VALUES (GETDATE(), 'UsuTeste3', 'usuTeste3@email.com.br', 'MTIzNDU2', 'Comum')

INSERT INTO TAREFAS VALUES (GETDATE(), 'Criar aplica��o','Criar aplica��o', 4, 'd', 'EmAndamento', '26/04/2024 10:00:00', '30/04/2024 10:00:00', 
(SELECT ID FROM USUARIOS WHERE NOME = 'UsuTeste1'), (SELECT ID FROM USUARIOS WHERE NOME = 'UsuTeste2'))
INSERT INTO TAREFAS VALUES (GETDATE(), 'Refatorar aplica��o','Refatorar aplica��o', 2, 'h', 'Atribuida', NULL, NULL, 
(SELECT ID FROM USUARIOS WHERE NOME = 'UsuTeste1'), (SELECT ID FROM USUARIOS WHERE NOME = 'UsuTeste3'))
INSERT INTO TAREFAS VALUES (GETDATE(), 'Complitar aplica��o','Refatorar aplica��o', 30, 'm', 'Pendente', NULL, NULL, 
(SELECT ID FROM USUARIOS WHERE NOME = 'UsuTeste3'), NULL)

SELECT*FROM USUARIOS WITH (NOLOCK)
SELECT*FROM TAREFAS WITH (NOLOCK)

SELECT*FROM TAREFAS T WITH (NOLOCK)
LEFT JOIN USUARIOS U_C WITH (NOLOCK) ON T.ID_CRIADOR = U_C.ID
LEFT JOIN USUARIOS U_R WITH (NOLOCK) ON T.ID_RESPONSAVEL = U_R.ID

