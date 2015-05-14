export OridnaryConstructor

const OridnaryConstructor <- class oridnaryConstructor[id : Integer, N : Integer, PrimaryConstructor : ConstructorType]
			attached var replicas : Array.of[replicaType]
			attached var availableNodes : Array.of[node]
			var myEventHandler : EventHandlerType <- nil
			var lock : boolean <- false
			var init : boolean <- false
			%%%%%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%%%%%%%%%%%%
			
			%%%%%%%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%%%%%%%%
			export operation getId -> [repId : Integer]
				repId <- id
			end getId

			export operation getN -> [requiredReplicas : Integer]
				requiredReplicas <- N
			end getN

			export operation getAvailableNodes -> [res : Array.of[node]]
				(locate self)$stdout.putstring["Ordinary getAvailableNodes.Before: AvailableN.upperbound:"
				|| availableNodes.upperbound.asString || "\n"]
				res <- availableNodes
				(locate self)$stdout.putstring["Ordinary getAvailableNodes. After: AvailableN.upperbound:"
				|| availableNodes.upperbound.asString || "\n"]
			end getAvailableNodes

			export operation setAvailableNode[newAvailableNode : Node]
				availableNodes.addUpper[newAvailableNode]
				(locate self)$stdout.putstring["Ordinary setAvailableNode." || "\n"]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end setAvailableNode

			export operation getReplicas -> [res : Array.of[replicaType]]
				res <- replicas
			end getReplicas

			export operation update
				(locate self)$stdout.putstring["Ordinary update. \n"]
				
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end update

			export operation update[primary : replicaType]
				(locate self)$stdout.putstring["Ordinary update. \n"]
				if myEventHandler == nil then 
					myEventHandler <- ordinaryEventHandler.create[self, id, N]
					(locate self)$stdout.putstring["Ordinary update. Setting eventListener" || "\n"]
					(locate self).setNodeEventHandler[myEventHandler]
				end if
				
				replicas <- primary.getReplicas
				(locate self)$stdout.putstring["Ordinary update. Replicas.upperbound: "
					|| replicas.upperbound.asString || "\n"]
				availableNodes <- primary.getAvailableNodes
				(locate self)$stdout.putstring["Ordinary update. availableNodes.upperbound: "
					|| availableNodes.upperbound.asString || "\n"]
				init <- true
				
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end update

			export operation setData[newData : Any, upn : Integer]
				(locate self)$stdout.putstring["Ordinary setData."]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end setData

			export operation getData -> [newData : Any]
				(locate self)$stdout.putstring["ordinary getData." || "\n"]
				unavailable
					(locate self)$stdout.putstring["abstractReplica getData. Unavailable" || "\n"]
				end unavailable
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
				replicas[0] <- PrimaryConstructor.create[0, N, OridnaryConstructor]
				replicas[0].setModifiedArrays[replicas, availableNodes]
				if availableNodes !== nil & availableNodes.upperbound > -1 then 
					fix replicas[replicas.upperbound] at availableNodes.removeUpper
				else
					var throw : replicaType <- replicas.removeUpper
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

			export operation setModifiedArrays[reps : Array.of[replicaType], availableN : Array.of[node]]
				replicas <- reps
				availableNodes <- availableN
			end setModifiedArrays	

			process
				loop
					exit when init == true 
					begin
						(locate self)$stdout.putstring["Ordinary process init" || "\n"]
						(locate self).delay[Time.create[1, 0]]
					end
				end loop
				
				var i : Integer <- 0
				loop
					exit when i >= 240 
					begin
						(locate self)$stdout.putstring["Ordinary processloop. AvailableNodes.upperbound: " 
							|| availableNodes.upperbound.asString|| ". Replicas.upperbound: "
							|| replicas.upperbound.asString ||"\n"]
						(locate self).delay[Time.create[2, 0]]
						%self.ping
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
				failure
					(locate self)$stdout.putstring["Ordinary Failure:. Process." ||"\n"]
				end failure
			end process

			initially
				(locate self).delay[Time.create[2, 0]]
				
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"|| "\n"]
				end unavailable
			end initially
end oridnaryConstructor
