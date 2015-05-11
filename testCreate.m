export testCreate
export test
export pType
export pConstructorType
export aType

const pConstructorType <- typeObject pConstructorType
	op create -> [res : pType]
end pConstructorType

const pType <- typeObject pType
	op ping
end pType

const aType <- object aType
	export operation x
		(locate self)$stdout.putstring["aType\n"]
	end x
end aType

const testCreate <- object testCreate
	export operation create -> [res : pConstructorType]
		res <- class pConstructor (a Type)
			export operation ping
				(locate self)$stdout.putstring["testCreate\n"]
			end ping
		end pConstructor
	end create
end testCreate

const test <- object test
	process
		(locate self)$stdout.putstring["testCreate1\n"]
		var y : aType <- testCreate.create.create
		(locate self)$stdout.putstring["testCreate2\n"]
		y.ping
		y.x
		(locate self)$stdout.putstring["testCreate3\n"]
	end process
end test