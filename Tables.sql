CREATE TABLE Airports (
    AirportID SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    MaxRunwayCapacity INT NOT NULL,
    MaxWarehouseCapacity INT NOT NULL
);

ALTER TABLE Airports
	ADD COLUMN Coordinates POINT NOT NULL

CREATE TABLE Planes (
    PlaneID SERIAL PRIMARY KEY,
    WorkingStatus VARCHAR(50) NOT NULL,
	LocationStatus VARCHAR(50) NOT NULL,
    AirportID INT REFERENCES Airports(AirportID),
	MaxPassangerCapacity INT NOT NULL
);

CREATE TABLE Flights (
    FlightID SERIAL PRIMARY KEY,
    FlightCapacity INT,
    PlaneID INT REFERENCES Planes(PlaneID)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    LoyaltyCardExpiryDate DATE,
    LoyaltyCardCreationDate DATE
); 

CREATE TABLE Tickets (
    TicketID SERIAL PRIMARY KEY,
    FlightNumber VARCHAR(255) NOT NULL,
    SeatNumber VARCHAR(5) NOT NULL,
    TicketPrice REAL NOT NULL,
    PurchaseDate DATE NOT NULL,
	UserID INT REFERENCES Users(UserID),
	FlightID INT REFERENCES Flights(FlightID)
);

CREATE TABLE FlightPersonnel (
    PersonnelID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    FlightID INT REFERENCES Flights(FlightID)
);

CREATE TABLE Comments(
	CommentID SERIAL PRIMARY KEY,
	CommentText TEXT,
	Rating INT,
	UserID INT REFERENCES Users(UserID)
);




 






