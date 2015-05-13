export primaryEventHandler
export ordinaryEventHandler

const primaryEventHandler <- class primaryEventHandler[myReplicaObject : replicaType, id : Integer
							, N : Integer, PrimConstructor : ConstructorType]
				var replicas : Array.of[replicaType]
				var availableNodes : Array.of[node]

				export operation nodeUp[nodeUp : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeUp:" ||"\n"]

					
					myReplicaObject.setAvailableNode[nodeUp]
					myReplicaObject.maintainReplicas

					unavailable
						(locate self)$stdout.putstring["Primary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[nodeDown : node, t : Time]
					replicas <- myReplicaObject.getReplicas
					myReplicaObject.removeUnavailableReplica
					myReplicaObject.maintainReplicas
					(locate self)$stdout.putstring["Primary: nodeDown. " || "\n"]
					unavailable 
						(locate self)$stdout.putstring["Primary: nodeDown. Unavailable " || "\n"]
					end unavailable

					failure
						(locate self)$stdout.putstring["Primary Failure: 4. ID: "||id.asString ||"\n"]
					end failure
				end nodeDown
	
			end primaryEventHandler

const ordinaryEventHandler <- class ordinaryEventHandler[myReplicaObject : replicaType, id : Integer
							, N : Integer, PrimConstructor : ConstructorType]

				var replicas : Array.of[replicaType]
				var availableNodes : Array.of[node]

				export operation nodeUp[nodeUp : node, t : Time]
					(locate self)$stdout.putstring["Ordinary NodeUp:" ||"\n"]
					availableNodes <- myReplicaObject.getAvailableNodes
					availableNodes.addUpper[nodeUp]

					unavailable
						(locate self)$stdout.putstring["Ordinary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[nodeDown : node, t : Time]
					replicas <- myReplicaObject.getReplicas
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