export abstractReplica

const abstractReplica <- object abstractReplica
	attached var myClone : Clonable
	export operation getData -> [newData : Any]

	end setData
end abstractReplica