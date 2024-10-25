-- Criar o banco de dados ecommerce, se não existir
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Criar tabela de clientes
CREATE TABLE IF NOT EXISTS client (
    idClients INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) UNIQUE,
    tipo ENUM('Pessoa Física', 'Pessoa Jurídica') NOT NULL,
    Address VARCHAR(50)
);

-- Criar tabela de fornecedores
CREATE TABLE IF NOT EXISTS fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nomeFornecedor VARCHAR(50) NOT NULL,
    contato VARCHAR(50),
    endereco VARCHAR(100)
);

-- Criar tabela de estoque
CREATE TABLE IF NOT EXISTS estoque (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    localizacao VARCHAR(50),
    quantidade INT DEFAULT 0
);

-- Criar tabela de terceiros
CREATE TABLE IF NOT EXISTS terceiro (
    idTerceiro INT AUTO_INCREMENT PRIMARY KEY,
    nomeTerceiro VARCHAR(50) NOT NULL,
    tipo ENUM('Pessoa Física', 'Pessoa Jurídica') NOT NULL,
    contato VARCHAR(50)
);

-- Criar tabela de produtos
CREATE TABLE IF NOT EXISTS product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    classification_kids BOOLEAN DEFAULT FALSE,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    avaliação FLOAT DEFAULT 0,
    size VARCHAR(10)
);

-- Criar tabela de produtos de terceiros
CREATE TABLE IF NOT EXISTS produtos_terceiro (
    idProduto INT,
    idTerceiro INT,
    preco DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (idProduto, idTerceiro),
    CONSTRAINT fk_produto_terceiro FOREIGN KEY (idProduto) REFERENCES product (idProduct) ON DELETE CASCADE,
    CONSTRAINT fk_terceiro_produto FOREIGN KEY (idTerceiro) REFERENCES terceiro (idTerceiro) ON DELETE CASCADE
);

-- Criar tabela de pagamentos
CREATE TABLE IF NOT EXISTS payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    paymentMethod ENUM('Cartão de Crédito', 'Cartão de Débito', 'Boleto', 'Pix', 'Transferência Bancária') NOT NULL,
    paymentAmount DECIMAL(10, 2) NOT NULL,
    paymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    paymentStatus ENUM('Pendente', 'Pago', 'Cancelado') DEFAULT 'Pendente',
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) REFERENCES client (idClients) ON DELETE CASCADE
);

-- Criar tabela de produtos no estoque
CREATE TABLE IF NOT EXISTS produto_estoque (
    idProduto INT,
    idEstoque INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (idProduto, idEstoque),
    CONSTRAINT fk_produto_estoque FOREIGN KEY (idProduto) REFERENCES product (idProduct) ON DELETE CASCADE,
    CONSTRAINT fk_estoque_produto FOREIGN KEY (idEstoque) REFERENCES estoque (idEstoque) ON DELETE CASCADE
);

-- Criar tabela de pedidos
CREATE TABLE IF NOT EXISTS orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') NOT NULL,
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    CONSTRAINT fk_order_client FOREIGN KEY (idOrderClient) REFERENCES client (idClients) ON DELETE CASCADE
);

-- Criar tabela de produtos nos pedidos
CREATE TABLE IF NOT EXISTS produto_pedido (
    idProduto INT,
    idPedido INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (idProduto, idPedido),
    CONSTRAINT fk_produto_pedido FOREIGN KEY (idProduto) REFERENCES product (idProduct) ON DELETE CASCADE,
    CONSTRAINT fk_pedido_produto FOREIGN KEY (idPedido) REFERENCES orders (idOrder) ON DELETE CASCADE
);

-- Criar tabela de entregas
CREATE TABLE IF NOT EXISTS entrega (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    statusEntrega ENUM('Em trânsito', 'Entregue', 'Cancelada') NOT NULL,
    codigoRastreamento VARCHAR(50),
    CONSTRAINT fk_entrega_order FOREIGN KEY (idOrder) REFERENCES orders (idOrder) ON DELETE CASCADE
);

-- Exibir as tabelas criadas
SHOW TABLES;

-- Inserir dados na tabela client
INSERT INTO client (Fname, Minit, Lname, CPF, tipo, Address) VALUES
('Ana', 'A', 'Silva', '12345678901', 'Pessoa Física', 'Rua das Flores, 100'),
('Bruno', 'B', 'Oliveira', '23456789012', 'Pessoa Física', 'Av. Central, 200'),
('Empresa X', NULL, NULL, '34567890123', 'Pessoa Jurídica', 'Av. Industrial, 500'),
('Carlos', 'C', 'Pereira', '45678901234', 'Pessoa Física', 'Rua do Sol, 300'),
('Empresa Y', NULL, NULL, '56789012345', 'Pessoa Jurídica', 'Rua das Árvores, 400');

-- Inserir dados na tabela fornecedor
INSERT INTO fornecedor (nomeFornecedor, contato, endereco) VALUES
('Fornecedor A', 'fornecedor_a@exemplo.com', 'Rua A, 10'),
('Fornecedor B', 'fornecedor_b@exemplo.com', 'Rua B, 20'),
('Fornecedor C', 'fornecedor_c@exemplo.com', 'Rua C, 30');

-- Inserir dados na tabela estoque
INSERT INTO estoque (localizacao, quantidade) VALUES
('Depósito 1', 100),
('Depósito 2', 200),
('Depósito 3', 150);

-- Inserir dados na tabela terceiro
INSERT INTO terceiro (nomeTerceiro, tipo, contato) VALUES
('Vendedor 1', 'Pessoa Física', 'vendedor1@exemplo.com'),
('Vendedor 2', 'Pessoa Jurídica', 'vendedor2@exemplo.com'),
('Fornecedor A', 'Pessoa Jurídica', 'fornecedor_a@exemplo.com'); -- Fornecedor A também como terceiro

-- Inserir dados na tabela product
INSERT INTO product (Pname, classification_kids, category, avaliação, size) VALUES
('Notebook', FALSE, 'Eletrônico', 4.5, 'Médio'),
('Camiseta Infantil', TRUE, 'Vestimenta', 4.8, 'P'),
('Bicicleta', FALSE, 'Brinquedos', 4.6, 'Grande'),
('Celular', FALSE, 'Eletrônico', 4.7, 'Pequeno'),
('Jogo de Tabuleiro', TRUE, 'Brinquedos', 4.2, 'Médio');

-- Inserir dados na tabela produtos_terceiro
INSERT INTO produtos_terceiro (idProduto, idTerceiro, preco) VALUES
(1, 1, 2500.00),  -- Notebook vendido por Vendedor 1
(2, 1, 30.00),    -- Camiseta Infantil vendida por Vendedor 1
(3, 2, 500.00),   -- Bicicleta vendida por Vendedor 2
(4, 3, 1000.00),  -- Celular vendido por Fornecedor A
(5, 2, 120.00);   -- Jogo de Tabuleiro vendido por Vendedor 2

-- Inserir dados na tabela payments
INSERT INTO payments (idClient, paymentMethod, paymentAmount, paymentDate, paymentStatus) VALUES
(1, 'Cartão de Crédito', 500.00, '2023-10-01', 'Pago'),
(2, 'Pix', 250.00, '2023-09-21', 'Pago'),
(3, 'Boleto', 1500.00, '2023-09-15', 'Pendente'),
(4, 'Cartão de Débito', 75.00, '2023-10-20', 'Pago'),
(5, 'Transferência Bancária', 400.00, '2023-08-10', 'Cancelado');

-- Inserir dados na tabela produto_estoque
INSERT INTO produto_estoque (idProduto, idEstoque, quantidade) VALUES
(1, 1, 20), -- Notebook no Depósito 1
(2, 2, 50), -- Camiseta Infantil no Depósito 2
(3, 3, 10), -- Bicicleta no Depósito 3
(4, 1, 30), -- Celular no Depósito 1
(5, 2, 15); -- Jogo de Tabuleiro no Depósito 2

-- Inserir dados na tabela orders
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue) VALUES
(1, 'Confirmado', 'Pedido de Notebook', 15.00),
(2, 'Em processamento', 'Pedido de Camiseta Infantil', 10.00),
(3, 'Confirmado', 'Pedido de Bicicleta', 20.00),
(4, 'Cancelado', 'Pedido de Celular', 5.00),
(5, 'Em processamento', 'Pedido de Jogo de Tabuleiro', 12.00);

-- Inserir dados na tabela produto_pedido
INSERT INTO produto_pedido (idProduto, idPedido, quantidade) VALUES
(1, 1, 1), -- 1 Notebook no pedido 1
(2, 2, 3), -- 3 Camisetas Infantis no pedido 2
(3, 3, 2), -- 2 Bicicletas no pedido 3
(4, 4, 1), -- 1 Celular no pedido 4
(5, 5, 4); -- 4 Jogos de Tabuleiro no pedido 5

-- Inserir dados na tabela entrega
INSERT INTO entrega (idOrder, statusEntrega, codigoRastreamento) VALUES
(1, 'Entregue', 'TRACK123'),
(2, 'Em trânsito', 'TRACK456'),
(3, 'Cancelada', 'TRACK789'),
(4, 'Em trânsito', 'TRACK321'),
(5, 'Entregue', 'TRACK654');


-- Testes para validação das funcionalidades

-- 1. Recuperações simples com SELECT
-- Recuperar todos os clientes
SELECT * FROM client;

-- 2. Filtros com WHERE
-- Recuperar produtos da categoria 'Eletrônico'
SELECT * FROM product WHERE category = 'Eletrônico';

-- 3. Cria expressões para gerar atributos derivados
-- Calcular o total do pagamento com um desconto hipotético
SELECT idPayment, paymentAmount, paymentAmount * 0.9 AS discountedAmount FROM payments;

-- 4. Defina ordenações dos dados com ORDER BY
-- Ordenar pedidos pelo status do pedido
SELECT * FROM orders ORDER BY orderStatus;

-- 5. Condições de filtros aos grupos - HAVING
-- Ver quantos pedidos foram feitos por cada cliente, filtrando aqueles com mais de um pedido
SELECT idOrderClient, COUNT(*) AS totalOrders
FROM orders
GROUP BY idOrderClient
HAVING totalOrders > 1;

-- 6. Crie junções entre tabelas para fornecer a perspectiva mais complexa de dados
-- Recuperar detalhes dos pedidos e os clientes associados
SELECT o.idOrder, c.Fname, c.Lname, o.orderStatus
FROM orders o
JOIN client c ON o.idOrderClient = c.idClients;

-- Filtro e ordenação
-- Recuperar produtos com avaliação maior que 4.5, ordenados de forma decrescente
SELECT Pname, avaliação FROM product 
WHERE avaliação > 4.5 
ORDER BY avaliação DESC;

-- Junção com condição
-- Recuperar detalhes dos pedidos, clientes e produtos associados
SELECT o.idOrder, c.Fname, p.Pname, pp.quantidade 
FROM orders o
JOIN client c ON o.idOrderClient = c.idClients
JOIN produto_pedido pp ON o.idOrder = pp.idPedido
JOIN product p ON pp.idProduto = p.idProduct;

-- Fim dos testes


-- Finalizar
SELECT * FROM client;
SELECT * FROM fornecedor;
SELECT * FROM estoque;
SELECT * FROM terceiro;
SELECT * FROM product;
SELECT * FROM produtos_terceiro;
SELECT * FROM payments;
SELECT * FROM produto_estoque;
SELECT * FROM orders;
SELECT * FROM produto_pedido;
SELECT * FROM entrega;
