
export PrimaryConstructor

const PrimaryConstructor <- class primaryConstructor[id : Integer, N : Integer, PrimeConstructor : ConstructorType, OrdinConstructor : ConstructorType]
			attached var replicas : Array.of[replicaType] 
			attached var availableNodes : Array.of[node] 
			var lock : boolean <- false
			var init : boolean <- false
			%var me : replicaType <- self
			var stopProcess : boolean <- false

			export operation getId -> [repId : Integer]
				repId <- id
			end getId

			export operation getAvailableNodes -> [res : Array.of[node]]
				res <- availableNodes
			end getAvailableNodes

			export operation addAvailableNode[newAvailableNode : Node]
				availableNodes.addUpper[newAvailableNode]
				self.notify[self]
			
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end addAvailableNode

			export operation getReplicas -> [res : Array.of[replicaType]]
				res <- replicas
			end getReplicas

			export operation getN -> [requiredReplicas : Integer]
				requiredReplicas <- N
			end getN

			export operation update
				(locate self)$stdout.putstring["Primary update. \n"]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end update

			export operation update[primary : replicaType]
				(locate self)$stdout.putstring["Primary update[primary]. \n"]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end update

			export operation setData[newData : Any, upn : Integer]
				(locate self)$stdout.putstring["Primary setData."]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end setData

			export operation getData -> [newData : Any]
				(locate self)$stdout.putstring["primary getData." || "\n"]
				unavailable
					(locate self)$stdout.putstring["abstractReplica getData. Unavailable" || "\n"]
				end unavailable
			end getData
	
			export operation ping
				(locate self)$stdout.putstring["Primary ping."|| "\n"]
				
				unavailable
					(locate self)$stdout.putstring["Primary ping. Unavailable" || "\n"]
				end unavailable
			end ping	

			export operation register
				lock <- true
				if lock then 

				end if
			end register

			operation notify
				for i : Integer <- 1 while i <= replicas.upperbound by i <- i + 1
					replicas[i].update
				end for
			end notify

			operation notify[primary : replicaType]
				for i : Integer <- 1 while i <= replicas.upperbound by i <- i + 1
					replicas[i].update[primary]
				end for
			end notify

			export operation removeUnavailableReplica
				var i : Integer <- 0
				(locate self)$stdout.putstring["Primary Degugg 1." || "\n"]
				loop
					(locate self)$stdout.putstring["Primary Degugg 2." || "\n"]
					exit when i > replicas.upperbound 
					(locate self)$stdout.putstring["Primary Degugg 3." || "\n"]
					begin
						(locate self)$stdout.putstring["Primary removeUnavailableReplica: i: "
						||i.asString || "\n"]
						replicas[i].ping
						i <- i + 1
					end
				end loop

				unavailable
					(locate self)$stdout.putstring["Primary removeUnavailableReplica unavailable." || "\n"]
					if i !== replicas.upperbound then
						replicas[i] <- replicas.removeUpper
					else
						var throw : replicaType <- replicas.removeUpper
					end if
				end unavailable
			end removeUnavailableReplica

			export operation maintainReplicas
				if (replicas.upperbound + 1) < N then
					if availableNodes.upperbound >= 0  then
						replicas.addUpper[OrdinConstructor.create[(replicas.upperbound +1), N, PrimeConstructor, OrdinConstructor]]
						fix replicas[replicas.upperbound] at availableNodes[availableNodes.upperbound]
						var throw : node <- availableNodes.removeUpper
						self.notify[self]
					else
					(locate self)$stdout.putstring["Primary: There is not enough active nodes to maintain the given number of replicas: " 
						||N.asString|| " given, only " || ((locate self)$ActiveNodes.upperbound ).asString
						|| " nodes active."|| "\n"]
					end if
				end if
			end maintainReplicas

			export operation initializeDataStructures[reps : Array.of[replicaType], availableN : Array.of[node]]
				(locate self)$stdout.putstring["Primary setModifiedArrays." || "\n"]
					
				self.initReplicas[reps]
				self.initAvailableNodes[availableN]
				
				if init == false then 
					self.notify[self]
					(locate self).setNodeEventHandler[primaryEventHandler.create[self, id, N]]
					init <- true
				end if			
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

			process
				loop
					exit when init == true 
					begin
						(locate self)$stdout.putstring["Primary process init" || "\n"]
						(locate self).delay[Time.create[1, 0]]
					end
				end loop
				var i : Integer <- 0
				loop
					exit when stopProcess == true 
					begin
						(locate self)$stdout.putstring["Primary processloop. LNN: " ||(locate self)$LNN.asString
						||"\n AvailableNodes.upperbound: " || availableNodes.upperbound.asString 
						|| ". Replicas.upperbound: " || replicas.upperbound.asString ||"\n"]
						(locate self).delay[Time.create[2, 0]]
						%self.ping
						%self.maintainReplicas
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Primary process. Unavailable" || "\n"]
				end unavailable
				failure
						(locate self)$stdout.putstring["Primary process. Failure. Process." ||"\n"]
					end failure
			end process
end primaryConstructor

