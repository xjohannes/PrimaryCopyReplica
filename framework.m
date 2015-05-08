export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var proxys : Array.of[replicaType] 
	var nodeElements : Array.of[nodeElementType] <- Array.of[nodeElementType].create[0]
	
	%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%
	const nodeDownHandler <- object nodeDownHandler
		export operation nodeUp[n : node, t : Time]
			(locate self)$stdout.putstring["Node up handler:" ||"\n"]
			unavailable
				(locate self)$stdout.putstring["nodeHandler: nodeUp . Unavailable " || "\n"]
			end unavailable
		end nodeUp

		export operation nodeDown[n : node, t : Time]
			(locate self)$stdout.putstring["Node down handler:"  ||"\n"]
			%framework.testMethod %% Makes the move of the replicateMe operation fail. Or makes the framework node go down.Why?
			unavailable
				(locate self)$stdout.putstring["NodeHandler: nodeDown. Unavailable " || "\n"]
			end unavailable
		end nodeDown
	end nodeDownHandler
	%%%%%%%%%%%%%%%%% end inner class %%%%%%%
	
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		proxys <- Array.of[replicaType].create[0]
		var monitorObject : MonitorType
		var tmp : replicaType
		var objTmp : ClonableType
		var nodeTmp : Node
		if home.getActiveNodes.upperbound > (N - 1) then 
			for i : Integer <- 0 while i < N by i <- i + 1
				(locate self)$stdout.putstring["Debug: replicateMe i: "|| i.asString || "\n"]
				objTmp <- X.cloneMe
				%monitorObject <- MonitorConstructor.create[objTmp]
				%tmp <- replicaConstructor.create[i, self, objTmp, monitorObject]
				proxys.addUpper[tmp]
				nodeElements[i].setReplica[proxys[i]]
				if i == 0 then 
					%proxys[0].setToPrimary["First replica"]
				end if
				nodeTmp <- nodeElements[i].getNode
				fix proxys[i] at nodeTmp
				%fix objTmp at nodeTmp
				%fix monitorObject at nodeTmp
				%proxys[i].print["My new home " || nodeTmp$LNN.asString]
			end for
		else
			home$stdout.putstring["There has to be more available nodes than proxys: Nodes > relicas." || "\n"]
		end if

		unavailable
			(locate self)$stdout.putstring["Debug: replacateMe. Unavailable " || "\n"]
		end unavailable
	end replicateMe

	operation instansiateNodeElements
		home$stdout.putstring["Home: " || home$LNN.asString|| "\n"]
		(locate self)$stdout.putstring["nodeElements upperbound: " || nodeElements.upperbound.asString|| "\n"]
		(locate self)$stdout.putstring["Active nodes upperbound: " || home$activeNodes.upperbound.asString|| "\n"]
		for i : Integer <- 1 while i <= home$activeNodes.upperbound by i <- i + 1
			var n : node <- home$activeNodes[i]$theNode
			%nodeElements.addUpper[nodeElementConstructor.create[n]]
			%(locate self)$stdout.putstring["instansiateNodeElements:  " || i.asString 
				%|| " *** " || nodeElements[i - 1].getNode$LNN.asString||"\n"]
		end for
		(locate self)$stdout.putstring["nodeElements upperbound: " || nodeElements.upperbound.asString|| "\n"]
		unavailable
			(locate self)$stdout.putstring["Framework: instansiateNodeElements. Unavailable " || "\n"]
		end unavailable
	end instansiateNodeElements

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
		self.instansiateNodeElements
		%home.setNodeEventHandler[nodeDownHandler] % Makes the instansiateNodeElements run twice
		
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
