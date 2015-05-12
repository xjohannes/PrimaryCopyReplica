export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var replicas : Array.of[replicaType] <- Array.of[replicaType].create[0]
	var availableNodes : Array.of[Node] <- Array.of[Node].create[0]
	%var RF : ReplicaFactoryType <- ReplicaFactory
	
	export operation replicateMe[X : ClonableType, N : Integer] -> [proxy : Array.of[replicaType]]
		if home.getActiveNodes.upperbound >= 2 then 
			var proxyIndex : Integer <- 0
			for i : Integer <- home.getActiveNodes.upperbound while i > 1  by i <- i - 1
				if i > N then 
					availableNodes.addUpper[home$activeNodes[i]$theNode]
				else
					replicas.addUpper[OridnaryConstructor.create[availableNodes, replicas, N]]
					fix replicas[proxyIndex] at home$activeNodes[i]$theNode
					proxyIndex <- proxyIndex + 1
				end if
			end for
			replicas.addUpper[PrimaryConstructor.create[availableNodes, replicas, N]]
			fix replicas[proxyIndex] at home$activeNodes[1]$theNode

			if N > (replicas.upperbound + 1) then 
				(locate self)$stdout.putstring["Debug: replicateMe " || "\n"]	
				home$stdout.putstring["There is not enough active nodes available to create N replicas. "
				|| "Could only create  " || (replicas.upperbound + 1).asString || "replicas. "|| "\n"]
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
