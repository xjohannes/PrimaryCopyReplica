export ReplicaFactory

const ReplicaFactory <- object replicaFactory 
	
	export operation createPrimary[availableNodes : Array.of[Node], replicas : Array.of[replicaType], N : Integer]
		 -> [ordinary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Primary replica." || "\n"]
		ordinary <- object ordinary  
			%var replicaFactory : replicaFactoryType
			attached var replicas : Array.of[replicaType] <- replicas
			var lock : boolean <- false
			%%%%%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%%%%%%%%%%%%
			const ordinaryEventHandler <- object ordinaryEventHandler
				
				export operation nodeUp[n : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeUp:" ||"\n"]
					availableNodes.addUpper[n]
					unavailable
						(locate self)$stdout.putstring["Primary: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[n : node, t : Time]
					(locate self)$stdout.putstring["Primary NodeDown:"  ||"\n"]
					ordinary.update
					unavailable
						(locate self)$stdout.putstring["Primary: nodeDown. Unavailable " || "\n"]
					end unavailable
				end nodeDown
	
			end ordinaryEventHandler
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
				(locate self)$stdout.putstring["ordinary getData." || "\n"]
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

			process
				var i : Integer <- 0
				loop
					exit when i >= 240 
					begin
						(locate self)$stdout.putstring["Primary processloop. N: " ||N.asString|| " () " || availableNodes.upperbound.asString|| "\n"]
						(locate self).delay[Time.create[2, 0]]
						self.ping
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end process

			initially
				(locate self).delay[Time.create[2, 0]]
				replicas <- replicas
				(locate self).setNodeEventHandler[ordinaryEventHandler]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"|| "\n"]
				end unavailable
			end initially
		end ordinary
	end createPrimary	

	export operation createOrdinary[availableNodes : Array.of[Node], replicas : Array.of[replicaType], N : Integer]
		 -> [ordinary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Ordinary replica." || "\n"]
		ordinary <- object ordinary  
			%var replicaFactory : replicaFactoryType
			attached var replicas : Array.of[replicaType] <- replicas
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