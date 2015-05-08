export primaryEventHandler
export ordinaryEventHandler
%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%
const primaryEventHandler <- object primaryEventHandler
	
	export operation nodeUp[n : node, t : Time]
		(locate self)$stdout.putstring["Primary Node up handler:" ||"\n"]
		unavailable
			(locate self)$stdout.putstring["Primary nodeHandler: nodeUp . Unavailable " || "\n"]
		end unavailable
	end nodeUp
	export operation nodeDown[n : node, t : Time]
		(locate self)$stdout.putstring["Primary Node down handler:"  ||"\n"]
		unavailable
			(locate self)$stdout.putstring["Primary EventHandler: nodeDown. Unavailable " || "\n"]
		end unavailable
	end nodeDown
	
end primaryEventHandler
%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%			

%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%
const ordinaryEventHandler <- object ordinaryEventHandler
	
	export operation nodeUp[n : node, t : Time]
		(locate self)$stdout.putstring["Ordinary Node up handler:" ||"\n"]
		unavailable
			(locate self)$stdout.putstring["Ordinary nodeHandler: nodeUp . Unavailable " || "\n"]
		end unavailable
	end nodeUp
	export operation nodeDown[n : node, t : Time]
		(locate self)$stdout.putstring["Ordinary Node down handler:"  ||"\n"]
		unavailable
			(locate self)$stdout.putstring["Ordinary EventHandler: nodeDown. Unavailable " || "\n"]
		end unavailable
	end nodeDown
	
end ordinaryEventHandler
%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%