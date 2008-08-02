#n

# pre : Called with sed -f.  Input is a dump of the display ad and full specs
# html pages of a single boat on yachtworld.
# post: Mines the html for usable data and outputs with standardized values.

# for the display page
/^\*DISPLAY AD\*$/,/^\*FULL SPECS\*$/ {
	#just get the broker teaser
	/.*Verdana, Helvetica, sans-serif\">/,/^<\/td><\/tr>/ {
		/^<\/td><\/tr>$/d
		s///g
  		s/\t//g
		s/.*Verdana, Helvetica, sans-serif\">\(.*\)/DESCRIPTION~\1/
		s/\(.*\)<\/font>/\1/
		s/\(.*\)/\1/p
	}
}

# from the keyword *FULL SPECS* onward--the full specs page
/^\*FULL SPECS\*$/,$ {
	s/.*<h1>\([0-9]\+\). \(.*\)<\/h1>/LENGTH~\1\nMODEL~\2/p

	s/.*Year: *\([0-9]\+\).*/YEAR~\1/p
	/.*EUR\&nbsp;\&nbsp;\([0-9,]\+\).*<.*/ {
		s/,//g
		s/.*EUR\&nbsp;\&nbsp;\([0-9]\+\).*<.*/PRICE~\1\nCURRENCY~EUR/p
	}
	/.*US$\&nbsp;\([0-9,]\+\).*<.*/ {
		s/,//g
		s/.*US$\&nbsp;\([0-9]\+\).*<.*/PRICE~\1\nCURRENCY~USD/p
	}

	s/.*Located In \(.*\)/LOCATION~\1/p

	s/.*Hull Material: \(.*\)/HULL MATERIAL~\1/p

	/.*Engine\/Fuel Type: \(.*\) \(.*\)/ {
		/Single/ {
			a\NUMBER OF ENGINES~1
		}
		/Twin/ {
			a\NUMBER OF ENGINES~2
		}
		/Diesel/ {
			a\FUEL TYPE~Diesel
		}
		/Gas/ {
			a\FUEL TYPE~Gas\/Petrol
		}
		/Other/ {
			a\FUEL TYPE~Other
		}
	}

	/.*fine>\(.*\)\&nbsp;.*/ {
		/Click on image to enlarge/ {
			s/.*fine>\(.*\)\&nbsp;.*/NAME~no name/p
		}
		/Click on image to enlarge/ !{
			s/.*fine>\(.*\)\&nbsp;.*/NAME~\1/p
		}
	}
	s/.*Builder: \(.*\)<.*/MANUFACTURER~\1/p
	s/.*Designer: \(.*\)<.*/DESIGNER~\1/p

	s/.*LOA: \([0-9"']*\).*<.*/LOA~\1/p
	s/.*LWL: \([0-9"']*\).*<.*/LWL~\1/p
	s/.*Beam: \([0-9"']*\).*<.*/BEAM~\1/p

	/.*Displacement: \([0-9,]*\).*<.*/ {
		s/,//	
		s/.*Displacement: \([0-9]*\).*<.*/DISPLACEMENT~\1/p
	}
	s/.*Draft: \([0-9"']*\).*<.*/MIN DRAFT~\1/p

	/.*Ballast: \([0-9,]*\).*<.*/ {
		s/,//
		s/.*Ballast: \([0-9]*\).*<.*/BALLAST~\1/p
	}
	s/.*Bridge Clearance: \([0-9"']*\).*<.*/CLEARANCE~\1/p

	s/.*Engine(s): \(.*\)<.*/ENGINE MANUFACTURER~\1/p
	s/.*Engine(s) HP: \([0-9,]*\).*<.*/HORSEPOWER~\1/p
	s/.*Engine Model: \(.*\)<.*/ENGINE MODEL~\1/p
	s/.*Cruising Speed: \([0-9,]*\).*<.*/CRUISE SPEED~\1/p
	s/.*Hours: \([0-9,]*\).*<.*/ENGINE HOURS~\1/p
	s/.*Max Speed: \([0-9,]*\).*<.*/MAX SPEED~\1/p
  
	s/.*Fuel: \([0-9,]*\).*<.*/FUEL CAPACITY~\1/p
	s/.*Water: \([0-9,]*\).*<.*/WATER CAPACITY~\1/p
	s/.*Holding: \([0-9,]*\).*<.*/HOLDING TANK CAPACITY~\1/p

	# these lines below screw up our accomodations lines below,below
	/<b>Toll.*<\/b><br>/d
	/<b>Disclaimer<\/b><br>/d
	# get the acccomodations, etc.
	/^<b>.*<\/b><br>$/,/^<table valign=top>$/ {
		s/^<b>\(.*\)<\/b><br>$/TITLE~\1\nBODY~/
		/^<table valign=top>$/d
		s///g
	  	s/\t//g
		/^$/d
		s/\(.*\)/\1/p
	}
	/^<td valign=top align=[leftright]\+><ul>$/,/^<\/ul><\/td>$/ {
		s/<\/td>//g
		s/<td valign=top align=[leftright]\+>//g
		s///g
 		s/\t//g
		/^$/d
		s/\(.*\)/\1/p
	}
}
