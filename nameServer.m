export nameServerConstructor

const nameServerConstructor <- class nameServerConstructor
			
	export operation cloneMe -> [clone : ClonableType]
		(locate self)$stdout.putstring["nameServer: CloneMe " || "\n"]
	end cloneMe

	export operation setData[newData : Any]
	end setData
	export operation print[msg : String]
	end print

	process
				
		unavailable
			(locate self)$stdout.putstring["nameServer: nameServer Prosess. Unavailable " || "\n"]
		end unavailable
	end process			

	initially
				
	end initially
end nameServerConstructor 