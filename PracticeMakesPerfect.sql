USE PracticeDB

SELECT P.*,C.Name,(SELECT SUM([Count]) FROM Orders AS O WHERE O.ProductId = P.Id) 'TotalOrders', ((SELECT SUM([Count]) FROM Orders AS O WHERE O.ProductId = P.Id) * SalePrice) AS TotalSale FROM Products AS P
JOIN Categories AS C ON C.Id = P.CategoryId

CREATE PROCEDURE ProfitCalculator @Id INT
AS
SELECT SalePrice - CostPrice AS 'TotalProfit' FROM Products AS P WHERE @Id = P.Id

ALTER PROCEDURE ProfitCalculator @Id INT
AS
SELECT (SalePrice - CostPrice) * (SELECT SUM([Count]) FROM Orders AS O WHERE O.ProductId = P.Id) AS 'TotalProfit' FROM Products AS P WHERE @Id = P.Id

EXEC ProfitCalculator 2

CREATE VIEW VW_ProductInformations
AS
SELECT P.*,C.Name AS CategoryName,(SELECT (SalePrice - CostPrice) * (SELECT SUM([Count]) FROM Orders AS O WHERE O.ProductId = P.Id)) AS TotalProfit FROM Products AS P
JOIN Categories AS C ON C.Id = P.CategoryId

SELECT * FROM VW_ProductInformations

CREATE PROCEDURE SelectDate @MinDate DATETIME2, @MaxDate DATETIME2
AS
SELECT * FROM Products AS P WHERE P.ExpireDate BETWEEN @MinDate AND @MaxDate

ALTER PROCEDURE SelectDate @MinDate DATETIME2, @MaxDate DATETIME2
AS
SELECT *,(SELECT (SalePrice - CostPrice) * (SELECT SUM([Count]) FROM Orders AS O WHERE O.ProductId = P.Id)) AS TotalProfit FROM Products AS P WHERE P.ExpireDate BETWEEN @MinDate AND @MaxDate

EXEC SelectDate '2023-05-12','2023-05-15'
