export nameServerConstructor

const nameServerConstructor <- object nameServerConstructor
	export operation create[] -> [res : replicaType]
		return class nameServer (abstractServer)
			attached var primary : boolean
			attached var data : String
	
			export operation cloneMe -> [clone : replicaType]
				clone <- nameServerConstructor.create[]
			end cloneMe

			process
				%self.runTest
			end process

			initially
			end initially
		end nameServer
	end create
end nameServerConstructor 