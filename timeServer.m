export timeServer

const timeServer <- object timeServer
	operation update
	end update

	operation getState -> [state:Any]
		state <- nil
	end getState
	operation setState[state:Any]
	end setState
	operation cloneMe
	end cloneMe
end timeServer 