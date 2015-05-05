export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var replicas : Array.of[replicaType] 
	var nodeElements : Array.of[nodeElementType] <- Array.of[nodeElementType].create[0]
	
	%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%
	const nodeElementConstructor <- class nodeElement [nodeElem : node]
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
			(locate self)$stdout.putstring["Debug: setReplica. " || "\n"]
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
		replicas <- Array.of[replicaType].create[N]
		
		if home.getActiveNodes.upperbound > (N - 1) then 
			X.setToPrimary
			replicas[0] <- X
			for i : Integer <- 1 while i < N by i <- i + 1
				replicas[i] <- X.cloneMe[]
				nodeElements[i].setReplica[replicas[i]]
				fix replicas[i] at nodeElements[i].getNode
				replicas[i].print["My new home"]
			end for
			nodeElements[0].setReplica[X]
			(locate self)$stdout.putstring["Debug: replacateMe. " || "\n"]
			fix X at nodeElements[0].getNode
			X.print["My new home. My LNN is: " || nodeElements[0].getNode$LNN.asString]
		else
			(locate self)$stdout.putstring["There has to be more available nodes than replicas: Nodes > relicas." || "\n"]
		end if

		unavailable
			(locate self)$stdout.putstring["Debug: replacateMe. Unavailable " || "\n"]
		end unavailable
	end replicateMe

	export operation insert[data : Any]
		if replicas.upperbound > 0 then 
			replicas[0].setData[data]
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
			%self.nodeDown[] NB!!! must be refactored
		end unavailable
	end notify

	export operation getPrimary -> [primary : replicaType]
		(locate self)$stdout.putstring["Debub: Get primary 1\n"]
		replicas[0].ping
		(locate self)$stdout.putstring["Debub: Get primary 2\n"]
		primary <- replicas[0]
		(locate self)$stdout.putstring["Debub: Get primary 3\n"]
		
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
				(locate self)$stdout.putstring["Debug: Node Down 0" || "\n"]
				replicas[nodeDownNr] <- replicas[((nodeDownNr + 1) # (replicas.upperbound + 1))].cloneMe
				(locate self)$stdout.putstring["Debug: Node Down 1" || "\n"]
				nodeElements[nodeDownNr] <- nodeElements.removeUpper
				(locate self)$stdout.putstring["Debug: Node Down 2" || "\n"]
				nodeElements[nodeDownNr].setReplica[replicas[nodeDownNr]]
				(locate self)$stdout.putstring["Debug: Node Down 3" || "\n"]
				fix replicas[nodeDownNr] at nodeElements[nodeElements.upperbound]
				(locate self)$stdout.putstring["Debug: Node Down 4" || "\n"]
				if nodeDownNr == 0 then
					(locate self)$stdout.putstring["Debug: Primary Node is down. Cloning new " || "\n"]
					replicas[0].setToPrimary
				else
					(locate self)$stdout.putstring["Debug: Replica Node is down. Cloning new " || "\n"] 
				end if
			else
			 	(locate self)$stdout.putstring["Debug: There is not enough nodes to maintain the required " 
			 		|| "nr of replicas. Please enable a new node." || "\n"]
			end if

			unavailable[c]
				%var n : node <- view c as node
				(locate self)$stdout.putstring["Debug: Node down. Unavailable" || "\n"] 
			end unavailable
	end nodeDown

	operation findAvailableNode -> [availableNode : Node]
		availableNode <- nil
		for i : Integer <- 0 while i <= nodeElements.upperbound by i <- i + 1
			if nodeElements[i].getReplica == nil then 
				availableNode <- nodeElements[i].getNode
				(locate self)$stdout.putstring["findAvailableNode found nodeElement with no replica" || "\n"]
				return	
			end if
		end for

		unavailable
			(locate self)$stdout.putstring["\nFramework. FindAvailable nodes. Unavailable"|| "\n" ]
		end unavailable
	end findAvailableNode

	operation checkForDownNodes
		var i : Integer <- 0
		(locate self)$stdout.putstring["\nFramework. Checking for down nodes. " || "\n" ]
		loop
			exit when i >= nodeElements.upperbound
				begin
					var n : Node <- nodeElements[i].getNode
					var nn : Integer <- n$LNN
					(locate self)$stdout.putstring[nn.asString|| "\n" ]
				end
				i <- i + 1
		end loop
		
		unavailable
			(locate self)$stdout.putstring["Debug: checkForDownNodes. unavailable. " || i.asString|| " is down.\n"]
			self.nodeDown[i, 0]
		end unavailable
	end checkForDownNodes

	operation maintainNodes
		var j : Integer <- 0
		for i : Integer <- 0 while i <= replicas.upperbound by i <- i + 1
			replicas[i].ping
			(locate self)$stdout.putstring["Debug: maintainNodes. Node " || i.asString|| " is up and running.\n"]
			j <- j + 1
		end for

		unavailable
			(locate self)$stdout.putstring["Debug: maintainNodes. Node " || j.asString|| " is down.\n"]
			self.nodeDown[j, 0]
		end unavailable
	end maintainNodes

	operation maintainReplicas
		%var newReplica : replicaType <- replicas[]
		var i : Integer <- 0
		loop
			exit when i >= replicas.upperbound
				begin
					replicas[i].ping
				end
				i <- i + 1
		end loop
		
		unavailable
			(locate self)$stdout.putstring["\nFramework. maintainReplicas. Unavailable. "|| "\n" ]
			if i == 0 then
				(locate self)$stdout.putstring["Debug: Primary Node is down. Cloning new " || "\n"]
				replicas[0] <- replicas[1]
				replicas[0].setToPrimary
				i <- 1
			else
				(locate self)$stdout.putstring["Debug: Replica Node is down. Cloning new " || "\n"] 
			end if
			replicas[i] <- replicas[0].cloneMe
			var emptyNode : Node <- self.findAvailableNode
			(locate self)$stdout.putstring["locate self NLL" ||(locate self)$LNN.asString|| "\n"] 
			(locate self)$stdout.putstring["empty node NLL" ||emptyNode$LNN.asString|| "\n"] 
			if emptyNode !== nil then 
				fix replicas[i] at emptyNode
				(locate self)$stdout.putstring["After moving new clone" || "\n"] 
			end if
			
		end unavailable
	end maintainReplicas

	operation instansiateNodeElements
		for i : Integer <- 1 while i <= home$activeNodes.upperbound by i <- i + 1
			var n : node <- home$activeNodes[i]$theNode
			nodeElements.addUpper[nodeElementConstructor.create[n]]
			%home$stdout.putstring["instansiateNodeElements:  "  || nodeElements[i - 1].getNode$LNN.asString||"\n"]
		end for
		unavailable
			(locate self)$stdout.putstring["Framework: instansiateNodeElements. Unavailable " || "\n"]
		end unavailable
	end instansiateNodeElements

	process
		var i : boolean <- true
		loop
			exit when i == false 
			begin
				home.delay[Time.create[1, 0]]
				self.checkForDownNodes
			end
		end loop
	end process

	initially
		self.instansiateNodeElements
		home.setNodeEventHandler[nodeDownHandler]
		unavailable
			(locate self)$stdout.putstring["Framework: initially. Unavailable " || "\n"]
		end unavailable
	end initially

	operation nodeDown
		(locate self)$stdout.putstring["Debug: NodeDown: "  || nodeElements.upperbound.asString||"\n"]
		var i : Integer <- 0
		loop
			exit when i >= nodeElements.upperbound
			begin
				if nodeElements[i] == nil then 
					(locate self)$stdout.putstring["Framework: NodeDown: nodeElements == nil"  ||"\n"]
					if nodeElements[nodeElements.upperbound] !== nil then
						nodeElements[i] <- nodeElements[nodeElements.upperbound]
						self.maintainReplicas
					else
						(locate self)$stdout.putstring["Framework: NodeDown: last nodeElement is also nil"  ||"\n"]						end if
						var throwAway : nodeElementType <- nodeElements.removeUpper
					else 
						(locate self)$stdout.putstring["Framework: NodeDown: nodeElements !== nil" || i.asString  ||"\n"]
					end if
				end
				i <- i + 1
		end loop

		unavailable
			(locate self)$stdout.putstring["Framework: NodeDown: Unavailable " || i.asString ||"\n"]
			%nodeElements[i] <- nodeElements[nodeElements.upperbound]
			%var throwAway : nodeElementType <- nodeElements.removeUpper
			self.maintainReplicas
		end unavailable

		failure
			(locate self)$stdout.putstring["Node Down: failure "  ||" \n"]
		end failure
	end nodeDown

	export operation nodeDown[n : node]
		var i : Integer <- 0
		loop
				exit when i >= nodeElements.upperbound
				begin
					if n == nodeElements[i] then 
						nodeElements[i] <- nodeElements[nodeElements.upperbound]
						nodeElements[i].setReplica[nil]
						var throwAway : nodeElementType <- nodeElements.removeUpper
						replicas[i] <- replicas[replicas.upperbound]
						var throwAway2 : replicaType <- replicas.removeUpper
					end if
				end
				i <- i + 1
		end loop

		unavailable
			(locate self)$stdout.putstring["\n Node down[n:node]. Unavailable. "|| "\n" ]
		end unavailable
	end nodeDown

	
end framework

%%%%%%%
%% Disqus: Why I did not choose to implement the state pattern for Primary and other replica states
%% Only two states, but most important, then it cant be cloned.
%% Write about move vs fix

%%QUESTIONS:
%% replicas.addUpper fails. Why?
%% Move maintainReplicas unavailable section to new method?       
%% 
