export nameServerConstructor

const nameServerConstructor <- object nameServerConstructor
	var createdServers : Integer <- 1

	export operation create[parentId : Integer, serialNr : Integer, newKeys : Array.of[String]
							, newObjects : Array.of[FilmDataType]] -> [newObject : ClonableType]
		newObject <- object nameServer
			var init : boolean <- false	
			var keys : Array.of[String] <- Array.of[String].create[0]
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
				clone <- nameServerConstructor.create[parentId, nameServerConstructor.createSerialNr, newKeys, newObjects]
			end cloneMe

			export operation setData[newData : Any]
				(locate self)$stdout.putstring["Debug. NameServer getData[1] 1." ||"\n"]
				var arrTmp : Array.of[Any] <- view newData as Array.of[Any]
				(locate self)$stdout.putstring["Debug. NameServer getData[1] 1." ||"\n"]
				var keyTmp : String <- view arrTmp[0] as String
				(locate self)$stdout.putstring["Debug. NameServer getData[1] 1." ||"\n"]
				var objTmp : FilmDataType <- view arrTmp[1] as FilmDataType
				(locate self)$stdout.putstring["Debug. NameServer getData[1] 1." ||"\n"]
				self.setData[keyTmp, objTmp]
			end setData

			export operation setData[newKey: String, newObject : FilmDataType]
				keys.addupper[newKey]
				objects.addupper[newObject]
				self.print["setData"]
			end setData

			export operation getData -> [res : Array.of[Any]]
				var resultArray : Array.of[Any] <- Array.of[Any].create[0]
				var tmp : Any <- self.getKeys
				var tmpArr : Any <- view tmp as Any
				resultArray.addUpper[tmpArr]
				
				tmp  <- self.getObjects
				tmpArr <- view tmp as Any
				resultArray.addUpper[tmpArr]
				res <- resultArray
			end getData

			export operation getData[key : Any] -> [res : Any]
				res <- self.lookup[(view key as String)]
			end getData

			export operation lookup[name : String] -> [obj : FilmDataType]
				for i : Integer <- 0 while i <= keys.upperbound by i <- i + 1
					if name == keys[i] then
						obj <- objects[i]
						return
					else
						(locate self)$stdout.putstring["There is no object with the key: " || name || "\n"] 
					end if
				end for
			end lookup

			export operation print[msg : String]
				%(locate self)$stdout.putstring["PrintMsg: " || msg || "\n"] 
				for i : Integer <- 0 while i <= keys.upperbound by i <- i + 1
					(locate self)$stdout.putstring["Key: "|| keys[i] || "\n"]
					objects[i].print
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

			process
				loop
					exit when init == true 
					begin
						%(locate self)$stdout.putstring["nameServer: Prosess. Id: "|| self.getSerial.asString ||"\n"]
						self.print[""]
						%(locate self)$stdout.putstring["Parent Id: " || self.getParentId.asString || "\n"]	
						(locate self)$stdout.putstring[" ---\n"]	
						(locate self).delay[Time.create[5,0]]
					end
				end loop
					
				unavailable
					(locate self)$stdout.putstring["nameServer: nameServer Prosess. Unavailable " || "\n"]
				end unavailable

				failure
					(locate self)$stdout.putstring["NameServer Process. Failure." ||"\n"]
				end failure
			end process			

			initially
						
			end initially
		end nameServer
	end create

	export operation createSerialNr -> [newSerial : Integer]
		createdServers <- createdServers + 1
		newSerial <- createdServers
	end createSerialNr

end nameServerConstructor 