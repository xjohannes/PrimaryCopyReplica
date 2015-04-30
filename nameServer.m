export nameServerConstructor

const nameServerConstructor <- class nameServerConstructor[replicaId : Integer, fw : frameworkType]
			attached var primary : boolean <- false
			attached var frameWork:FrameworkType <- fw
			attached var data : Array.of[String] <- Array.of[String].create[0]
			attached var nrOfClones : Integer <- 0
			attached var id : Integer <- replicaId
			
			export operation cloneMe -> [clone : replicaType]
				self.addClone
				clone <- nameServerConstructor.create[nrOfClones, frameWork]
				
				for i : Integer <- 0 while i <= data.upperbound by i <- i + 1
					clone.insert[data[i]]
				end for
			end cloneMe

			export operation insert[newData : String]
				data.addUpper[newData]
				self.print[" inserting new data in clone:  " || newData ]
			end insert

			export operation update[prime:replicaType]
				data.addUpper[prime.getData]
				self.print[" updated filelist with: " || data[data.upperbound]]
			end update

			export operation getData -> [res : String]
				res <- data[data.upperbound]
			end getData
	
			export operation setData[newData : Any]
				(locate self)$stdout.putstring["\nPrimary: setData -1. "|| "\n" ]
				if self.isPrimary then 
					(locate self)$stdout.putstring["\nPrimary: setData 0. "|| "\n" ]
					data.addupper[view newData as String]
					(locate self)$stdout.putstring["\nPrimary: setData 1. "|| "\n" ]
					self.print[" added " || data[data.upperbound]]
					(locate self)$stdout.putstring["Primary: setData 2. "|| "\n" ]
					framework.notify
					(locate self)$stdout.putstring["Primary: setData 3."|| "\n" ]
				else
					(locate self)$stdout.putstring["\nReplica: Can not set data. " || "Calling primary."|| "\n" ]
					var currentPrimary : replicaType <- framework.getPrimary
					currentPrimary.setData[newData]
				end if
				unavailable
					(locate self)$stdout.putstring["\nPrimary is unavailable."|| "\n" ]
				end unavailable

				failure
					(locate self)$stdout.putstring["Set Data: failure "  ||" \n"]
				end failure
			end setData
	
			export operation setToPrimary
				primary <- true
				(locate self)$stdout.putstring["\nI am now the new primary."|| "\n" ]
			end setToPrimary

			export operation isPrimary ->[res : boolean]
				res <- primary
			end isPrimary

			export operation print[msg : String]
				if self.isPrimary then 
					(locate self)$stdout.putstring["\nPrimary: " || msg || " \n" ]
				else
					(locate self)$stdout.putstring["\nReplica: " || msg || "\n" ]
				end if
				for i:Integer <- 0 while i <= data.upperbound by i <- i + 1
					(locate self)$stdout.putstring[data[i] || "\n" ]
				end for
				%(locate self)$stdout.putstring["\nDebug: print: " || "\n" ]
			end print

			export operation getId -> [res : Integer]
				res <- id
			end getId

			export operation ping
				if self.isPrimary then 
					(locate self)$stdout.putstring["\nPrimary: Ping" || " \n" ]
				else
					(locate self)$stdout.putstring["\nReplica: Ping" || "\n" ]
				end if
			end ping

			operation addClone
				nrOfClones <- nrOfClones + 1
			end addClone


			operation runTest
				(locate self).delay[Time.create[10 , 0]]
				if !self.isPrimary then
					self.setData["The Beatles:"]
				end if
				
			end runTest

			process
				self.runTest
			end process
end nameServerConstructor 