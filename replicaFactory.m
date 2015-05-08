export ReplicaFactory

const ReplicaFactory <- object replicaFactory 
	
	export operation createPrimary -> [primary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Primary replica." || "\n"]
		return 
		class primary (abstractReplica) 
			%var replicaFactory : replicaFactoryType
		
			export operation update
				(locate self)$stdout.putstring["Primary update."]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end update

			export operation setData[newData : Any, upn : Integer]
				(locate self)$stdout.putstring["Primary setData."]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end setData
	
			export operation ping
				(locate self)$stdout.putstring["Primary ping."]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end ping		

			process
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end process

			initially
				(locate self).setNodeEventHandler[primaryEventHandler]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end initially
		end primary
	end createPrimary

	export operation createOrdinary -> [primary : replicaType]
		(locate self)$stdout.putstring["ReplicaFactory: Creating Ordinary replica." || "\n"]
		return 
		class ordinary (abstractReplica) 
			%var replicaFactory : replicaFactoryType
			
			export operation update
				(locate self)$stdout.putstring["Ordinary update."]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end update

			export operation setData[newData : Any, upn : Integer]
				(locate self)$stdout.putstring["Ordinary setData."]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end setData
	
			export operation ping
				(locate self)$stdout.putstring["Ordinary ping."]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end ping		

			process
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end process

			initially
				(locate self).setNodeEventHandler[ordinaryEventHandler]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end initially
		end ordinary
	end createOrdinary


	
end replicaFactory