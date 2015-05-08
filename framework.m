export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var proxies : Array.of[replicaType] <- Array.of[replicaType].create[0]
	var nodeElements : Array.of[nodeElementType] <- Array.of[nodeElementType].create[0]
	var RF : ReplicaFactoryType <- ReplicaFactory
	
	export operation replicateMe[X : ClonableType, N : Integer] -> [proxy : Array.of[replicaType]]
		if home.getActiveNodes.upperbound >= 2 then 
			proxies.addUpper[RF.createPrimary]
			for i : Integer <- 1 while i <= home.getActiveNodes.upperbound by i <- i + 1
				proxies.addUpper[RF.createOrdinary]
			end for
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
