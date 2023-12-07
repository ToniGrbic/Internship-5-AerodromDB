CREATE OR REPLACE FUNCTION check_flight_capacity()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.FlightCapacity > (SELECT MaxPassengerCapacity FROM Planes WHERE PlaneID = NEW.PlaneID) THEN
        RAISE EXCEPTION 'FlightCapacity cannot be greater than MaxPassengerCapacity';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_flight_capacity
    BEFORE INSERT OR UPDATE
    ON Flights
    FOR EACH ROW
    EXECUTE FUNCTION check_flight_capacity();