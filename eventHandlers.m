export primaryEventHandler
export ordinaryEventHandler
%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%
const primaryEventHandler <- object primaryEventHandler
	
	export operation nodeUp[n : node, t : Time]
		(locate self)$stdout.putstring["PrimaryGeneral Node up handler:" ||"\n"]
		unavailable
			(locate self)$stdout.putstring["PrimaryGeneral nodeHandler: nodeUp . Unavailable " || "\n"]
		end unavailable
	end nodeUp

	export operation nodeDown[n : node, t : Time]
		(locate self)$stdout.putstring["PrimaryGeneral Node down handler:"  ||"\n"]

		unavailable
			(locate self)$stdout.putstring["PrimaryGeneral EventHandler: nodeDown. Unavailable " || "\n"]
			% Loop proxies, not 0, till you get one that is not down. Call ordinary.maintainReplicas.
			% creates new Primary and moves to available node. How to find an available node? Replicas 
			% and activeNodes have same index. This will not do. Loop through replicas and compare LNN
			% Make nodeEntries with replica. nodeEntries with replica <- nil is available
			% Need updateNodeEntries method. Make an array of available nodes and send it with the replicas
		end unavailable
	end nodeDown
	
end primaryEventHandler
%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%			

%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%
const ordinaryEventHandler <- object ordinaryEventHandler
	
	export operation nodeUp[n : node, t : Time]
		(locate self)$stdout.putstring["OrdinaryGeneral Node up handler:" ||"\n"]
		unavailable
			(locate self)$stdout.putstring["OrdinaryGeneral nodeHandler: nodeUp . Unavailable " || "\n"]
		end unavailable
	end nodeUp
	export operation nodeDown[n : node, t : Time]
		(locate self)$stdout.putstring["OrdinaryGeneral Node down handler:"  ||"\n"]
		unavailable
			(locate self)$stdout.putstring["OrdinaryGeneral EventHandler: nodeDown. Unavailable " || "\n"]
		end unavailable
	end nodeDown
	
end ordinaryEventHandler
%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%