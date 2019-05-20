module org::maracas::match::struc::Data


data Data
	= string(
		real threshold = 0.0,
		map[loc elem, str repr] from = {},
		map[loc elem, str repr] to = {}
	);