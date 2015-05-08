export testSuite

const testSuite <- object testSuite
	const home <- (locate self)
	process
		%(locate self).delay[Time.create[3 , 0]]
		%var testRep : ClonableType <- nameServerConstructor.create[0]
		
		unavailable
			(locate self)$stdout.putstring["TestSuit Prosess. Unavailable " || "\n"]
		end unavailable
	end process
end testSuite