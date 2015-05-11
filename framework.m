export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var proxies : Array.of[replicaType] <- Array.of[replicaType].create[0]
	var availableNodes : Array.of[Node] <- Array.of[Node].create[0]
	%var RF : ReplicaFactoryType <- ReplicaFactory
	
	export operation replicateMe[X : ClonableType, N : Integer] -> [proxy : Array.of[replicaType]]
		if home.getActiveNodes.upperbound >= 2 then 
			proxies.addUpper[ReplicaFactory.createPrimary[availableNodes]]
			fix proxies[0] at home$activeNodes[1]$theNode
			proxies[0].ping
			for i : Integer <- 1 while i < home.getActiveNodes.upperbound by i <- i + 1
				if i <= N then 
					proxies.addUpper[ReplicaFactory.createOrdinary[availableNodes]]
					fix proxies[i] at home$activeNodes[(i + 1)]$theNode
					proxies[i].ping
				else
					availableNodes.addUpper[home$activeNodes[(i + 1)]$theNode]
				end if
			end for
			if N > (proxies.upperbound + 1) then 
				home$stdout.putstring["There is not enough active nodes available to create N replicas. "
				|| "Could only create  " || (proxies.upperbound + 1).asString || "replicas. "|| "\n"]
			end if
		else
			home$stdout.putstring["There has to be at least 3 active nodes available at this time. " || "\n"]
		end if	

		unavailable
			(locate self)$stdout.putstring["Debug: replacateMe. Unavailable " || "\n"]
		end unavailable
	end replicateMe

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
