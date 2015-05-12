export primaryEventHandler
export ordinaryEventHandler

const primaryEventHandler <- class primaryEventHandler[myReplicaObject : replicaType, id : Integer
							, availableNodes : Array.of[Node], replicas : Array.of[replicaType], N : Integer
							, PrimConstructor : ConstructorType]
				
				export operation nodeUp[nodeUp : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeUp:" ||"\n"]
					availableNodes.addUpper[nodeUp]

					unavailable
						(locate self)$stdout.putstring["Primary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[nodeDown : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeDown:"  ||"\n"]

					replicas[0].maintainReplicas
					
					unavailable 
						(locate self)$stdout.putstring["Primary: nodeDown. Unavailable " || "\n"]
					end unavailable
				end nodeDown
	
			end primaryEventHandler

const ordinaryEventHandler <- class ordinaryEventHandler[myReplicaObject : replicaType, id : Integer
							, availableNodes : Array.of[Node], replicas : Array.of[replicaType], N : Integer
							, PrimConstructor : ConstructorType]

				export operation nodeUp[nodeUp : node, t : Time]
					(locate self)$stdout.putstring["Ordinary NodeUp:" ||"\n"]
					availableNodes.addUpper[nodeUp]

					unavailable
						(locate self)$stdout.putstring["Ordinary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[nodeDown : node, t : Time]
					(locate self)$stdout.putstring["Ordinary NodeDown:"  ||"\n"]
					
					(locate self)$stdout.putstring["Debug: repls:  " ||replicas.upperbound.asString|| "\n"]
					replicas[0].ping

					unavailable
						(locate self)$stdout.putstring["Ordinary eventhandler Unavailable: Primary node is down.  " 
							||replicas.upperbound.asString|| "\n"]
						
						if id == 1 then
							(locate self)$stdout.putstring["Ordinary eventhandler Unavailable: " 
								|| "Primary node is down.  " || "\n"]
							var tmp : replicaType <- PrimConstructor.create[0, availableNodes
									, replicas, N, PrimConstructor]
						replicas.addUpper[tmp]
						(locate self)$stdout.putstring["After: " 
							||replicas.upperbound.asString|| "\n"]
						end if 			
					end unavailable
				end nodeDown
	
			end ordinaryEventHandler