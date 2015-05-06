export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var replicas : Array.of[replicaType] 
	var nodeElements : Array.of[nodeElementType] <- Array.of[nodeElementType].create[0]
	
	%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%
	const nodeElementConstructor <- monitor class nodeElement [nodeElem : node]
		var replica : replicaType <- nil
		var NNL : Integer

		export operation getReplica -> [rep : replicaType]
			rep <- replica
			unavailable
				(locate self)$stdout.putstring["NodeElem: getReplica. Unavailable " || "\n"]
			end unavailable
		end getReplica


		export operation setReplica [rep : replicaType]
			replica <- rep
			%(locate self)$stdout.putstring["Debug: setReplica. " || "\n"]
			unavailable
				(locate self)$stdout.putstring["NodeElem: setReplica. Unavailable " || "\n"]
			end unavailable
		end setReplica

		export operation getNode -> [n : Node]
			%(locate self)$stdout.putstring["NodeElem: getNode 1 . " || "\n"]
			n <- nodeElem
			%(locate self)$stdout.putstring["NodeElem: getNode 2. " || "\n"]
			unavailable
				(locate self)$stdout.putstring["NodeElem: getNode. Unavailable " || "\n"]
			end unavailable
		end getNode
	end nodeElement

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

	export operation replicateMe[X : replicaType, N : Integer]
		replicas <- Array.of[replicaType].create[0]
		
		if home.getActiveNodes.upperbound > (N - 1) then 
			X.setToPrimary["First replica"]
			replicas.addUpper[X]
			for i : Integer <- 1 while i < N by i <- i + 1
			(locate self)$stdout.putstring["Debug: replicateMe i: "|| i.asString || "\n"]
				replicas.addUpper[X.cloneMe[]]
				nodeElements[i].setReplica[replicas[i]]
				fix replicas[i] at nodeElements[i].getNode
				replicas[i].print["My new home " || nodeElements[i].getNode$LNN.asString]
			end for
			nodeElements[0].setReplica[X]
			fix X at nodeElements[0].getNode
			X.print["My new home. My LNN is: " || nodeElements[0].getNode$LNN.asString]
		else
			home$stdout.putstring["There has to be more available nodes than replicas: Nodes > relicas." || "\n"]
		end if

		unavailable
			(locate self)$stdout.putstring["Debug: replacateMe. Unavailable " || "\n"]
		end unavailable
	end replicateMe

	export operation insert[data : Any]
		if replicas.upperbound >= 0 then 
			%replicas[0].setData[data]
		end if

		unavailable
			(locate self)$stdout.putstring["\nFramework. Insert. Unavailable"|| "\n" ]
		end unavailable
	end insert

	export operation notify
		for i:Integer <- 1 while i <= replicas.upperbound by i <- i + 1
			if replicas[i] !== nil then 
				%(locate self)$stdout.putstring["Debug: notify. " || "\n"]
				replicas[i].update[replicas[0]]
			else
				%(locate self)$stdout.putstring["There are no available replicas to notify." || "\n"]	
			end if	
		end for

		unavailable
			(locate self)$stdout.putstring["Unable to notify replica. Unavailable. Creating new: " || "\n"]
		end unavailable
	end notify

	export operation getPrimary -> [primary : replicaType]
		replicas[0].ping
		primary <- replicas[0]
		
		unavailable
			(locate self)$stdout.putstring["Debug: getPrimary. Unavailable." || "\n"]
			self.nodeDown[0, 0]
			%var throwAway : replicaType <- self.getPrimary
		end unavailable
	end getPrimary

	% Invariant: Replicas and nodeElements is never nil

	operation nodeDown[nodeDownNr : Integer, extra : Integer]
			var emptyNode : Node <- self.findAvailableNode
			if emptyNode !== nil then
				replicas[nodeDownNr] <- replicas[((nodeDownNr + 1) # (replicas.upperbound + 1))].cloneMe
				nodeElements[nodeDownNr] <- nodeElements.removeUpper
				nodeElements[nodeDownNr].setReplica[replicas[nodeDownNr]]
				fix replicas[nodeDownNr] at nodeElements[nodeElements.upperbound]
				replicas[nodeDownNr].print["My new home " || nodeElements[nodeDownNr].getNode$LNN.asString]
				if nodeDownNr == 0 then
					(locate self)$stdout.putstring["Debug: Primary Node is down. Cloning new " || "\n"]
					replicas[0].setToPrimary["Primary down. "]
				else
					(locate self)$stdout.putstring["Debug: Replica Node is down. Cloning new " || "\n"] 
				end if
			else
			 	home$stdout.putstring["Debug: There is not enough nodes to maintain the required " 
			 		|| "nr of replicas. Please enable a new node." || "\n"]
			end if

			unavailable
				(locate self)$stdout.putstring["Debug: Node down. Unavailable" || "\n"] 
			end unavailable
	end nodeDown

	operation findAvailableNode -> [availableNode : Node]
		availableNode <- nil
		(locate self)$stdout.putstring["findAvailableNodes: " || nodeElements.upperbound.asstring || "\n"]
		for i : Integer <- 0 while i <= nodeElements.upperbound by i <- i + 1
			if nodeElements[i].getReplica == nil then 
				availableNode <- nodeElements[i].getNode
				(locate self)$stdout.putstring["findAvailableNode: found nodeElement with no replica" || "\n"]
				return	
			else
				(locate self)$stdout.putstring["findAvailableNode: No nodes without a replica. i: " ||i.asString || "\n"]
			end if
		end for

		unavailable
			(locate self)$stdout.putstring["\nFramework. FindAvailable nodes. Unavailable"|| "\n" ]
		end unavailable
	end findAvailableNode

	operation checkForDownNodes
		var i : Integer <- 0
		home$stdout.putstring["Framework. Checking for down nodes. " || "\n" ]
		loop
			exit when i > nodeElements.upperbound
				begin
					var n : Node <- nodeElements[i].getNode
					var nn : Integer <- n$LNN
					home$stdout.putstring[i.asString || " *** " ||nn.asString|| "\n" ]
				end
				i <- i + 1
		end loop
		
		unavailable
			home$stdout.putstring["Debug: checkForDownNodes. unavailable. Node " || i.asString|| " is down.\n"]
			self.nodeDown[i, 0]
		end unavailable
	end checkForDownNodes

	operation instansiateNodeElements
		home$stdout.putstring["Home: " || home$LNN.asString|| "\n"]
		(locate self)$stdout.putstring["nodeElements upperbound: " || nodeElements.upperbound.asString|| "\n"]
		(locate self)$stdout.putstring["Active nodes upperbound: " || home$activeNodes.upperbound.asString|| "\n"]
		for i : Integer <- 1 while i <= home$activeNodes.upperbound by i <- i + 1
			var n : node <- home$activeNodes[i]$theNode
			nodeElements.addUpper[nodeElementConstructor.create[n]]
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
				self.checkForDownNodes
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
