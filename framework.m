export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var proxys : Array.of[replicaType] 
	var nodeElements : Array.of[nodeElementType] <- Array.of[nodeElementType].create[0]
	
	export operation testMethod
		(locate self)$stdout.putstring["Debug: TestMethod " || "\n"]
	end testMethod

	export operation replicateMe[X : ClonableType, N : Integer] -> [proxy : replicaType]
		if home.getActiveNodes.upperbound >= 2 then 
			for i : Integer <- 1 while i < home.getActiveNodes.upperbound by i <- i + 1
				
			end for
		else
			home$stdout.putstring["There has to be at least 3 active nodes available at this time. " || "\n"]
		end if	

		unavailable
			(locate self)$stdout.putstring["Debug: replacateMe. Unavailable " || "\n"]
		end unavailable
	end replicateMe

	process
		var i : Integer <- 0
		loop
			exit when i >= 240 
			begin
				home.delay[Time.create[2, 0]]
			end
		end loop
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
