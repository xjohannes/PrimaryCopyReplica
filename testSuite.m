export testSuite

const testSuite <- object testSuite
	const home <- (locate self)
	var serverInterfaces : Array.of[ClonableType] <- Array.of[ClonableType].create[0]

	

	process
		var insertData : Array.of[any] <- Array.of[any].create[0]
		var input : String <- "Godfather 2"
		var testRep : ClonableType <- nameServerConstructor.create[0, 0]
		
		serverInterfaces <- framework.replicateMe[testRep, 2]
		(locate self)$stdout.putstring["TestSuit: Asking framework to insert 'Godfather 2' (in Primary replica):  " || "\n"]
		insertData.addUpper[input]
		insertData.addUpper[FilmDataCreator.create["The Godfather 2", "Al Pacino", "1974"]]
		serverInterfaces[0].setData[insertData]
		insertData <- Array.of[Any].create[0]
		
		var i : Integer <- 0
		loop
			exit when serverInterfaces.upperbound > 0
			begin
				(locate self).delay[Time.create[2,0]]
				serverInterfaces <- framework.refreshProxyList
			end
		end loop
				
		insertData.addUpper[(view "Taxi Driver" as Any)]
		(locate self)$stdout.putstring["TestSuit: Asking framework to insert 'Taxi Driver' (in ordinary replica):  " || "\n"]
		insertData.addUpper[(view FilmDataCreator.create["Taxi Driver", "Robert De Niro", "1976"] as Any)]
		serverInterfaces[1].setData[insertData]
		
		(locate self).delay[Time.create[2,0]]
		
		(locate self)$stdout.putstring["TestSuit: Asking framework to get 'Taxi Driver' (from primary).  " || "\n"]
		var dataPacked : Any <- serverInterfaces[0].getData["Taxi Driver"]
		var dataUnpacked : FilmDataType <- view dataPacked as FilmDataType
		(locate self)$stdout.putstring["Printing results from query: " || "\n\n"]
		dataUnpacked.print
		
		unavailable
			(locate self)$stdout.putstring["TestSuit Process. Unavailable " || "\n"]
		end unavailable
		%failure
			%(locate self)$stdout.putstring["TestSuite. Failure. Process" ||"\n"]
		%end failure
	end process
end testSuite

