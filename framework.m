export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var replicas : Array.of[replicaType] 
	var availableNodes : Array.of[Node] <- Array.of[Node].create[0]
	var replicasUpperbound : Integer <- 1
	
	export operation replicateMe[X : ClonableType, N : Integer] -> [proxy : Array.of[replicaType]]
		replicas <- Array.of[replicaType].create[(N -1)]
		(locate self)$stdout.putstring["ReplicateMe. replicas upper: "|| replicas.upperbound.asString ||"\n"]
		loop
			exit when home.getActiveNodes.upperbound > 0 
			begin
				home$stdout.putstring["There has to be at least 2 active nodes available to start the Primary Copy Replica Framework. " 
					||"Please open more nodes."|| "\n"]
				(locate self).delay[Time.create[2, 0]]
			end
		end loop

		for i : Integer <- 1 while i < home.getActiveNodes.upperbound by i <- i + 1
			if i < N then 
				replicas[i] <- OrdinaryConstructor.create[i, N, PrimaryConstructor, OrdinaryConstructor]
				%replicas.addUpper[OrdinaryConstructor.create[replicasUpperbound, N, PrimaryConstructor, OrdinaryConstructor]]
				fix replicas[i] at home$activeNodes[i]$theNode
				%replicasUpperbound <- replicasUpperbound + 1
			else
				(locate self)$stdout.putstring["ReplicateMe. Adding availableNodes." ||"\n"]
				availableNodes.addUpper[home$activeNodes[i]$theNode]
			end if
		end for
		%replicas.addUpper[replicas[0]]
		replicas[0] <- PrimaryConstructor.create[0, N, PrimaryConstructor, OrdinaryConstructor]
		fix replicas[0] at home$activeNodes[1]$theNode
		replicas[0].initializeDataStructures[replicas, availableNodes]

		unavailable
			(locate self)$stdout.putstring["Framework: replacateMe. Unavailable " || "\n"]
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
			(locate self)$stdout.putstring["Framework Failure: Process." ||"\n"]
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
