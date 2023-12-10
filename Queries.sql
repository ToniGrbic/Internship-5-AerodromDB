-- ispis imena i modela svih aviona s kapacitetom većim od 100 
SELECT Name, Model FROM Planes
WHERE MaxPassangerCapacity > 100;

-- ispis svih karata čija je cijena između 100 i 200 eura
SELECT * FROM Tickets
WHERE TicketPrice BETWEEN 100 AND 200;

-- ispis svih pilotkinja s više od 20 odrađenih letova do danas
SELECT fp.FirstName, fp.LastName
FROM FlightPersonnel fp
WHERE fp.Role = 'Pilot' AND fp.Gender = 'Female' AND (
    SELECT COUNT(*)
    FROM Flights f
    WHERE f.FlightID = fp.FlightID AND f.DepartureDate <= CURRENT_DATE
) > 20;

--ispis broja letova iz/za Split u 2023. godini
SELECT COUNT(*) as NumberOfFlights --SELECT * za provjeru  
FROM Flights fl
WHERE (fl.FinalDestination = 'Split' 
       OR fl.AirportID IN (SELECT AirportID FROM Airports a WHERE 
	   (SELECT CityId FROM Cities c WHERE c.Name = 'Split') = a.CityID)) 
AND DATE_PART('year', fl.DepartureDate) = 2023;

-- ispis svih domaćina/ca zrakoplova koji su trenutno u zraku
SELECT FirstName, LastName, Role
FROM FlightPersonnel fp
WHERE fp.FlightID IN (
    SELECT FlightID FROM Flights WHERE PlaneID IN (
        SELECT PlaneID FROM Planes WHERE LocationStatus = 'Air'
    )
);

-- ispis svih letova za beč u prosincu 2023.
SELECT * FROM Flights fl
WHERE fl.FinalDestination = 'Vienna' 
AND DATE_PART('year',DepartureDate ) = 2023
AND DATE_PART('month',DepartureDate ) = 12

-- ispis broja prodanih Economy letova 2021
SELECT * FROM Tickets t
WHERE t.SeatClass = 'B' AND DATE_PART('year', t.PurchaseDate) = 2021;

-- ispis prosječne ocjene letova kompanije AirDUMP
SELECT ROUND(AVG(r.Rating), 4) as AverageRating
FROM Reviews r
WHERE r.FlightID IN (
    SELECT FlightID FROM Flights WHERE PlaneID IN (
        SELECT PlaneID FROM Planes WHERE Model = 'AirDUMP'
    )
);

-- ispis svih aerodroma u Londonu, sortiranih po broju Airbus aviona trenutno na njihovim pistama
SELECT a.Name, 
    (SELECT COUNT(*) 
     FROM Planes p 
     WHERE p.AirportID = a.AirportID AND p.LocationStatus = 'Runway' AND p.Model LIKE 'Airbus%') as NumberOfAirbus
FROM Airports a
WHERE a.CityID IN (
    SELECT CityID FROM Cities WHERE Name = 'London'
)
ORDER BY NumberOfAirbus DESC;

-- ispis svih aerodroma udaljenih od Splita manje od 1500km
-- dosta pomogao chatGPT
SELECT a.Name
FROM Airports a
JOIN Cities c ON a.CityID = c.CityID
WHERE earth_distance(
    ll_to_earth(c.Latitude, c.Longitude),
    ll_to_earth((SELECT Latitude FROM Cities WHERE Name = 'Split'), 
                (SELECT Longitude FROM Cities WHERE Name = 'Split'))
) < 1500 * 1000;

--smanjite cijenu za 20% svim kartama čiji letovi imaju manje od 20 ljudi
UPDATE Tickets
SET TicketPrice = TicketPrice * 0.8
WHERE (
    SELECT COUNT(*) FROM Tickets t2 WHERE t2.FlightID = Tickets.FlightID
) < 20;

--povisite plaću za 100 eura svim pilotima koji su ove godine imali više od 10 letova duljih od 10 sati
--comment: posto nisam stavio nigdje stupac koliko let traje ili kada je sletio, 
--ovaj query nece raditi na mojoj bazi, nepostoji Flights.FlightDuration. Podaci su vec seedani.
UPDATE FlightPersonnel
SET MonthlySalary = MonthlySalary + 100
WHERE Role = 'Pilot' AND (
    SELECT COUNT(*)
    FROM Flights f
    WHERE f.FlightID = FlightPersonnel.FlightID 
    AND f.FlightDuration > 10 
    AND DATE_PART('year', f.DepartureDate) = DATE_PART('year', CURRENT_DATE)
) > 10;

--razmontirajte avione starije od 20 godina koji nemaju letove pred sobom
--takoder nece raditi na mojoj bazi jer nisam stavio Age u Planes
UPDATE Planes
SET WorkingStatus = 'Dismantled'
WHERE Age > 20;

-- izbrisite sve letove koji nemaju nijednu prodanu kartu
--prvo izbrisati fk reference iz FlightPersonnel
DELETE FROM FlightPersonnel
WHERE FlightID NOT IN (
    SELECT FlightID FROM Tickets
);
--zatim Reviews
DELETE FROM Reviews
WHERE FlightID NOT IN (
    SELECT FlightID FROM Tickets
);
-- konacno Flights
DELETE FROM Flights
WHERE FlightID NOT IN (
    SELECT FlightID FROM Tickets
);

-- izbrišite sve kartice vjernosti putnika čije prezime završava na -ov/a, -in/a
DELETE FROM Users
WHERE Users.LoyaltyCardExpiryDate IS NOT NULL AND (LastName LIKE '%ov' OR LastName LIKE '%in');
















