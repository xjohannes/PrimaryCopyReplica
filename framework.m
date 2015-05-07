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
<<<<<<< HEAD
			%(locate self)$stdout.putstring["Debug: setReplica. " || "\n"]
=======
			(locate self)$stdout.putstring["Debug: setReplica. " || "\n"]
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
			unavailable
				(locate self)$stdout.putstring["NodeElem: setReplica. Unavailable " || "\n"]
			end unavailable
		end setReplica

		export operation getNode -> [n : Node]
			%(locate self)$stdout.putstring["NodeElem: getNode 1 . " || "\n"]
			n <- nodeElem
<<<<<<< HEAD
			%(locate self)$stdout.putstring["NodeElem: getNode 2. " || "\n"]
=======
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
			unavailable
				(locate self)$stdout.putstring["NodeElem: getNode. Unavailable " || "\n"]
			end unavailable
		end getNode
	end nodeElement

	const nodeDownHandler <- object nodeDownHandler
		export operation nodeUp[n : node, t : Time]
			(locate self)$stdout.putstring["Node up handler:" ||"\n"]
<<<<<<< HEAD
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
=======
			framework.nodeDown[n]
			unavailable
			(locate self)$stdout.putstring["nodeHandler: nodeUp . Unavailable " || "\n"]
		end unavailable
		end nodeUp

		export operation nodeDown[n : node, t : Time]
			(locate self)$stdout.putstring["Node up handler:"  ||"\n"]
			unavailable
			(locate self)$stdout.putstring["NodeHandler: nodeDown. Unavailable " || "\n"]
		end unavailable
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
		end nodeDown
	end nodeDownHandler
	%%%%%%%%%%%%%%%%% end inner class %%%%%%%
	
	export operation testMethod
		(locate self)$stdout.putstring["Debug: TestMethod " || "\n"]
	end testMethod

	export operation replicateMe[X : ClonableType, N : Integer]
		replicas <- Array.of[replicaType].create[0]
		var monitorObject : MonitorType
		var tmp : replicaType
		var objTmp : ClonableType
		var nodeTmp : Node
		if home.getActiveNodes.upperbound > (N - 1) then 
			for i : Integer <- 0 while i < N by i <- i + 1
				(locate self)$stdout.putstring["Debug: replicateMe i: "|| i.asString || "\n"]
				objTmp <- X.cloneMe
				monitorObject <- MonitorConstructor.create[objTmp]
				tmp <- replicaConstructor.create[i, self, objTmp, monitorObject]
				replicas.addUpper[tmp]
				nodeElements[i].setReplica[replicas[i]]
				if i == 0 then 
					replicas[0].setToPrimary["First replica"]
				end if
				nodeTmp <- nodeElements[i].getNode
				fix replicas[i] at nodeTmp
				fix objTmp at nodeTmp
				fix monitorObject at nodeTmp
				replicas[i].print["My new home " || nodeTmp$LNN.asString]
			end for
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
<<<<<<< HEAD
=======
		(locate self)$stdout.putstring["Thread: Get primary \n"]
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
		replicas[0].ping
		primary <- replicas[0]
		
		unavailable
			(locate self)$stdout.putstring["Debug: getPrimary. Unavailable." || "\n"]
<<<<<<< HEAD
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
=======
			self.nodeDown
			var throwAway : replicaType <- self.getPrimary
		end unavailable
	end getPrimary

	operation nodeDown
		var i : Integer <- 0
		loop
				exit when i >= nodeElements.upperbound
				begin
					nodeElements[i].getReplica.ping
				end
				i <- i + 1
		end loop

		unavailable
			(locate self)$stdout.putstring["Framework: NodeDown: Unavailable"  ||"\n"]
			nodeElements[i] <- nodeElements[nodeElements.upperbound]
			var throwAway : nodeElementType <- nodeElements.removeUpper
			
			self.maintainReplicas
		end unavailable
	end nodeDown

	export operation nodeDown[n : node]
		var i : Integer <- 0
		loop
				exit when i >= nodeElements.upperbound
				begin
					if n == nodeElements[i] then 
						nodeElements[i] <- nodeElements[nodeElements.upperbound]
						var throwAway : nodeElementType <- nodeElements.removeUpper
			
			self.maintainReplicas
					end if
				end
				i <- i + 1
		end loop
	end nodeDown

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
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
			else
			 	home$stdout.putstring["Debug: There is not enough nodes to maintain the required " 
			 		|| "nr of replicas. Please enable a new node." || "\n"]
			end if
<<<<<<< HEAD

			unavailable
				(locate self)$stdout.putstring["Debug: Node down. Unavailable" || "\n"] 
			end unavailable
	end nodeDown
=======
			replicas[i] <- replicas[0].cloneMe
			var emptyNode : Node <- self.findAvailableNode
			move replicas[i] to emptyNode
			(locate self)$stdout.putstring["After moving new clone" || "\n"] 
		end unavailable
	end maintainReplicas
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179

	operation findAvailableNode -> [availableNode : Node]
		availableNode <- nil
		(locate self)$stdout.putstring["findAvailableNodes: " || nodeElements.upperbound.asstring || "\n"]
		for i : Integer <- 0 while i <= nodeElements.upperbound by i <- i + 1
			if nodeElements[i].getReplica == nil then 
				availableNode <- nodeElements[i].getNode
<<<<<<< HEAD
				(locate self)$stdout.putstring["findAvailableNode: found nodeElement with no replica" || "\n"]
				return	
			else
				(locate self)$stdout.putstring["findAvailableNode: No nodes without a replica. i: " ||i.asString || "\n"]
=======
				return
			end if
		end for
		unavailable
			(locate self)$stdout.putstring["\nFramework. FindAvailable nodes. Unavailable"|| "\n" ]
		end unavailable
	end findAvailableNode

	operation cleanUpNodeElements
		(locate self)$stdout.putstring["Framework: cleaning 1:"  ||"\n"]
		var tmpNodeElem : nodeElementType 
		for i : Integer <- 0 while i <= nodeElements.upperbound by i <- i + 1
			(locate self)$stdout.putstring["Framework: cleaning 2:"  ||"\n"]
			var n : replicaType <- nodeElements[i].getReplica
			if n !== nil then
				tmpNodeElem <- nodeElements[i]
				n.ping	
				(locate self)$stdout.putstring["Framework: cleaning 3:"  || i.asString||"\n"]
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
			end if
		end for

		unavailable
<<<<<<< HEAD
			(locate self)$stdout.putstring["\nFramework. FindAvailable nodes. Unavailable"|| "\n" ]
=======
			tmpNodeElem.setReplica[nil]
			(locate self)$stdout.putstring["Framework: cleaning. Unavailable:"  ||"\n"]
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
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
<<<<<<< HEAD
		(locate self)$stdout.putstring["nodeElements upperbound: " || nodeElements.upperbound.asString|| "\n"]
=======
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
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
<<<<<<< HEAD
		home.setNodeEventHandler[nodeDownHandler] % Makes the instansiateNodeElements run twice
		
=======
		home.setNodeEventHandler[nodeDownHandler]
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
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
