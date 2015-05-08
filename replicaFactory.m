export ReplicaFactory

const ReplicaFactory <- object replicaFactory 
	
	export operation createPrimary
		return class primary (abstractReplica) 
			var replicaFactory : replicaFactoryType
			%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%
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
			%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%
			export operation update
				(locate self)$stdout.putstring["Primary update."]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end update

			export operation setData[newData : Any, upn : Integer]
				(locate self)$stdout.putstring["Primary setData."]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end setData
	
			export operation ping
				(locate self)$stdout.putstring["Primary ping."]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end ping		

			process
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end process

			initially
				(locate self).setNodeEventHandler[nodeDownHandler]
				unavailable
					(locate self)$stdout.putstring["Primary update. Unavailable"]
				end unavailable
			end initially
		end primary
	end createPrimary

	export operation createOrdinary
		return class ordinary (abstractReplica) 
			var replicaFactory : replicaFactoryType
			%%%%%%%%%%%%%%%%% inner class %%%%%%%%%%%%%%
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
			%%%%%%%%%%%%%%%%% end inner class %%%%%%%%%%
			export operation update
				(locate self)$stdout.putstring["Ordinary update."]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end update

			export operation setData[newData : Any, upn : Integer]
				(locate self)$stdout.putstring["Ordinary setData."]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end setData
	
			export operation ping
				(locate self)$stdout.putstring["Ordinary ping."]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end ping		

			process
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end process

			initially
				(locate self).setNodeEventHandler[nodeDownHandler]
				unavailable
					(locate self)$stdout.putstring["Ordinary update. Unavailable"]
				end unavailable
			end initially
		end ordinary
	end createOrdinary


	
end replicaFactory