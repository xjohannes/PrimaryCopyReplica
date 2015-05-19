export primaryEventHandler
export ordinaryEventHandler

const primaryEventHandler <- class primaryEventHandler[myReplicaObject : replicaType, id : Integer
							, N : Integer]
				var replicas : Array.of[replicaType]
				var availableNodes : Array.of[node]

				export operation nodeUp[nodeUp : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeUp: LNN: "||nodeUp$LNN.asString ||"\n"]
					myReplicaObject.addAvailableNode[nodeUp]
					myReplicaObject.maintainReplicas

					unavailable
						(locate self)$stdout.putstring["Primary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[nodeDown : node, t : Time]
					(locate self)$stdout.putstring["Primary: nodeDown." || "\n"]
					myReplicaObject.removeUnavailableReplica
					myReplicaObject.maintainReplicas
					
					unavailable 
						(locate self)$stdout.putstring["Primary: nodeDown. Unavailable " || "\n"]
					end unavailable

					failure
						(locate self)$stdout.putstring["Primary Failure: ID: "||id.asString ||"\n"]
					end failure
				end nodeDown
	
			end primaryEventHandler

const ordinaryEventHandler <- class ordinaryEventHandler[myReplicaObject : replicaType, id : Integer
							, N : Integer]

				var replicas : Array.of[replicaType]
				var availableNodes : Array.of[node]

				export operation nodeUp[nodeUp : node, t : Time]
					(locate self)$stdout.putstring["Ordinary NodeUp:" ||"\n"]
					myReplicaObject.ping
					
					unavailable
						(locate self)$stdout.putstring["Ordinary: nodeUp . Unavailable " || "\n"]
						var tmp : Array.of[replicaType] <- myReplicaObject.getReplicas
						if myReplicaObject == tmp[1] then
							myReplicaObject.addAvailableNode[nodeUp]
						end if 

						
					end unavailable
				end nodeUp
				
				export operation nodeDown[nodeDown : node, t : Time]
					(locate self)$stdout.putstring["Ordinary: nodeDown." || "\n"]
					replicas <- myReplicaObject.getReplicas
					replicas[0].ping
			
					unavailable
						(locate self)$stdout.putstring["Ordinary nodeDown Unavailable 1: Primary node is down.  " 
							||myReplicaObject.getId.asString|| "\n"]
						var tmp : Array.of[replicaType] <- myReplicaObject.getReplicas
						if myReplicaObject == tmp[1] then
							myReplicaObject.maintainReplicas
							(locate self)$stdout.putstring["Ordinary nodeDown Unavailable 2: Primary node is down.  " 
							||myReplicaObject.getId.asString|| "\n"]
						end if 			
					end unavailable
					failure
						(locate self)$stdout.putstring["Ordinary Failure. ID: "||id.asString ||"\n"]
					end failure
				end nodeDown
			end ordinaryEventHandler
