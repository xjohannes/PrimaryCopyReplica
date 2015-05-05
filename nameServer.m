export nameServerConstructor

const nameServerConstructor <- class nameServerConstructor[replicaId : Integer, fw : frameworkType]
			attached var primary : boolean <- false
			attached var frameWork:FrameworkType <- fw
			attached var data : Array.of[String] 
			attached var nrOfClones : Integer <- 0
			attached var id : Integer <- replicaId
			
			export operation cloneMe -> [clone : replicaType]
				self.addClone
				clone <- nameServerConstructor.create[nrOfClones, frameWork]
				
				for i : Integer <- 0 while i <= data.upperbound by i <- i + 1
					clone.insert[data[i]]
				end for

				unavailable
					(locate self)$stdout.putstring["nameServer: cloneMe. Unavailable " || "\n"]
				end unavailable
			end cloneMe

			export operation insert[newData : String]
				data.addUpper[newData]
				self.print[" inserting new data in clone:  " || newData ]
				unavailable
					(locate self)$stdout.putstring["nameServer: insert. Unavailable " || "\n"]
				end unavailable
			end insert

			export operation update[prime:replicaType]
				data.addUpper[prime.getData]
				self.print[" updated filelist with: " || data[data.upperbound]]
				unavailable
					(locate self)$stdout.putstring["nameServer: update. Unavailable " || "\n"]
				end unavailable
			end update

			export operation getData -> [res : String]
				res <- data[data.upperbound]
				unavailable
					(locate self)$stdout.putstring["nameServer: getData. Unavailable " || "\n"]
				end unavailable
			end getData
	
			export operation setData[newData : Any]
				(locate self)$stdout.putstring["\n setData -1. "|| "\n" ]
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
					(locate self)$stdout.putstring["\n SetData. unavailable."|| "\n" ]
				end unavailable

				%failure
					%(locate self)$stdout.putstring["Set Data: failure "  ||" \n"]
					%self.print["Print after Failure"]
				%end failure
			end setData
	
			export operation setToPrimary[msg : String]
				primary <- true
				(locate self)$stdout.putstring["\n" || msg || ". Set to primary."|| "\n" ]
				unavailable
					(locate self)$stdout.putstring["nameServer: setToPrimary. Unavailable " || "\n"]
				end unavailable
			end setToPrimary

			export operation isPrimary ->[res : boolean]
				res <- primary
				unavailable
					(locate self)$stdout.putstring["nameServer: isPrimary. Unavailable " || "\n"]
				end unavailable
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
				unavailable
					(locate self)$stdout.putstring["nameServer: print. Unavailable " || "\n"]
				end unavailable
			end print

			export operation getId -> [res : Integer]
				res <- id
				unavailable
					(locate self)$stdout.putstring["nameServer: getId. Unavailable " || "\n"]
				end unavailable
			end getId

			export operation ping
				if self.isPrimary then 
					(locate self)$stdout.putstring["\nPrimary: Ping" || " \n" ]
				else
					(locate self)$stdout.putstring["\nReplica: Ping" || "\n" ]
				end if
				unavailable
					(locate self)$stdout.putstring["nameServer: ping. Unavailable " || "\n"]
				end unavailable
			end ping

			operation addClone
				nrOfClones <- nrOfClones + 1
				unavailable
					(locate self)$stdout.putstring["nameServer: addClone. Unavailable " || "\n"]
				end unavailable
			end addClone


			operation runTest
				if !self.isPrimary then
					self.setData["Led Zeppelin"]
					(locate self).delay[Time.create[2 , 0]]
					self.setData["Jimmy Page"]
					(locate self).delay[Time.create[2 , 0]]
					self.setData["Robert Plant"]
					(locate self).delay[Time.create[2 , 0]]
					self.setData["John Paul Jones"]
					(locate self).delay[Time.create[2 , 0]]
					self.setData["John Bonham"]
				end if
				unavailable
					(locate self)$stdout.putstring["nameServer: runTest. Unavailable " || "\n"]
				end unavailable
			end runTest

			process
				(locate self).delay[Time.create[2 , 0]]
				self.runTest
				unavailable
					(locate self)$stdout.putstring["nameServer: nameServer Prosess. Unavailable " || "\n"]
				end unavailable
			end process

			initially
				data <- Array.of[String].create[0]
			end initially
end nameServerConstructor 