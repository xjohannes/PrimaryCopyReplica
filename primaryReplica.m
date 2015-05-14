
export PrimaryConstructor

const PrimaryConstructor <- class primaryConstructor[id : Integer, N : Integer, OrdinConstructor : ConstructorType]
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
				(locate self)$stdout.putstring["Primary getAvailableNodes.Before: AvailableN.upperbound:"
				|| availableNodes.upperbound.asString || "\n"]
				res <- availableNodes
				(locate self)$stdout.putstring["Primary getAvailableNodes. After: AvailableN.upperbound:"
				|| availableNodes.upperbound.asString || "\n"]
			end getAvailableNodes

			export operation setAvailableNode[newAvailableNode : Node]
				(locate self)$stdout.putstring["Primary setAvailableNode1. AvailableN.upperbound:"
				|| availableNodes.upperbound.asString || "\n"]
				availableNodes.addUpper[newAvailableNode]
				(locate self)$stdout.putstring["Primary setAvailableNode2. AvailableN.upperbound:"
				|| availableNodes.upperbound.asString || "\n"]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end setAvailableNode

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
				(locate self)$stdout.putstring["Primary update. \n"]
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
				for i : Integer <- 0 while i <= replicas.upperbound by i <- i + 1
					replicas[i].update
				end for
			end notify

			operation notify[primary : replicaType]
				for i : Integer <- 0 while i <= replicas.upperbound by i <- i + 1
					replicas[i].update[primary]
				end for
			end notify

			export operation removeUnavailableReplica
				var i : Integer <- 0
				loop
					exit when i > replicas.upperbound 
					begin
						(locate self)$stdout.putstring["Primary removeUnavailableReplica: i: "
						||i.asString || "\n"]
						replicas[i].ping
						i <- i + 1
					end
				end loop

				unavailable
					if i !== replicas.upperbound then
						(locate self)$stdout.putstring["Primary  unavailable. 1 replicas.upperbound: "
						||replicas.upperbound.asString || "\n"]
						replicas[i] <- replicas.removeUpper
						(locate self)$stdout.putstring["Primary  unavailable. 2 replicas.upperbound: "
						||replicas.upperbound.asString || "\n"]
					else
						(locate self)$stdout.putstring["Primary  unavailable. 3 replicas.upperbound: "
						||replicas.upperbound.asString || "\n"]
						var throw : replicaType <- replicas.removeUpper
						(locate self)$stdout.putstring["Primary  unavailable. 4 replicas.upperbound: "
						||replicas.upperbound.asString || "\n"]
					end if
					(locate self)$stdout.putstring["Primary  unavailable." || "\n"]
				end unavailable
			end removeUnavailableReplica

			export operation maintainReplicas
				if (replicas.upperbound + 1) < N then
				(locate self)$stdout.putstring["Primary maintainReplicas. N: "||N.asString 
				||" ** repl upperbound:"||(replicas.upperbound).asString ||". availableNodes upperbound: "
				||(availableNodes.upperbound).asString|| "\n"]
					if availableNodes.upperbound >= 0  then
						replicas.addUpper[OrdinConstructor.create[(replicas.upperbound +1), N, OrdinConstructor]]
						(locate self)$stdout.putstring["Primary maintainReplicas. ME: "
						|| (locate self)$LNN.asString || ", new node: "
						|| availableNodes[availableNodes.upperbound]$LNN.asString||"\n"]
						fix replicas[replicas.upperbound] at availableNodes[availableNodes.upperbound]
						var throw : node <- availableNodes.removeUpper
						(locate self)$stdout.putstring["Primary maintainReplicas. availableNodes.upperbound after remove : "
						|| availableNodes.upperbound.asString||"\n"]
						self.notify[self]
					else
					(locate self)$stdout.putstring["Primary: There is not enough active nodes to maintain the given number of replicas: " 
						||N.asString|| " given, only " || ((locate self)$ActiveNodes.upperbound ).asString
						|| " nodes active."|| "\n"]
					end if
				end if
			end maintainReplicas	

			export operation setModifiedArrays[reps : Array.of[replicaType], availableN : Array.of[node]]
				if reps !== nil then
					replicas <- reps
					(locate self)$stdout.putstring["Primary setModifiedArrays.1.2" 
				||" ** replicas.upperbound:"||(replicas.upperbound).asString || "\n"]
				end if	
				if availableN !== nil then
					availableNodes <- availableN
					(locate self)$stdout.putstring["Primary setModifiedArrays. 2.2" 
				||" ** replicas.upperbound:"||(replicas.upperbound).asString ||". availableNodes.upperbound: "
				||(availableNodes.upperbound).asString|| "\n"]
				end if
				if init == false then 
					self.notify[self]
					(locate self).setNodeEventHandler[primaryEventHandler.create[self, id, N]]
					init <- true
				end if
				(locate self)$stdout.putstring["Primary setModifiedArrays. 3" 
				||" ** replicas.upperbound:"||(replicas.upperbound).asString ||". availableNodes.upperbound: "
				||(availableNodes.upperbound).asString|| "\n"]
				
			end setModifiedArrays

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
						(locate self)$stdout.putstring["Primary processloop. AvailableNodes.upperbound: " 
						|| availableNodes.upperbound.asString || ". Replicas.upperbound: "
							|| replicas.upperbound.asString ||"\n"]
						(locate self).delay[Time.create[2, 0]]
						%self.ping
						%self.maintainReplicas
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
				failure
						(locate self)$stdout.putstring["Primary Failure: 4. Process." ||"\n"]
					end failure
			end process

			initially

				%(locate self).delay[Time.create[1, 0]]
				%(locate self)$stdout.putstring["Primary initially. reps.upper: "||replicas.upperbound.asString || "\n"]
				
				
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"|| "\n"]
				end unavailable
			end initially
end primaryConstructor

