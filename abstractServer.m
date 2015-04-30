export abstractServer

const abstractServer <- object abstractServer
			attached var primary : boolean <- false
			attached var data : Any

			export operation update
			end update

			export operation getData -> [res : Any]
				res <- data
			end getData
	
			export operation setData[newData : Any]
				data <- newData
			end setData
	
			export operation cloneMe -> [clone : replicaType]
				%clone <- abstractServer.create[data, framework]
			end cloneMe

			export operation setToPrimary
				primary <- true
			end setToPrimary

			export operation isPrimary ->[res : boolean]
				res <- primary
			end isPrimary

			operation runTest

			end runTest

			export operation print[msg:String]
				if self.isPrimary then 
					(locate self)$stdout.putstring["Primary: " || msg || "\n" ]
				end if
			end print

		end abstractServer

