export ReplicaFactory

const ReplicaFactory <- object replicaFactory 
	
	export operation createPrimary
		return object primary (abstractReplica) 
			var replicaFactory : replicaFactoryType
			export operation update
			end update

			export operation setData[newData : Any, upn : Integer]
			end setData
	
			export operation ping
			end ping		

			process

			end process

			initially

			end initially
		end primary
	end createPrimary

	export operation createOrdinary
		return object ordinary (abstractReplica) 
			var replicaFactory : replicaFactoryType
			export operation update
			end update

			export operation setData[newData : Any, upn : Integer]
			end setData
	
			export operation ping
			end ping		

			process

			end process

			initially

			end initially
		end ordinary
	end createOrdinary
	
end replicaFactory