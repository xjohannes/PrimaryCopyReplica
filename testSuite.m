export testSuite

const testSuite <- object testSuite
	const home <- (locate self)
	process
		%(locate self).delay[Time.create[3 , 0]]
		var testRep : ClonableType <- nameServerConstructor.create[0]
		framework.replicateMe[testRep, 2]
		(locate self).delay[Time.create[1,0]]
		framework.insert["The Beatles"]
		(locate self).delay[Time.create[1,0]]
		framework.insert["John Lennon"]
		(locate self).delay[Time.create[1,0]]
		framework.insert["Paul McCartney"]
		(locate self).delay[Time.create[1,0]]
		framework.insert["George Harrison"]
		(locate self).delay[Time.create[1,0]]
		framework.insert["Ringo Starr"]
<<<<<<< HEAD
		
		unavailable
			(locate self)$stdout.putstring["TestSuit Prosess. Unavailable " || "\n"]
=======
		unavailable
			(locate self)$stdout.putstring["nameServer: testSuit Prosess. Unavailable " || "\n"]
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
		end unavailable
	end process
end testSuite