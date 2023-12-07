ALTER TABLE FlightPersonnel
	ADD CONSTRAINT Check_Gender CHECK (Gender IN ('Male', 'Female'))