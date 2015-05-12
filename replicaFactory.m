export ReplicaFactory
export PrimaryConstructor
export OridnaryConstructor

const PrimaryConstructor <- class primaryConstructor[availableNodes : Array.of[Node], reps : Array.of[replicaType], N : Integer]
			%var replicaFactory : replicaFactoryType
			attached var replicas : Array.of[replicaType] %<- replicas
			var lock : boolean <- false
			%%%%%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%%%%%%%%%%%%
			const primaryEventHandler <- object primaryEventHandler
				
				export operation nodeUp[n : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeUp:" ||"\n"]
					availableNodes.addUpper[n]
					unavailable
						(locate self)$stdout.putstring["Primary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[n : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeDown:"  ||"\n"]
					replicas[0].update
					unavailable
						(locate self)$stdout.putstring["Primary: nodeDown. Unavailable " || "\n"]
					end unavailable
				end nodeDown
	
			end primaryEventHandler
			%%%%%%%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%%%%%%%%
			export operation update
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
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end ping	

			export operation register
				lock <- true
				if lock then 

				end if
			end register

			operation maintainReplicas
				(locate self)$stdout.putstring["1. Primary maintainReplicas. N: " ||N.asString|| " () " || replicas.upperbound.asString|| "\n"]
				if availableNodes !== nil then
					if replicas.upperbound <= N then
						(locate self)$stdout.putstring["2. Primary maintainReplicas. N: " ||N.asString|| " () " || replicas.upperbound.asString|| "\n"] 
						var tmp : replicaType <- oridnaryConstructor.create[availableNodes, replicas, N]
						%(locate self)$stdout.putstring["3. Primary maintainReplicas. N: " ||N.asString|| " () " || replicas.upperbound.asString|| "\n"]
						replicas.addUpper[tmp]
					end if
				else
					(locate self)$stdout.putstring["There is not enough active nodes to maintain the given number of replicas: " 
						||N.asString|| " given, only " || ((locate self)$ActiveNodes.upperbound + 1).asString|| " nodes active."|| "\n"]
				end if
			end maintainReplicas	

			process
				var i : Integer <- 0
				loop
					exit when i >= 240 
					begin
						(locate self)$stdout.putstring["Primary processloop. N: " ||N.asString|| " () " || availableNodes.upperbound.asString|| "\n"]
						(locate self).delay[Time.create[2, 0]]
						self.ping
						self.maintainReplicas
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end process

			initially
				(locate self).delay[Time.create[2, 0]]
				replicas <- reps
				(locate self).setNodeEventHandler[primaryEventHandler]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"|| "\n"]
				end unavailable
			end initially
end primaryConstructor

const OridnaryConstructor <- class oridnaryConstructor[availableNodes : Array.of[Node], replicas : Array.of[replicaType], N : Integer]
			%var replicaFactory : replicaFactoryType
			%attached var replicas : Array.of[replicaType] <- replicas
			var lock : boolean <- false
			%%%%%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%%%%%%%%%%%%
			const ordinaryEventHandler <- object ordinaryEventHandler
				
				export operation nodeUp[n : node, t : Time]
					(locate self)$stdout.putstring["Ordinary NodeUp:" ||"\n"]
					availableNodes.addUpper[n]
					unavailable
						(locate self)$stdout.putstring["Ordinary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[n : node, t : Time]
					(locate self)$stdout.putstring["Ordinary NodeDown:"  ||"\n"]
					%replicas.maintain
					unavailable
						(locate self)$stdout.putstring["Ordinary: nodeDown. Unavailable " || "\n"]
					end unavailable
				end nodeDown
	
			end ordinaryEventHandler
			%%%%%%%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%%%%%%%%
			export operation update
				(locate self)$stdout.putstring["Ordinary update. \n"]
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
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end ping	

			export operation register
				lock <- true
				if lock then 

				end if
			end register	

			process
				var i : Integer <- 0
				loop
					exit when i >= 240 
					begin
						(locate self)$stdout.putstring["Ordinary processloop. N: " ||N.asString|| " () " || availableNodes.upperbound.asString|| "\n"]
						(locate self).delay[Time.create[2, 0]]
						self.ping
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end process

			initially
				(locate self).delay[Time.create[2, 0]]
				%replicas <- replicas
				(locate self).setNodeEventHandler[ordinaryEventHandler]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"|| "\n"]
				end unavailable
			end initially
end oridnaryConstructor



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% ReplicaFactory depricated %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

const ReplicaFactory <- object replicaFactory 
	
	export operation createPrimary[availableNodes : Array.of[Node], replicas : Array.of[replicaType], N : Integer, RF : ReplicaFactoryType]
		 -> [primary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Primary replica." || "\n"]
		primary <- object primary  
			%var replicaFactory : replicaFactoryType
			%attached var replicas : Array.of[replicaType] <- replicas
			var lock : boolean <- false
			%%%%%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%%%%%%%%%%%%
			const primaryEventHandler <- object primaryEventHandler
				
				export operation nodeUp[n : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeUp:" ||"\n"]
					availableNodes.addUpper[n]
					unavailable
						(locate self)$stdout.putstring["Primary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[n : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeDown:"  ||"\n"]
					primary.update
					unavailable
						(locate self)$stdout.putstring["Primary: nodeDown. Unavailable " || "\n"]
					end unavailable
				end nodeDown
	
			end primaryEventHandler
			%%%%%%%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%%%%%%%%
			export operation update
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
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end ping	

			export operation register
				lock <- true
				if lock then 

				end if
			end register

			operation maintainReplicas
				(locate self)$stdout.putstring["1. Primary maintainReplicas. N: " ||N.asString|| " () " || replicas.upperbound.asString|| "\n"]
				if availableNodes !== nil then
					if replicas.upperbound <= N then
						(locate self)$stdout.putstring["2. Primary maintainReplicas. N: " ||N.asString|| " () " || replicas.upperbound.asString|| "\n"] 
						var tmp : replicaType <- ReplicaFactory.createOrdinary[availableNodes, replicas, N, RF]
						(locate self)$stdout.putstring["3. Primary maintainReplicas. N: " ||N.asString|| " () " || replicas.upperbound.asString|| "\n"]
						%replicas.addUpper[tmp]
					end if
				end if
			end maintainReplicas	

			process
				var i : Integer <- 0
				loop
					exit when i >= 240 
					begin
						(locate self)$stdout.putstring["Primary processloop. N: " ||N.asString|| " () " || availableNodes.upperbound.asString|| "\n"]
						(locate self).delay[Time.create[2, 0]]
						self.ping
						self.maintainReplicas
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end process

			initially
				(locate self).delay[Time.create[2, 0]]
				replicas <- replicas
				(locate self).setNodeEventHandler[primaryEventHandler]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"|| "\n"]
				end unavailable
			end initially
		end primary
	end createPrimary	

	export operation createOrdinary[availableNodes : Array.of[Node], replicas : Array.of[replicaType], N : Integer, RF : ReplicaFactoryType]
		 -> [ordinary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Ordinary replica." || "\n"]
		ordinary <- object ordinary  
			%var replicaFactory : replicaFactoryType
			%attached var replicas : Array.of[replicaType] <- replicas
			var lock : boolean <- false
			%%%%%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%%%%%%%%%%%%
			const ordinaryEventHandler <- object ordinaryEventHandler
				
				export operation nodeUp[n : node, t : Time]
					(locate self)$stdout.putstring["Ordinary NodeUp:" ||"\n"]
					availableNodes.addUpper[n]
					unavailable
						(locate self)$stdout.putstring["Ordinary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[n : node, t : Time]
					(locate self)$stdout.putstring["Ordinary NodeDown:"  ||"\n"]
					ordinary.update
					unavailable
						(locate self)$stdout.putstring["Ordinary: nodeDown. Unavailable " || "\n"]
					end unavailable
				end nodeDown
	
			end ordinaryEventHandler
			%%%%%%%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%%%%%%%%
			export operation update
				(locate self)$stdout.putstring["Ordinary update. \n"]
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
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end ping	

			export operation register
				lock <- true
				if lock then 

				end if
			end register	

			process
				var i : Integer <- 0
				loop
					exit when i >= 240 
					begin
						(locate self)$stdout.putstring["Ordinary processloop. N: " ||N.asString|| " () " || availableNodes.upperbound.asString|| "\n"]
						(locate self).delay[Time.create[2, 0]]
						self.ping
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end process

			initially
				(locate self).delay[Time.create[2, 0]]
				replicas <- replicas
				(locate self).setNodeEventHandler[ordinaryEventHandler]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"|| "\n"]
				end unavailable
			end initially
		end ordinary
	end createOrdinary	
end replicaFactory