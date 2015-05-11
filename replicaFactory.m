export ReplicaFactory

const ReplicaFactory <- object replicaFactory 
	
	export operation createPrimary[availableNodes : Array.of[Node]] -> [primary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Primary replica." || "\n"]
		primary <- object primary  
			%var replicaFactory : replicaFactoryType
		
			%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%
			const primaryEventHandler <- object primaryEventHandler
				
				export operation nodeUp[n : node, t : Time]
					(locate self)$stdout.putstring["Primary Node up handler:" ||"\n"]
					availableNodes.addUpper[n]
					unavailable
						(locate self)$stdout.putstring["Ordinary nodeHandler: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[n : node, t : Time]
					(locate self)$stdout.putstring["Ordinary Node is down:"  ||"\n"]
					primary.update
					unavailable
						(locate self)$stdout.putstring["Primary EventHandler: nodeDown. Unavailable " || "\n"]
					end unavailable
				end nodeDown
				
			end primaryEventHandler
			%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%
			export operation update
				(locate self)$stdout.putstring["Primary update. " || "\n"]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable\n"]
				end unavailable
			end update

			export operation setData[newData : Any, upn : Integer]
				(locate self)$stdout.putstring["Primary setData." || "\n"]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end setData

			export operation getData -> [newData : Any]
				(locate self)$stdout.putstring["abstractReplica getData." || "\n"]
				unavailable
					(locate self)$stdout.putstring["Primary getData. Unavailable" || "\n"]
				end unavailable
			end getData
	
			export operation ping
				(locate self)$stdout.putstring["Primary ping." || "\n"]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end ping		

			process
				var i : Integer <- 0
				loop
					(locate self)$stdout.putstring["Primary loop." || "\n"]
					exit when i >= 240 
					begin
						(locate self).delay[Time.create[2, 0]]
						self.ping
					end
				end loop
				
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end process

			initially
				(locate self).setNodeEventHandler[primaryEventHandler]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable" || "\n"]
				end unavailable
			end initially
		end primary
	end createPrimary

	export operation createOrdinary[availableNodes : Array.of[Node]] -> [ordinary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Ordinary replica." || "\n"]
		ordinary <- object ordinary  
			%var replicaFactory : replicaFactoryType
			%%%%%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%%%%%%%%%%%%
			const ordinaryEventHandler <- object ordinaryEventHandler
				
				export operation nodeUp[n : node, t : Time]
					(locate self)$stdout.putstring["Primary Node up handler:" ||"\n"]
					availableNodes.addUpper[n]
					unavailable
						(locate self)$stdout.putstring["Primary nodeHandler: nodeUp . Unavailable " || "\n"]
					end unavailable
				end nodeUp
				
				export operation nodeDown[n : node, t : Time]
					(locate self)$stdout.putstring["Primary Node is down:"  ||"\n"]
					ordinary.update
					unavailable
						(locate self)$stdout.putstring["Ordinary EventHandler: nodeDown. Unavailable " || "\n"]
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

			process
				var i : Integer <- 0
				loop
					exit when i >= 240 
					begin
						(locate self)$stdout.putstring["Ordinary loop." || "\n"]
						(locate self).delay[Time.create[2, 0]]
						self.ping
					end
				end loop
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable" || "\n"]
				end unavailable
			end process

			initially
				(locate self).setNodeEventHandler[ordinaryEventHandler]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"|| "\n"]
				end unavailable
			end initially
		end ordinary
	end createOrdinary


	
end replicaFactory