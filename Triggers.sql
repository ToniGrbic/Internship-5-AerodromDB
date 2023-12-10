--Trigger to check if the flight capacity is greater than the max passenger capacity of the plane
CREATE OR REPLACE FUNCTION check_flight_capacity()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.FlightCapacity > (SELECT MaxPassengerCapacity FROM Planes WHERE PlaneID = NEW.PlaneID) THEN
        RAISE EXCEPTION 'FlightCapacity cannot be greater than MaxPassengerCapacity';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--create trigger
CREATE TRIGGER enforce_flight_capacity
    BEFORE INSERT OR UPDATE
    ON Flights
    FOR EACH ROW
    EXECUTE FUNCTION check_flight_capacity();

--Trigger to check if the loyalty card is valid
CREATE OR REPLACE FUNCTION check_loyalty_card_function()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.LoyaltyCardExpiryDate IS NULL AND (
        SELECT COUNT(*) FROM tickets WHERE UserID = NEW.UserID
    ) < 10 THEN
        RAISE EXCEPTION 'Loyalty card requires at least 10 purchased tickets.';
    END IF;

    IF NEW.LoyaltyCardExpiryDate IS NOT NULL AND (
        SELECT COUNT(*) FROM tickets WHERE UserID = NEW.UserID
    ) < 10 AND NEW.LoyaltyCardExpiryDate > CURRENT_DATE THEN
        RAISE EXCEPTION 'Loyalty card requires at least 10 purchased tickets and must expire in the future.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--create trigger
CREATE TRIGGER check_loyalty_card_trigger
BEFORE INSERT OR UPDATE
ON Users
FOR EACH ROW
EXECUTE FUNCTION check_loyalty_card_function();
