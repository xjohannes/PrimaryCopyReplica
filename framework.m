export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var replicas : Array.of[replicaType] <- Array.of[replicaType].create[0]
	var availableNodes : Array.of[Node] <- Array.of[Node].create[0]
	var replicasUpperbound : Integer <- 0
	
	export operation replicateMe[X : ClonableType, N : Integer] -> [proxy : Array.of[replicaType]]
		if home.getActiveNodes.upperbound >= 2 then 
			home$stdout.putstring["Debug 1. " || "\n"]
			replicas.addUpper[PrimaryConstructor.create[0, N, OridnaryConstructor]]
			home$stdout.putstring["Debug 2. " || "\n"]
			fix replicas[replicasUpperbound] at home$activeNodes[1]$theNode
			home$stdout.putstring["Debug 3. " || "\n"]
			replicasUpperbound <- replicasUpperbound + 1
			home$stdout.putstring["Debug 4. " || "\n"]
			for i : Integer <- home.getActiveNodes.upperbound while i > 1  by i <- i - 1
				home$stdout.putstring["Debug 5. " || "\n"]
				if i > N then 
					availableNodes.addUpper[home$activeNodes[i]$theNode]
					home$stdout.putstring["Debug 6. " || "\n"]
				else
					replicas.addUpper[OridnaryConstructor.create[replicasUpperbound, N, PrimaryConstructor]]
					home$stdout.putstring["Debug 7. " || "\n"]
					fix replicas[replicasUpperbound] at home$activeNodes[i]$theNode
					home$stdout.putstring["Debug 8. " || "\n"]
					replicasUpperbound <- replicasUpperbound + 1
				end if
			end for
			home$stdout.putstring["Debug 9. " || "\n"]
			replicas[0].setModifiedArrays[replicas, availableNodes]
			home$stdout.putstring["Debug 10. " || "\n"]

			if N > (replicasUpperbound) then 
				home$stdout.putstring["Framework: There is not enough active nodes available to create N replicas. "
				|| "Could only create  " || replicasUpperbound.asString || "replicas. "|| "\n"]
			end if

		else
			home$stdout.putstring["There has to be at least 3 active nodes available at this time. " || "\n"]
		end if	

		unavailable
			(locate self)$stdout.putstring["Debug: replacateMe. Unavailable " || "\n"]
		end unavailable
	end replicateMe

	export operation getAvailableNodes -> [res : Array.of[Node]]
		res <- availableNodes
	end getAvailableNodes

	export operation getReplicas -> [res : Array.of[replicaType]]
		res <- replicas
	end getReplicas

	process
		
		unavailable
			(locate self)$stdout.putstring["Framework: Process Unavailable " || "\n"]
		end unavailable
		failure
			(locate self)$stdout.putstring["Framework Failure: 4. Process." ||"\n"]
		end failure
	end process

	initially
		
		unavailable
			(locate self)$stdout.putstring["Framework: initially. Unavailable " || "\n"]
		end unavailable
	end initially

end framework

%%%%%%%
%% Disqus: Why I did not choose to implement the state pattern for Primary and other replica states
%% Only two states, but most important, then it cant be cloned.
%% Write about move vs fix

%%QUESTIONS:
%% instansiateNodeElements is run twice when setNodeEventHandler
%%    
%% 
