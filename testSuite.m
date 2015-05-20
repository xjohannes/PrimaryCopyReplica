export testSuite

const testSuite <- object testSuite
	const home <- (locate self)
	var serverInterfaces : Array.of[ClonableType] <- Array.of[ClonableType].create[0]

	export operation produceInitData -> [keys : Array.of[String], objects : Array.of[FilmDataType]]
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
	end produceInitData
	

	process
		var insertData : Array.of[any] <- Array.of[any].create[0]
		var input : String <- "Godfather 2"
		var keys : Array.of[String] <- Array.of[String].create[0]
		var objects : Array.of[FilmDataType] <- Array.of[FilmDataType].create[0]
		keys, objects <- self. produceInitData
		var testRep : ClonableType <- nameServerConstructor.create[0, keys, objects]
		
		serverInterfaces <- framework.replicateMe[testRep, 2]
		(locate self)$stdout.putstring["TestSuit: Asking framework to insert 'Godfather 2' (in Primary replica):  " || "\n"]
		insertData.addUpper[input]
		insertData.addUpper[FilmDataCreator.create["The Godfather 2", "Al Pacino", "1974"]]
		(locate self).delay[Time.create[2,0]]
		serverInterfaces[0].print["Files in primary before inserting: " || input]
		serverInterfaces[0].setData[insertData]
		(locate self).delay[Time.create[2,0]]
		serverInterfaces[0].print["Files in primary after inserting: " || input]
		insertData <- Array.of[Any].create[0]
		
		var i : Integer <- 0
		loop
			exit when serverInterfaces.upperbound > 0
			begin
				(locate self).delay[Time.create[2,0]]
				serverInterfaces <- framework.refreshProxyList
			end
		end loop
		input <- "Taxi Driver"
		insertData.addUpper[input]
		(locate self)$stdout.putstring["TestSuit: Asking framework to insert 'Taxi Driver' (in ordinary replica):  " || "\n"]
		insertData.addUpper[(view FilmDataCreator.create["Taxi Driver", "Robert De Niro", "1976"] as Any)]
		serverInterfaces[0].print["Files in primary before inserting: " || input]
		serverInterfaces[1].print["Files in primary before inserting: " || input]
		serverInterfaces[1].setData[insertData]
		serverInterfaces[0].print["Files in primary after inserting: " || input]
		serverInterfaces[1].print["Files in primary after inserting: " || input]
		
		(locate self).delay[Time.create[2,0]]
		
		(locate self)$stdout.putstring["TestSuit: Asking framework to get 'Taxi Driver' (from primary).  " || "\n"]
		var dataPacked : Any <- serverInterfaces[0].getData["Taxi Driver"]
		var dataUnpacked : FilmDataType <- view dataPacked as FilmDataType
		(locate self)$stdout.putstring["Printing results from query: " || "\n\n"]
		dataUnpacked.print["From test suite: "]
		(locate self)$stdout.putstring["End Printing results from query: " || "\n\n"]
		
		unavailable
			(locate self)$stdout.putstring["TestSuit Process. Unavailable " || "\n"]
		end unavailable
		%failure
			%(locate self)$stdout.putstring["TestSuite. Failure. Process" ||"\n"]
		%end failure
	end process
end testSuite

