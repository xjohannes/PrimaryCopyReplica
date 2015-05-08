export abstractReplica

const abstractReplica <- object abstractReplica
	attached var myClone : ClonableType

	export operation getData -> [newData : Any]

	end getData
	%%%%%%%%%%%%%%%%%% abstract operations %%%%%%%%%%%%%%%%
	export op update
	end update

	export op setData[newData : Any, upn : Integer]
	end setData
	
	export op ping
	end ping
end abstractReplica