export testSuite

const testSuite <- object testSuite
	const home <- (locate self)
	var serverInterfaces : Array.of[ReplicaType]

	process
		%(locate self).delay[Time.create[2,0]]
		var testRep : ClonableType <- nameServerConstructor.create
		serverInterfaces <- framework.replicateMe[testRep, 2]
		unavailable
			(locate self)$stdout.putstring["TestSuit Prosess. Unavailable " || "\n"]
		end unavailable
		failure
			(locate self)$stdout.putstring["TestSuite Failure: 4. Process." ||"\n"]
		end failure
	end process
end testSuite