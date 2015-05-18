export testSuite

const testSuite <- object testSuite
	const home <- (locate self)
	var serverInterfaces : Array.of[ClonableType]

	operation produceData -> [keys : Array.of[String], objects : Array.of[FilmDataType]]
		keys <- Array.of[String].create[0]
		objects <- Array.of[FilmDataType].create[0]
		keys.addUpper["Deer Hunter"]
		objects.addUpper[FilmDataCreator.create["The Deer Hunter", "Robert DeNiro", "1979"]]
		keys.addUpper["Waking Life"]
		objects.addUpper[FilmDataCreator.create["Waking Life", "Ethan Hawk", "2001"]]
		keys.addUpper["Godfather"]
		objects.addUpper[FilmDataCreator.create["The Godfather", "Marlon Brando", "1972"]]
		keys.addUpper["Her"]
		objects.addUpper[FilmDataCreator.create["Her", " Joaquin Phoenix", "2013"]]	
	end produceData

	process
		%(locate self).delay[Time.create[2,0]]
		var keys : Array.of[String] 
		var objects : Array.of[FilmDataType]
		(locate self)$stdout.putstring["TestSuit Debug 1.  " || "\n"]
		keys, objects  <- self.produceData
		(locate self)$stdout.putstring["TestSuit Debug 2.  " || "\n"]
		var testRep : ClonableType <- nameServerConstructor.create[0, 0, keys, objects]
		serverInterfaces <- framework.replicateMe[testRep, 2]
		(locate self).delay[Time.create[6,0]]
		var insertData : Array.of[any] <- Array.of[any].create[0]
		insertData.addUpper["Godfather 2"]
		insertData.addUpper[FilmDataCreator.create["The Godfather 2", "Al Pacino", "1974"]]
		(locate self)$stdout.putstring["TestSuit Debug 3.  " || "\n"]
		serverInterfaces[1].setData[insertData]
		(locate self)$stdout.putstring["TestSuit Debug 4.  " || "\n"]
		insertData.addUpper["Godfather 3"]
		insertData.addUpper[FilmDataCreator.create["Taxi Driver", "Robert De Niro", "1976"]]
		serverInterfaces[0].setData[insertData]

		unavailable
			(locate self)$stdout.putstring["TestSuit Prosess. Unavailable " || "\n"]
		end unavailable
		
	end process
end testSuite

