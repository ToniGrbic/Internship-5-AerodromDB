-- ispis imena i modela svih aviona s kapacitetom većim od 100 
SELECT Name, Model FROM Planes
WHERE MaxPassangerCapacity > 100;

-- ispis svih karata čija je cijena između 100 i 200 eura
SELECT * FROM Tickets
WHERE TicketPrice BETWEEN 100 AND 200;

-- ispis svih pilotkinja s više od 20 odrađenih letova do danas


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






