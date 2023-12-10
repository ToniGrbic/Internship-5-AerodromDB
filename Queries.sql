-- ispis imena i modela svih aviona s kapacitetom većim od 100 
SELECT Name, Model FROM Planes
WHERE MaxPassangerCapacity > 100;

-- ispis svih karata čija je cijena između 100 i 200 eura
SELECT * FROM Tickets
WHERE TicketPrice BETWEEN 100 AND 200;

-- ispis svih pilotkinja s više od 20 odrađenih letova do danas
SELECT Name, COUNT(*) as FlightsNumber  FROM FlightPersonnel fp
WHERE fp.Gender = 'Female' && FlightsNumber > 1;



