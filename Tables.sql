-- query 1
CREATE TABLE Cities (
    CityID SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Longitude DOUBLE NOT NULL,
    Latitude DOUBLE NOT NULL,
    GeoLocation Point NOT NULL
);

CREATE TABLE Airports (
    AirportID SERIAL PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    MaxRunwayCapacity INT NOT NULL,
    MaxWarehouseCapacity INT NOT NULL,
    CityID INT REFERENCES Cities(CityID)
);
-- query 2
CREATE TABLE Planes (
    PlaneID SERIAL PRIMARY KEY,
    Model VARCHAR(50) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    WorkingStatus VARCHAR(50) NOT NULL,
	LocationStatus VARCHAR(50) NOT NULL,
	MaxPassangerCapacity INT NOT NULL,
    AirportID INT REFERENCES Airports(AirportID)
);

ALTER TABLE Planes
    ADD CONSTRAINT Check_working_status CHECK (
        WorkingStatus IN ('Active', 'For Sale', 'Under Repair', 'Dismantled')
    ),
    ADD CONSTRAINT Check_location_status CHECK (
        LocationStatus IN ('Runway', 'Warehouse', 'Air')
    )

-- query 3
CREATE TABLE Flights (
    FlightID SERIAL PRIMARY KEY,
    FlightCapacity INT,
    DepartureDate DATE NOT NULL,
    FinalDestination VARCHAR(50) NOT NULL,
    PlaneID INT REFERENCES Planes(PlaneID),
    AirportID INT REFERENCES Airports(AirportID)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    LoyaltyCardExpiryDate DATE
); 
-- query 4
CREATE TABLE Tickets (
    TicketID SERIAL PRIMARY KEY,
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
    
--query 5
CREATE TABLE FlightPersonnel (
    PersonnelID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    MonthlySalary INT NOT NULL,
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
-- query 6
CREATE TABLE Reviews(
	ReviewID SERIAL PRIMARY KEY,
	CommentText TEXT,
	Rating INT NOT NULL,
	UserID INT REFERENCES Users(UserID)
    FlightID INT REFERENCES Flights(FlightID)
);

ALTER TABLE Reviews
    ADD CONSTRAINT Check_Rating CHECK (Rating >= 1 AND Rating <= 5)




 






