CREATE TABLE People
(dukeCardNumber INTEGER NOT NULL PRIMARY KEY,
netId VARCHAR(10) NOT NULL UNIQUE,
name VARCHAR(30) NOT NULL,
mealPlan CHAR(1) NOT NULL,
CHECK(mealPlan = 'A' OR mealPlan = 'B' OR mealPlan = 'C' OR mealPlan = 'D'
        OR mealPlan = 'E' OR mealPlan = 'F' OR mealPlan = 'H' OR mealPlan = 'I' $
        mealPlan = 'J')
);

CREATE TABLE Vendor
(name VARCHAR(30) NOT NULL PRIMARY KEY
);

CREATE TABLE TimesOpen
(day VARCHAR(9) NOT NULL,
openTime TIME NOT NULL,
closeTime TIME NOT NULL,
PRIMARY KEY (day, openTime, closeTime)
);

CREATE TABLE IsOpenAt
(vendorName VARCHAR(30) NOT NULL,
day VARCHAR(9) NOT NULL,
openTime TIME NOT NULL,
closeTime TIME NOT NULL,
PRIMARY KEY(vendorName, day, openTime, closeTime),
FOREIGN KEY(vendorName) REFERENCES Vendor(name),
FOREIGN KEY(openTime,closeTime,day) REFERENCES TimesOpen(openTime,closeTime,day)
);
-- Note: Don't have overlapping open times on the same day (e.g., Skillet who cl$

CREATE TABLE Food
(name VARCHAR(45) NOT NULL,
vendorName VARCHAR(30) NOT NULL,
price FLOAT NOT NULL,
calories INTEGER,
carbs INTEGER,
protein INTEGER,
fat INTEGER,
PRIMARY KEY(name, vendorName),
FOREIGN KEY(vendorName) REFERENCES Vendor(name)
);

CREATE TABLE IsAvailableAt
(foodName VARCHAR(45) NOT NULL,
vendorName VARCHAR(30) NOT NULL,
day VARCHAR(9) NOT NULL,
openTime TIME NOT NULL,
closeTime TIME NOT NULL,
PRIMARY KEY (foodName, vendorName, day, openTime, closeTime),
FOREIGN KEY(foodName,vendorName) REFERENCES Food(name,vendorName),
FOREIGN KEY(openTime,closeTime,day) REFERENCES TimesOpen(openTime,closeTime,day)
);

CREATE TABLE Transactions
(dukeCardNumber INTEGER NOT NULL,
vendorName VARCHAR(30) NOT NULL,
timestamp TIMESTAMP NOT NULL,
price FLOAT NOT NULL,
PRIMARY KEY (dukeCardNumber, timestamp),
FOREIGN KEY(dukeCardNumber) REFERENCES People(dukeCardNumber),
FOREIGN KEY(vendorName) REFERENCES Vendor(name)
);

CREATE TABLE FoodLog
(dukeCardNumber INTEGER NOT NULL,
timestamp TIMESTAMP NOT NULL,
quantity FLOAT NOT NULL,
foodName VARCHAR(45) NOT NULL,
vendorName VARCHAR(30) NOT NULL,
PRIMARY KEY(dukeCardNumber, timestamp, foodName, vendorName),
FOREIGN KEY(dukeCardNumber) REFERENCES People(dukeCardNumber),
FOREIGN KEY(foodName,vendorName) REFERENCES Food(name,vendorName)
);
-- We will convert to MySQL if syntax differs
CREATE FUNCTION VendorOpenWhenFoodPurchased() RETURNS TRIGGER AS $$
BEGIN
 IF NOT EXISTS(SELECT * FROM isOpenAt WHERE 
        NEW.vendorName=isOpenAt.vendorName AND 
        NEW.day=IsOpenAt.day AND
        NEW.openTime >= IsOpenAt.openTime AND NEW.closeTime <= IsOpenAt.closeTim$
THEN RAISE EXCEPTION 'Vendor cannot vend food when it is closed.';
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER VendorOpen
  BEFORE INSERT OR UPDATE ON IsAvailableAt
  FOR EACH ROW
  EXECUTE PROCEDURE VendorOpenWhenFoodPurchased();

