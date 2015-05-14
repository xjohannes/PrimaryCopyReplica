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
					(locate self)$stdout.putstring["Primary: nodeDown 1. " || "\n"]
					myReplicaObject.removeUnavailableReplica
					(locate self)$stdout.putstring["Primary: nodeDown. 2" || "\n"]
					myReplicaObject.maintainReplicas
					(locate self)$stdout.putstring["Primary: nodeDown. 3" || "\n"]
					
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
						if id == 1 then 
							myReplicaObject.addAvailableNode[nodeUp]
						end if
						(locate self)$stdout.putstring["Ordinary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[nodeDown : node, t : Time]
					(locate self)$stdout.putstring["Ordinary: nodeDown. 1" || "\n"]
					replicas <- myReplicaObject.getReplicas
					(locate self)$stdout.putstring["Ordinary: nodeDown. 2" || "\n"]
					replicas[0].ping
			
					unavailable
						(locate self)$stdout.putstring["Ordinary eventhandler Unavailable: Primary node is down.  " 
							||replicas.upperbound.asString|| "\n"]
						
						if id == 1 then
							myReplicaObject.maintainReplicas
						end if 			
					end unavailable
					failure
						(locate self)$stdout.putstring["Ordinary Failure: 4. ID: "||id.asString ||"\n"]
					end failure
				end nodeDown
	
			end ordinaryEventHandler