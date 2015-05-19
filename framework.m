export framework


const framework <- object framework
	const home <- (locate self)
	var replicas : Array.of[replicaType] 
	var availableNodes : Array.of[Node] <- Array.of[Node].create[0]
	
	export operation replicateMe[X : ClonableType, N : Integer] -> [proxy : Array.of[ClonableType]]
		replicas <- Array.of[replicaType].create[(N -1)]
		%proxy <- Array.of[ClonableType].create[replicas.upperbound]
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
				replicas[i] <- OrdinaryConstructor.create[X, i, N, PrimaryConstructor, OrdinaryConstructor]
				fix replicas[i] at home$activeNodes[i]$theNode
				fix X.cloneMe at home$activeNodes[i]$theNode
			else
				(locate self)$stdout.putstring["ReplicateMe. Adding availableNodes." ||"\n"]
				availableNodes.addUpper[home$activeNodes[i]$theNode]
			end if
		end for
		replicas[0] <- PrimaryConstructor.create[X, 0, N, PrimaryConstructor, OrdinaryConstructor]
		fix replicas[0] at home$activeNodes[1]$theNode
		fix X at home$activeNodes[1]$theNode
		replicas[0].initializeDataStructures[replicas, availableNodes]
		proxy <- self.createProxies
		
		unavailable
			(locate self)$stdout.putstring["Framework: replacateMe. Unavailable " || "\n"]
		end unavailable

		%failure
			%(locate self)$stdout.putstring["ReplicateMe. Failure. ." ||"\n"]
		%end failure

	end replicateMe

	operation createProxies -> [res : Array.of[ClonableType]]
		var tmp : Array.of[clonableType] <- Array.of[ClonableType].create[0]
		for i : Integer <- 0 while i <= replicas.upperbound by i <- i + 1
			tmp.addUpper[(view replicas[i] as ClonableType)]
		end for
		res <- tmp
	end createProxies

	export operation getAvailableNodes -> [res : Array.of[Node]]
		res <- availableNodes
	end getAvailableNodes

	export operation getReplicas -> [res : Array.of[replicaType]]
		res <- replicas
	end getReplicas

	export operation refreshProxyList -> [res : Array.of[ClonableType]]
		replicas <- replicas[0].getReplicas
		res <- self.createProxies
	end refreshProxyList

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
%% Why doesnt replicas conform to clonableType. They have the same operations as clonableType
%% 
