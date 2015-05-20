export OrdinaryConstructor

const OrdinaryConstructor <- class oridnaryConstructor [myClonable : ClonableType, id : Integer, N : Integer, PrimeConstructor : ConstructorType, OrdinConstructor : ConstructorType]
			attached var replicas : Array.of[replicaType]
			attached var availableNodes : Array.of[node]
			
			var myEventHandler : EventHandlerType <- nil
			var lock : boolean <- false
			var init : boolean <- false
			var kill : boolean <- false
			var pending : Any <- nil
			
			export operation getId -> [repId : Integer]
				repId <- id
			end getId

			export operation setId[newId : Integer]
				id <- newId
			end setId

			export operation getN -> [requiredReplicas : Integer]
				requiredReplicas <- N
			end getN

			export operation getAvailableNodes -> [res : Array.of[node]]
				res <- availableNodes
			end getAvailableNodes

			export operation getReplicas -> [res : Array.of[replicaType]]
				res <- replicas
			end getReplicas

			export operation addAvailableNode[newAvailableNode : Node]
				availableNodes.addUpper[newAvailableNode]
				(locate self)$stdout.putstring["Ordinary addAvailableNode. AvailableNodes.upper: "
					||availableNodes.upperbound.asString || "\n"]
				
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end addAvailableNode

			export operation killProcess
				(locate self).removeNodeEventHandler[myEventHandler]
				(locate self)$stdout.putstring["Ordinary killProcess." || "\n"]
				kill <- true
			end killProcess

			export operation cloneMe -> [clone : ClonableType]
				%% Dummy operation
			end cloneMe

			export operation update
				(locate self)$stdout.putstring["Ordinary update. \n"]
				var newData : Any <- replicas[0].getData
				(locate self)$stdout.putstring["Ordinary update. locate myClonable: "
					||(locate myClonable)$LNN.asString || "\n"]
				(locate self)$stdout.putstring["Ordinary update. locate self: "
					||(locate self)$LNN.asString || "\n"]
				myClonable.setData[newData]
				if pending !== nil then
					%replicas[0].setData[pending]
					pending <- nil
				end if

				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end update

			export operation update[primary : replicaType]
				(locate self)$stdout.putstring["Ordinary update[primary]. \n"]
				if myEventHandler == nil then 
					myEventHandler <- ordinaryEventHandler.create[self, id, N]
					(locate self)$stdout.putstring["Ordinary update. Setting eventListener" || "\n"]
					(locate self).setNodeEventHandler[myEventHandler]
				end if
				
				replicas <- primary.getReplicas
				availableNodes <- primary.getAvailableNodes
				self.initializeDataStructures[replicas, availableNodes]
				(locate self)$stdout.putstring["Ordinary update[primary]. Replicas: "
					|| replicas.upperbound.asString || ", availableNodes: "
					|| availableNodes.upperbound.asString ||"\n"]
				init <- true
				
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end update

			export operation setData[newData : Any]
				(locate self)$stdout.putstring["Ordinary setData[1]. Calling primary setData[2]." || "\n"]
				replicas[0].setData[newData, (locate self)$timeOfDay]
				%myClonable.setData[newData]

				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
					pending <- newData
				end unavailable
			end setData

			export operation setData[newData : Any, upn : Time]
				(locate self)$stdout.putstring["Ordinary setData[2]."]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end setData

			export operation getData -> [newData : Any]
				(locate self)$stdout.putstring["ordinary getData." || "\n"]
				unavailable
					(locate self)$stdout.putstring["ordinary getData. Unavailable" || "\n"]
				end unavailable
			end getData

			export operation getData[key : Any] -> [res : Any]
				res <- myClonable.getData[key]
			end getData
	
			export operation ping
				(locate self)$stdout.putstring["Ordinary ping."|| "\n"]
				unavailable
					(locate self)$stdout.putstring["Ordinary ping. Unavailable" || "\n"]
				end unavailable
			end ping

			export operation removeUnavailableReplica
				(locate self)$stdout.putstring["Ordinary removeUnavailableReplica." || "\n"]
				unavailable
					(locate self)$stdout.putstring["Ordinary removeUnavailableReplica. Unavailable" || "\n"]
				end unavailable
			end removeUnavailableReplica

			export operation maintainReplicas
				(locate self)$stdout.putstring["Ordinary maintainReplicas. Creating new Primary." || "\n"]
				replicas[0] <- PrimeConstructor.create[myClonable, 0, N, PrimeConstructor, OrdinConstructor]
				replicas[0].initializeDataStructures[replicas, availableNodes]
				if availableNodes.upperbound >= 0 then 
					(locate self)$stdout.putstring["Ordinary maintainReplicas. moving new Primary: "
			 || "\n"]
			 		var tmpNode : node <- availableNodes.removeUpper
					fix replicas[replicas.upperbound] at tmpNode
					fix myClonable.cloneMe at tmpNode
					(locate self)$stdout.putstring["Ordinary maintainReplicas. Moved Primary: "
			 		||tmpNode$LNN.asString|| "\n"]
				else
					var throw : replicaType <- replicas.removeUpper
					self.killProcess
					throw <- nil

					(locate self)$stdout.putstring["There is not enought active nodes to maintain "|| N.asString 
					|| " replicas. Please open more nodes." ||"\n"]	
				end if

				unavailable
					(locate self)$stdout.putstring["Ordinary maintainReplicas. Unavailable" || "\n"]
				end unavailable
			end maintainReplicas	

			export operation register
				lock <- true
				if lock then 

				end if
			end register

			export operation initializeDataStructures[reps : Array.of[replicaType], availableN : Array.of[node]]
				self.initReplicas[reps]
				self.initAvailableNodes[availableN]
				(locate self)$stdout.putstring["Ordinary initializeDataStructures." || "\n"]
			end initializeDataStructures

			operation initReplicas[reps : Array.of[replicaType]]
				replicas <- Array.of[replicaType].create[(reps.upperbound + 1)]
				for i : Integer <- 0 while i <= reps.upperbound by i <- i + 1
					replicas[i] <- reps[i]
				end for
			end	initReplicas

			operation initAvailableNodes[availableN : Array.of[node]]
				availableNodes <- Array.of[node].create[(availableN.upperbound + 1)]
				for i : Integer <- 0 while i <= availableN.upperbound by i <- i + 1
					availableNodes[i] <- availableN[i]
				end for
			end	initAvailableNodes	

			export operation print[msg : String]

			end print

			export operation getInitData[newKeys : Array.of[String], newObjects : Array.of[FilmDataType]]

			end getInitData

			process
				loop
					exit when init == true 
					begin
						init <- false
						(locate self)$stdout.putstring["Ordinary process init " ||(locate self)$LNN.asString
						|| "\n"]
						(locate self).delay[Time.create[1, 0]]
					end
				end loop
				
				loop
					exit when kill == true 
					begin
						kill <- false 
						%(locate self)$stdout.putstring["\nOrdinary processloop. LNN: "||(locate self)$LNN.asString||"\n"]
						%(locate self)$stdout.putstring["\n\t AvailableNodes.upperbound: " || availableNodes.upperbound.asString ||" AvailableNodes.upperbound: " 
							%|| availableNodes.upperbound.asString|| ". Replicas.upperbound: "
							%|| replicas.upperbound.asString ||"\n"]
						(locate self).delay[Time.create[2, 0]]
						%self.ping
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Ordinary process. Unavailable" || "\n"]
				end unavailable
				failure
					(locate self)$stdout.putstring["Ordinary process. Failure." ||"\n"]
				end failure
			end process

			initially
				(locate self).delay[Time.create[2, 0]]
				
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"|| "\n"]
				end unavailable
			end initially
end oridnaryConstructor
