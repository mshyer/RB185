CREATE TABLE expenses (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  amount numeric(6, 2) NOT NULL,
  memo text NOT NULL,
  created_on date NOT NULL
);
INSERT INTO expenses (amount, memo, created_on)
  VALUES  (9999.99, 'woohoo what fun', '11-11-1993');
INSERT INTO expenses (amount, memo, created_on)
  VALUES  (-9999.99, 'woohoo what fun', '11-11-1993');

DELETE FROM expenses WHERE id = 2;

ALTER TABLE expenses
ADD CONSTRAINT positive_amount CHECK (amount >= 0.01);