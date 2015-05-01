export framework


const framework <- object framework
	const home <- (locate self)
	var activeNodes : NodeList <- home$activeNodes
	var replicas : Array.of[replicaType] 
	var nodeElements : Array.of[nodeElementType] <- Array.of[nodeElementType].create[(home.getActiveNodes.upperbound + 1)]
	
	%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%
	const nodeElement <- class nodeElement [nodeElem : node]
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
			n <- nodeElem
			unavailable
				(locate self)$stdout.putstring["NodeElem: getNode. Unavailable " || "\n"]
			end unavailable
		end getNode
	end nodeElement

	const nodeDownHandler <- object nodeDownHandler
		export operation nodeUp[n : node, t : Time]
			(locate self)$stdout.putstring["Node up handler:" ||"\n"]
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
		end nodeDown
	end nodeDownHandler
	%%%%%%%%%%%%%%%%% end inner class %%%%%%%

	export operation replicateMe[X : replicaType, N : Integer]
		replicas <- Array.of[replicaType].create[N]
		if home.getActiveNodes.upperbound > (N - 1) then 
			X.setToPrimary
			replicas[0] <- X
			for i : Integer <- 1 while i < N by i <- i + 1
				replicas[i] <- X.cloneMe[]
				nodeElements[i].setReplica[replicas[i]]
				move replicas[i] to nodeElements[i].getNode
				replicas[i].print["My new home"]
			end for
			nodeElements[0].setReplica[X]
			(locate self)$stdout.putstring["Debug: replacateMe. " || "\n"]
			fix X at nodeElements[0].getNode
			X.print["My new home."]
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
		(locate self)$stdout.putstring["Thread: Get primary \n"]
		replicas[0].ping
		primary <- replicas[0]
		
		unavailable
			(locate self)$stdout.putstring["Debug: getPrimary. Unavailable." || "\n"]
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
			else
				(locate self)$stdout.putstring["Debug: Replica Node is down. Cloning new " || "\n"] 
			end if
			replicas[i] <- replicas[0].cloneMe
			var emptyNode : Node <- self.findAvailableNode
			move replicas[i] to emptyNode
			(locate self)$stdout.putstring["After moving new clone" || "\n"] 
		end unavailable
	end maintainReplicas

	operation findAvailableNode -> [availableNode : Node]
		availableNode <- nil
		for i : Integer <- 0 while i <= nodeElements.upperbound by i <- i + 1
			if nodeElements[i].getReplica == nil then 
				availableNode <- nodeElements[i].getNode
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
			end if
		end for

		unavailable
			tmpNodeElem.setReplica[nil]
			(locate self)$stdout.putstring["Framework: cleaning. Unavailable:"  ||"\n"]
		end unavailable

		failure
			home$stdout.putstring["Framework: cleaning: failure"  ||"\n"]
		end failure
	end cleanUpNodeElements

	operation instansiateNodeElements
		for i : Integer <- 1 while i <= home$activeNodes.upperbound by i <- i + 1
			var n : node <- home$activeNodes[i]$theNode
			nodeElements[i - 1] <- nodeElement.create[n]
			%home$stdout.putstring["instansiateNodeElements:  "  || nodeElements[i - 1].getNode$LNN.asString||"\n"]
		end for
		unavailable
			(locate self)$stdout.putstring["Framework: instansiateNodeElements. Unavailable " || "\n"]
		end unavailable
	end instansiateNodeElements

	

	initially
		self.instansiateNodeElements
		home.setNodeEventHandler[nodeDownHandler]
		unavailable
			(locate self)$stdout.putstring["Framework: initially. Unavailable " || "\n"]
		end unavailable
	end initially
end framework

%%%%%%%
%% Disqus: Why I did not choose to implement the state pattern for Primary and other replica states
%% Only two states, but most important, then it cant be cloned.

%%QUESTIONS:
%% replicas.addUpper fails. Why?
