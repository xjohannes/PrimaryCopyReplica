export replicaConstructor

const replicaConstructor <- class replicaClass[replicaId : Integer, fw : frameworkType, obj : ClonableType]
			attached var myObject : ClonableType <- obj
			attached var primary : boolean <- false
			var frameWork:FrameworkType <- fw
			attached var data : Array.of[String] 
			attached var nrOfClones : Integer <- 0
			attached var id : Integer <- replicaId
			attached var updateNumber : Integer <- 0
			attached var monitorObject : MonitorType 
			
			export operation cloneMe -> [clone : replicaType]
				self.addClone
				clone <- replicaClass.create[nrOfClones, frameWork, myObject.cloneMe]
				
				unavailable
					(locate self)$stdout.putstring["Replica: cloneMe. Unavailable " || "\n"]
				end unavailable
			end cloneMe

			export operation insert[newData : String]
				self.print["Replica inserting"]
				unavailable
					(locate self)$stdout.putstring["Replica: insert. Unavailable " || "\n"]
				end unavailable
			end insert
			export operation update
				
				unavailable
					(locate self)$stdout.putstring["Replica: update. Unavailable " || "\n"]
				end unavailable
			end update

			export operation update[newData : Any]
				if self.isPrimary then
					self.print["Primary Update: "]
				end if

				unavailable
					(locate self)$stdout.putstring["Replica: update. Unavailable " || "\n"]
				end unavailable
			end update

			export operation getUpn -> [updateNr : Integer]
				updateNr <- updateNumber
			end getUpn

			export operation getData -> [res : String]
				(locate self)$stdout.putstring["replica: getData. Not Implemented. " || "\n"]
				unavailable
					(locate self)$stdout.putstring["Replica: getData. Unavailable " || "\n"]
				end unavailable
			end getData
	
			export operation setData[newData : Any]
				
			end setData
	
			export operation setToPrimary[msg : String]
				primary <- true
				(locate self)$stdout.putstring["\n" || msg || ". Set to primary."|| "\n" ]
				unavailable
					(locate self)$stdout.putstring["Replica: setToPrimary. Unavailable " || "\n"]
				end unavailable
			end setToPrimary

			export operation isPrimary ->[res : boolean]
				res <- primary
				unavailable
					(locate self)$stdout.putstring["Replica: isPrimary. Unavailable " || "\n"]
				end unavailable
			end isPrimary

			export operation print[msg : String]
				myObject.print[msg]
				unavailable
					(locate self)$stdout.putstring["Replica: print. Unavailable " || "\n"]
				end unavailable
			end print

			export operation getId -> [res : Integer]
				res <- id
				unavailable
					(locate self)$stdout.putstring["Replica: getId. Unavailable " || "\n"]
				end unavailable
			end getId

			export operation ping
				if self.isPrimary then 
					(locate self)$stdout.putstring["\nPrimary: Ping" || " \n" ]
				else
					(locate self)$stdout.putstring["\nReplica: Ping" || "\n" ]
				end if
				unavailable
					(locate self)$stdout.putstring["Replica: ping. Unavailable " || "\n"]
				end unavailable
			end ping

			operation addClone
				nrOfClones <- nrOfClones + 1
				unavailable
					(locate self)$stdout.putstring["Replica: addClone. Unavailable " || "\n"]
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
					(locate self)$stdout.putstring["Replica: runTest. Unavailable " || "\n"]
				end unavailable
			end runTest

			process
				(locate self).delay[Time.create[2 , 0]]
				%const home <- (locate self)
				%self.runTest
				unavailable
					(locate self)$stdout.putstring["Replica: Replica Prosess. Unavailable " || "\n"]
				end unavailable
			end process

			initially
				monitorObject <- MonitorConstructor.create[myObject, self]
				%data <- Array.of[String].create[0]
			end initially
end replicaClass 