export Ordinary

const Ordinary <- class ordinary (abstractReplica) 
			
	export operation cloneMe -> [clone : replicaType]
				
		unavailable
			(locate self)$stdout.putstring["Replica: cloneMe. Unavailable " || "\n"]
		end unavailable
	end cloneMe	

	process

	end process

	initially

	end initially
end ordinary