export abstractReplica

const abstractReplica <- object abstractReplica
	attached var myClone : Clonable

	export operation getData -> [newData : Any]

	end setData
	%%%%%%%%%%%%%%%%%% abstract operations %%%%%%%%%%%%%%%%
	export op update
	end update

	export op setData[newData : Any, upn : Integer]
	end setData
	
	export op ping
	end ping
end abstractReplica