export nameServerConstructor

const nameServerConstructor <- object nameServerConstructor
	var createdServers : Integer <- 0

	export operation create[parentId : Integer, initKeys : Array.of[String], initObjects : Array.of[FilmDataType]] -> [newObject : ClonableType]

		newObject <- object nameServer
			attached var init : boolean <- false	
			attached var serialNr : Integer
			attached var keys : Array.of[String] <- Array.of[String].create[0]
			attached var objects : Array.of[FilmDataType] <- Array.of[FilmDataType].create[0] 

			export operation getSerial -> [res : Integer]
				res <- serialNr
			end getSerial

			export operation getParentId -> [res : Integer]
				res <- parentId
			end getParentId

			operation getKeys -> [k : Array.of[String]]
				k <- keys
			end getKeys

			operation getObjects -> [o : Array.of[FilmDataType]]
				o <- objects
			end getObjects

			export operation cloneMe -> [clone : ClonableType]
				var newKeys : Array.of[String]
				var newObjects : Array.of[FilmDataType]
				(locate self)$stdout.putstring["NameServer: Cloning id: " || self.getSerial.asString || "\n"]
				newKeys, newObjects <- self.copyData
				clone <- nameServerConstructor.create[parentId, keys, objects]

			end cloneMe

			export operation setData[newData : Any]
				var resultArray : Array.of[Any] <- view newData as Array.of[Any]
				var keysTmp : String <- view resultArray[0] as String
				var objsTmp : FilmDataType <- view resultArray[1] as FilmDataType
				self.setData[keysTmp, objsTmp]
			end setData

			export operation setData[newKey: String, newObject : FilmDataType]
				keys.addupper[newKey]
				objects.addupper[newObject]
				self.print["NameServer setData: " || newKey]
			end setData

			export operation getData -> [res : Array.of[Any]]
				var resultArray : Array.of[Any] <- Array.of[Any].create[0]
				var tmp : Any <- keys[keys.upperbound]
				resultArray.addUpper[tmp]
				
				tmp  <- objects[objects.upperbound]
				resultArray.addUpper[tmp]
				res <- resultArray
			end getData

			export operation getData[key : Any] -> [res : Any]
				res <- self.lookup[(view key as String)]
			end getData


			export operation lookup[name : String] -> [obj : FilmDataType]
				for i : Integer <- 0 while i <= keys.upperbound by i <- i + 1
					if name = keys[i] then
						obj <- objects[i]
						return
					end if
				end for
				(locate self)$stdout.putstring["There is no object with the key: " || name || "\n"] 
			end lookup

			export operation print[msg : String]
				%(locate self)$stdout.putstring["\n " || msg || ":\n"]  
				%(locate self)$stdout.putstring["\n\t\tFilm data entrys in name server object " 
				%|| self.getSerial.asString  || ":\n"]  
				for i : Integer <- 0 while i <= keys.upperbound by i <- i + 1 
					%(locate self)$stdout.putstring["\nKey - "|| keys[i] || ":\n"]
					%objects[i].print[msg || "\n\n"|| i.asString ||". Key - "|| keys[i] || ":"]
				end for
			end print

			operation copyData -> [newKeys : Array.of[String], newObjects : Array.of[FilmDataType]]
				var tmpKeys : Array.of[String] <- Array.of[String].create[0]
				var tmpObjects : Array.of[FilmDataType] <- Array.of[FilmDataType].create[0]
				for i : Integer <- 0 while i <= keys.upperbound by i <- i + 1
					if keys[i] !== nil then
						tmpKeys.addUpper[keys[i]]
						tmpObjects.addUpper[objects[i]]
					end if
					
				end for
				newKeys <- tmpKeys
				newObjects <- tmpObjects
			end copyData

			export operation getInitData[newKeys : Array.of[String], newObjects : Array.of[FilmDataType]]
				(locate self)$stdout.putstring["nameServer: getInitData: "|| newKeys.upperbound.asString || "\n"]
				for i : Integer <- 0 while i <= newKeys.upperbound by i <- i + 1
					if newKeys[i] !== nil then
						keys.addUpper[newKeys[i]]
						objects.addUpper[newObjects[i]]
						(locate self)$stdout.putstring["nameServer: getInitData: Keys.upper: "|| keys[i] || "\n"]
					else
						(locate self)$stdout.putstring["nameServer: getInitData: There is no data to copy. " || "\n"]
					end if
				end for
				
			end getInitData

			process
				loop
					var i : Integer <- 1
					exit when init == true 
					begin		
						(locate self).delay[Time.create[5,0]]
						(locate self)$stdout.putstring["\nNameServer ID: "||self.getSerial.asString || "\n"]
						(locate self)$stdout.putstring["NameServer LNN: "||(locate self)$LNN.asString || "\n"]
						(locate self)$stdout.putstring["locate keys: " ||(locate keys)$LNN.asString || "\n"]
						(locate self)$stdout.putstring["locate objects: " ||(locate objects)$LNN.asString || "\n"]
						(locate self)$stdout.putstring["locate objects[0]: " ||(locate objects[0])$LNN.asString || "\n\n"]
						(locate self)$stdout.putstring["Files: " ||keys.upperbound.asString || "\n\n"]
						for j : Integer <- 0 while j <= keys.upperbound by j <- j + 1
							(locate self)$stdout.putstring["\t "|| j.asString ||". "|| keys[j] || "\n"]
						end for
					end
					i <- i + 1
				end loop
					
				unavailable
					(locate self)$stdout.putstring["nameServer: nameServer Prosess. Unavailable " || "\n"]
				end unavailable

				failure
					(locate self)$stdout.putstring["NameServer Process. Failure." ||"\n"]
				end failure
			end process			

			initially
				serialNr <- nameServerConstructor.createSerialNr
				self.print["Initial files in name server object " || self.getSerial.asString || ":\n"]
			end initially
		end nameServer
		(locate self)$stdout.putstring["nameServerConstructor: create: initKeys.upper: "||initKeys.upperbound.asString || "\n"]
		newObject.getInitData[initKeys, initObjects]
	end create

	

	export operation createSerialNr -> [newSerial : Integer]
		createdServers <- createdServers + 1
		newSerial <- createdServers
		(locate self)$stdout.putstring["Create serial. New serial: "|| newSerial.asString ||"\n"]
	end createSerialNr

end nameServerConstructor 