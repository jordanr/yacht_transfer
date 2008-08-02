#n

# pre :Called with sed -f. Input is standardized yacht data.
# post: Converts standard data to yw format.

s/^LENGTH~\([0-6][0-9]\)$/length~\1\nvalue_3~0/p
s/^LENGTH~\([[7-9][0-9]\)$/length~\1\nvalue_3~1/p
s/^LENGTH~\([0-9]\{3,\}\)/length~\1\nvalue_3~1/p
s/^MODEL~/model~/p
s/^YEAR~\([0-9]\{4\}\)/model_year~\1\nbuilt_in_year~\1/p
s/^PRICE~/ask_price~/p
s/^CURRENCY~USD/ask_price_currency_id~US Dollar/p
s/^CURRENCY~EUR/ask_price_currency_id~Euro/p
s/^LOCATION~/city~/p
s/^HULL MATERIAL~Wood/hull_materials_id~3/p
s/^HULL MATERIAL~Steel/hull_materials_id~2/p
s/^HULL MATERIAL~Aluminum/hull_materials_id~6/p
s/^HULL MATERIAL~Fiberglass/hull_materials_id~1/p
s/^HULL MATERIAL~Composite/hull_materials_id~5/p
s/^HULL MATERIAL~Ferro-Cement/hull_materials_id~9/p
s/^HULL MATERIAL~Other/hull_materials_id~7/p

# sail boat we guess
s/^NUMBER OF ENGINES~1/number_of_engines~Single\nvalue_2~1/p
s/^NUMBER OF ENGINES~2/number_of_engines~Twin\nvalue_2~2/p
s/^FUEL TYPE~/fuel_types_id~/p

s/^NAME~/name~/p

s/^MANUFACTURER~/vessel_manufacturer_name~/p
s/^DESIGNER~/hull_designer~/p

s/^LOA~/lod~/p
s/^LWL~/lwl~/p
s/^BEAM~/beam~/p
s/^DISPLACEMENT/displacement~/p
s/^MIN DRAFT~/draft_min~/p

s/^BALLAST~/ballase_weight~/p

s/^CLEARANCE~/bridge_clearance~/p

s/^ENGINE MANUFACTURER~/engines_manufacturers_name~/p
s/^HORSEPOWER~/horse_power1~/p
s/^ENGINE MODEL~/engine_model~/p
s/^CRUISE SPEED~/cruise_speed~/p
s/^ENGINE HOURS~/num_hours1~/p
s/^MAX SPEED~/max_speed~/p
  
s/^FUEL CAPACITY~/fuel_capacity~/p
s/^WATER CAPACITY~/water_capacity~/p
s/^HOLDING TANK CAPACITY~/holding_tank~/p

/^TITLE~/p
/^BODY~/p
# this one below must be before the two above 
# the the script matches the line twice
s/^DESCRIPTION~\(.*\)$/TITLE~Description\nBODY~\1/p
