#n

# pre :Called with sed -f. Input is standardized yacht data.
# post: Converts standard data to yw format.

s/^DESCRIPTON/description/p
s/^MANUFACTURER/maker/p
s/^LENGTH/length/p
s/^YEAR~\([0-9]\{4\}\)/year~\1/p
s/^PRICE/price/p
s/^MODEL/model/p
s/^CURRENCY/currency/p

/^FUEL TYPE/ {
	s/FUEL TYPE/fuel/
	s/Gas/Gas\/Petrol/
	s/Petrol/Gas\/Petrol/
	p
}
/^HULL MATERIAL/ {
	s/HULL MATERIAL/hull_material/
	s/Other/Other\/NA/
	#add more here
	p
}
s/^LOCATION/boat_city/p
/^NUMBER OF ENGINES/ {
	s/NUMBER OF ENGINES/engine_num/
	s/[0,4-9]/3/
	p
}

s/^LOCATION~/boat_city~/p

###### yanked below
s/^DESIGNER~/designer~/p

s/^LOA~/loa~/p
s/^LWL~/lwl~/p
s/^BEAM~/beam~/p
s/^DISPLACEMENT/displacement~/p
s/^MIN DRAFT~/draft~/p

s/^BALLAST~/ballast~/p

s/^CLEARANCE~/clearance~/p

s/^ENGINE MANUFACTURER~/engines~/p
s/^HORSEPOWER~/engines_hp~/p
s/^ENGINE MODEL~/engine_model~/p
s/^CRUISE SPEED~/cruising_speed~/p
s/^ENGINE HOURS~/engine_hours~/p
s/^MAX SPEED~/max_speed~/p

s/^FUEL CAPACITY~/fuel_tank~/p
s/^WATER CAPACITY~/water_tank~/p
s/^HOLDING TANK CAPACITY~/holding_tank~/p

/^TITLE~/p
/^BODY~/p
