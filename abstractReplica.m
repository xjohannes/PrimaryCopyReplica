export abstractReplica

const abstractReplica <- object abstractReplica
	attached var myClone : ClonableType
	%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%
	const nodeUpAndDownHandler <- object nodeUpAndDownHandler
		
		export operation nodeUp[n : node, t : Time]
			(locate self)$stdout.putstring["Node up handler:" ||"\n"]
			unavailable
				(locate self)$stdout.putstring["nodeHandler: nodeUp . Unavailable " || "\n"]
			end unavailable
		end nodeUp

		export operation nodeDown[n : node, t : Time]
			(locate self)$stdout.putstring["Node down handler:"  ||"\n"]
			unavailable
				(locate self)$stdout.putstring["NodeHandler: nodeDown. Unavailable " || "\n"]
			end unavailable
		end nodeDown
		
	end nodeUpAndDownHandler
	%%%%%%%%%%%%%%%%% end inner class %%%%%%%

	export operation getData -> [newData : Any]
		(locate self)$stdout.putstring["abstractReplica getData."]
		unavailable
			(locate self)$stdout.putstring["abstractReplica getData. Unavailable"]
		end unavailable
	end getData
	%%%%%%%%%%%%%%%%%% abstract operations %%%%%%%%%%%%%%%%
	export op update
	end update

	export op setData[newData : Any, upn : Integer]
	end setData
	
	export op ping
	end ping


end abstractReplica