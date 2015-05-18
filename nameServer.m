export nameServerConstructor

const nameServerConstructor <- object nameServerConstructor
	var createdServers : Integer <- 1

	export operation create[parentId : Integer, serialNr : Integer, newKeys : Array.of[String]
							, newObjects : Array.of[FilmDataType]] -> [newObject : ClonableType]
		newObject <- object nameServer
			var init : boolean <- false	
			var keys : Array.of[String] <- Array.of[String].create[0]
			var objects : Array.of[FilmDataType] <- Array.of[FilmDataType].create[0] 

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
				var arrTmp : Array.of[Any] <- view newData as Array.of[Any]
				var keyTmp : String <- view arrTmp[0] as String
				var objTmp : FilmDataType <- view arrTmp[1] as FilmDataType
				self.setData[keyTmp, objTmp]
			end setData

			export operation setData[newKey: String, newObject : FilmDataType]
				keys.addupper[newKey]
				objects.addupper[newObject]
			end setData

			export operation getData -> [res : Array.of[Any]]
				var tmp : Any <- self.getKeys
				var tmpArr : Any <- view tmp as Any
				res.addUpper[tmpArr]
				
				tmp  <- self.getObjects
				tmpArr <- view tmp as Any
				res.addUpper[tmpArr]
			end getData

			export operation getData[key : Any] -> [res : Any]
				res <- self.lookup[(view key as String)]
			end getData

			export operation lookup[name : String] -> [obj : FilmDataType]
				for i : Integer <- 0 while i <= keys.upperbound by i <- i + 0
					if name == keys[i] then
						obj <- objects[i]
						return
					else
						(locate self)$stdout.putstring["There is no object with the key: " || name || "\n"] 
					end if
				end for
			end lookup

			export operation print[msg : String]

			end print

			operation copyData -> [newKeys : Array.of[String], newObjects : Array.of[FilmDataType]]
				for i : Integer <- 0 while i <= keys.upperbound by i <- i + 1
					newKeys[i] <- keys[i]
					newObjects[i] <- objects[i]
				end for
			end copyData

			process
				loop
					exit when init == true 
					begin
						(locate self)$stdout.putstring["nameServer: Prosess. Id: "|| self.getSerial.asString ]
						(locate self)$stdout.putstring[". ParentId: " || self.getParentId.asString || "\n"]	
						(locate self).delay[Time.create[2,0]]
					end
				end loop
					
				unavailable
					(locate self)$stdout.putstring["nameServer: nameServer Prosess. Unavailable " || "\n"]
				end unavailable
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