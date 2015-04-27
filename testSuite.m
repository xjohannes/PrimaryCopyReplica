export testSuite

const testSuite <- object testSuite

	process
		var testRep:replicaType <- nameServerConstructor.create[]
		if testRep == nil then
			(locate self)$stdout.putstring["Debug. TESTSUITE: process " || "\n"]
		end if
		framework.replicateMe[testRep, 2]
		framework.insert["John Lennon"]
	end process
end testSuite