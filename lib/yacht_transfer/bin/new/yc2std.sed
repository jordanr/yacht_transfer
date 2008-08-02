#n

# pre : Called with sed -f.  Input is a dump of the basic info and details html
# 	pages of a single boat on yachtworld.
# post: Mines the html file for data.  Ouputs data to stdout.

# basic info page
/^\*BASIC INFO\*/,/^\*DETAILS\*/ {
	
	#header data
	/strong>LOA:/ {
		# get next line
		n
		s/\o240//g
		s/.*>\([0-9]\+\).*/LENGTH~\1/p
	}
	
	/strong>Year:/ {
		# get next, next line
		n
		n
		s/\o240//g
		s/.*\([0-9]\{4\}\).*/YEAR~\1/p
	}
	
	/strong>Builder:/ {
		# get next line
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/MANUFACTURER~\1/p
	}
	
	/strong>Model:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/MODEL~\1/p
	}

	/strong>Category:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/CATEGORY~\1/p
	}

	/strong>Location:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/LOCATION~\1/p
	}


	/strong>Price:/ {
		# if US$ print next line
		n
		s/\o240//g
		s/,//g
		s/.*>(\([0-9]\+\).*/CURRENCY~USD\nPRICE~\1/p	
	}
	
	# dimensions
	/LOA:/ {
		n
		s/\o240//g
		s/.*>\([0-9'"]\+\).*/LOA~\1/p
	}
		
	/LWL:/ {
		n
		s/\o240//g
		s/.*>\([0-9'"]\+\).*/LWL~\1/p
	}

	/Beam:/ {
		n
		s/\o240//g
		s/.*>\([0-9'\''\"]\+\).*/BEAM~\1/p
	}

	/Min. Draft:/ {
		n
		s/\o240//g
		s/.*>\([0-9'\''\"]\+\).*/MIN DRAFT~\1/p
	}

	
	/Max. Draft:/ {
		n
		s/\o240//g
		s/.*>\([0-9'\''\"]\+\).*/MAX DRAFT~\1/p
	}

	/Clearance:/ {
		n
		s/\o240//g
		s/.*>\([0-9'\''\"]\+\).*/CLEARANCE~\1/p
	}
	
	#weights
	/Ballast Weight:/ {
		n
		s/\o240//g
		s/.*>\([0-9\.]\+\).*/BALLAST~\1/p
	}

	/Displacement:/ {
		n
		s/\o240//g
		s/.*>\([0-9\.]\+\).*/DISPLACEMENT~\1/p
	}

	/Gross Tonnage:/ {
		n
		s/\o240//g
		s/.*>\([0-9\.]\+\).*/TONNAGE~\1/p
	}

	/Ballast Material:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/BALLAST MATERIAL~\1/p
	}
	# approx cap speeds

	/Max Speed:/ {
		n
		s/\o240//g
		s/.*>\([0-9\.]\+\) .*/MAX SPEED~\1/p
	}

	/Cruise Speed:/ {
		n
		s/\o240//g
		s/.*>\([0-9\.]\+\) .*/CRUISE SPEED~\1/p
	}

	/Fuel Capacity:/ {
		n
		s/\o240//g
		s/.*>\([0-9.]\+\) .*/FUEL CAPACITY~\1/p
	}

	/Water Capacity:/ {
		n
		s/\o240//g
		s/.*>\([0-9.]\+\) .*/WATER CAPACITY~\1/p
	}

	/Holding Tank:/ {
		n
		s/\o240//g
		s/.*>\([0-9.]\+\) .*/HOLDING TANK CAPACITY~\1/p
	}

	/Fuel Consumption:/ {
		n
		s/\o240//g
		s/.*>\([0-9]\+\) .*/FUEL CONSUMPTION~\1/p
	}

	/Fuel Tank Material:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/FUEL TANK MATERIAL~\1/p
	}
	/Water Tank Material:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/WATER TANK MATERIAL~\1/p
	}	   
	    
	# hull and deck info

	/Hull Material:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/HULL MATERIAL~\1/p
	}

	/Hull Designer:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/DESIGNER~\1/p
	}

	/Deck Material:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/DECK MATERIAL~\1/p
	}

	/Interior Designer:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/INTERIOR DESIGNER~\1/p
	}

	/Hull Configuration:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/HULL CONFIGURATION~\1/p
	}

	/Exterior Designer:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/EXTERIOR DESIGNER~\1/p
	}
    	/Hull Color:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/HULL COLOR~\1/p
	}

	/Hull ID:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/HULL ID~\1/p
	}

    	/Hull Finished:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/HULL FINISH~\1/p
	}

	/Project Manager:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/MANAGER~\1/p
	}

	# engine info

	/Engine Fuel Type:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/FUEL TYPE~\1/p
	}

	/Engine Mfg.:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/ENGINE MANUFACTURER~\1/p
	}

	/Engine Model:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/ENGINE MODEL~\1/p
	}

	/Propulsion Type:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/PROPULSION TYPE~\1/p
	}

	/Engine Type:/ {
		n
		s/\o240//g
		s/.*>\([^-].*\)<.*/ENGINE TYPE~\1/p
	}

	/Engine #1/, /Engine #2/ {
		/Engine #1/ {
			# subtle move here, save Engine #1 in hold space
			h
			n
			n
			s/\o240//g
			s/[\t ]*\([0-9]\+\)<.*/HORSEPOWER~\1/p
		}
		/^<td width=\"15\%\"/ {
			n
			s/\o240//g
			s/[\t ]*\([0-9]\+\)<.*/ENGINE HOURS~\1/p
		}
	}# forget all else, ie. year, ov. date, serial #, for now
	
	# now use the hold space below
	/Engine #/,/strong>Presented By/ {
		/Engine #/ {
			s/\o240//g
			h
		}
		# retrieve and finish the engine num off below	
		/strong>Presented By/ {
			x
			s/.*Engine #\([0-9]\).*/NUMBER OF ENGINES~\1/p
		}
	}
}

# Details page
/^\*DETAILS\*/,$ {
	s/\o240//
	s/^<font color.*3333CC\">\(.*\)<.*/TITLE~\1\nBODY~/p
	/titlebisection/, $ {
	    /<table cellpadding=\"2\" cellspacing=\"2\" width=\"100%\" align=\"center\">/,/<\/table>/ {
		    /<table.*/d
		    /<\/table>/d
    		    s/\o240//
		    s/\r//g
		    s///g
		    s/\t//g
		    s/<\/td>//g
		    s/<td>//g
		    s/<tr>//g
		    s/<\/tr>//g
		    /^$/d
		    s/\(.*\)/\1/p
	    }
	}
}
