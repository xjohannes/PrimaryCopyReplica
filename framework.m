export framework

const framework <- object framework
	const home <- (locate self)
	var activeNodes:NodeList <- home$activeNodes
	var replicas:Array.of[replicaType] <- Array.of[replicaType].create[10]

	export operation replicateMe[X : replicaType, N : Integer]
		if home.getActiveNodes.upperbound > (N - 1) then
			(locate self)$stdout.putstring["Debug: replacateMe. " || "\n"]
			X.setToPrimary
			replicas[0] <- X
			for i : Integer <- 1 while i <= N by i <- i + 1
				replicas[i] <- X.cloneMe
				fix X at activeNodes[i]
			end for
			fix X at activeNodes[activeNodes.upperbound]
		else
			(locate self)$stdout.putstring["There has to be at least 1 more available node than replicas."]
		end if
	end replicateMe

	export operation insert[data:Any]
		replicas[0].setData[data]
	end insert
end framework

