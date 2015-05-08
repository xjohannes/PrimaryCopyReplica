%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%
const primaryNodeHandler <- object primaryNodeHandler
	
	export operation nodeUp[n : node, t : Time]
		(locate self)$stdout.putstring["Primary Node up handler:" ||"\n"]
		unavailable
			(locate self)$stdout.putstring["Primary nodeHandler: nodeUp . Unavailable " || "\n"]
		end unavailable
	end node
	export operation nodeDown[n : node, t : Time]
		(locate self)$stdout.putstring["Primary Node down handler:"  ||"\n"]
		unavailable
			(locate self)$stdout.putstring["Primary NodeHandler: nodeDown. Unavailable " || "\n"]
		end unavailable
	end nodeDown
	
end primaryNodeHandler
%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%			

%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%
const ordinaryNodeHandler <- object ordinaryNodeHandler
	
	export operation nodeUp[n : node, t : Time]
		(locate self)$stdout.putstring["Ordinary Node up handler:" ||"\n"]
		unavailable
			(locate self)$stdout.putstring["Ordinary nodeHandler: nodeUp . Unavailable " || "\n"]
		end unavailable
	end node
	export operation nodeDown[n : node, t : Time]
		(locate self)$stdout.putstring["Ordinary Node down handler:"  ||"\n"]
		unavailable
			(locate self)$stdout.putstring["Ordinary NodeHandler: nodeDown. Unavailable " || "\n"]
		end unavailable
	end nodeDown
	
end ordinaryNodeHandler
%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%