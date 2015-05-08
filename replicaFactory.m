export ReplicaFactory

const ReplicaFactory <- object replicaFactory 
	
	export operation createPrimary -> [primary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Primary replica." || "\n"]
		primary <- object primary  
			%var replicaFactory : replicaFactoryType
		
			export operation update
				(locate self)$stdout.putstring["Primary update. " || "\n"]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
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

	export operation createOrdinary -> [ordinary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Ordinary replica." || "\n"]
		ordinary <- object ordinary  
			%var replicaFactory : replicaFactoryType
			
			export operation update
				(locate self)$stdout.putstring["Ordinary update."]
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