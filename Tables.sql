CREATE TABLE Airports (
    AirportID SERIAL PRIMARY KEY,
    Coodrinates POINT NOT NULL
    Name VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    MaxRunwayCapacity INT NOT NULL,
    MaxWarehouseCapacity INT NOT NULL
);

CREATE TABLE Planes (
    PlaneID SERIAL PRIMARY KEY,
    WorkingStatus VARCHAR(50) NOT NULL,
	LocationStatus VARCHAR(50) NOT NULL,
	MaxPassangerCapacity INT NOT NULL
    AirportID INT REFERENCES Airports(AirportID),
);

ALTER TABLE Planes
    ADD CONSTRAINT Check_working_status CHECK (
        WorkingStatus IN ('Active', 'For Sale', 'Under Repair', 'Dismantled')
    ),
    ADD CONSTRAINT Check_location_status CHECK (
        LocationStatus IN ('Runway', 'Warehouse', 'Air')
    )

CREATE TABLE Flights (
    FlightID SERIAL PRIMARY KEY,
    FlightCapacity INT,
    DepartureDate DATE NOT NULL,
    FinalDestination VARCHAR(50) NOT NULL,
    PlaneID INT REFERENCES Planes(PlaneID)
    AirportID INT REFERENCES Airports(AirportID),
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    LoyaltyCardExpiryDate DATE,
); 

CREATE TABLE Tickets (
    TicketID SERIAL PRIMARY KEY,
    FlightNumber VARCHAR(255) NOT NULL,
    SeatClass VARCHAR(1) NOT NULL,
    SeatNumber INT NOT NULL,
    TicketPrice REAL NOT NULL,
    PurchaseDate DATE NOT NULL,
	UserID INT REFERENCES Users(UserID),
	FlightID INT REFERENCES Flights(FlightID)
);

ALTER TABLE Tickets
    ADD CONSTRAINT Check_seat_class CHECK (
        SeatClass IN ('A', 'B')
    )

CREATE TABLE FlightPersonnel (
    PersonnelID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    FlightID INT REFERENCES Flights(FlightID)
);

ALTER TABLE FlightPersonnel
	ADD CONSTRAINT Check_Gender CHECK (Gender IN ('Male', 'Female')),
    ADD CONSTRAINT Check_Role CHECK (Role IN ('Pilot', 'Flight Attendant', 'Flight Engineer', 'Navigator')),
    ADD CONSTRAINT Check_Age CHECK (
        CASE 
            WHEN role = 'Pilot' THEN age >= 20 AND age <= 60
        ELSE true
        END
    );  

CREATE TABLE Reviews(
	ReviewID SERIAL PRIMARY KEY,
	CommentText TEXT,
	Rating INT NOT NULL,
	UserID INT REFERENCES Users(UserID)
);

ALTER TABLE Reviews
    ADD CONSTRAINT Check_Rating CHECK (Rating >= 1 AND Rating <= 5)




 






