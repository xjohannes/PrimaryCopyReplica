export timeServerConstructor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Types etc %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

const agentType <- typeobject agentType
  
end agentType

const BarrierMonitorType <- typeobject BarrierMonitorType
  operation registerTime[t:Time]
  operation done
  operation waitForAgents
  operation setTotalAgents[i:integer]
end BarrierMonitorType

%%%%%%%%%%%%%%%%%%%%%% end types %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



const timeServerConstructor <- object timeServerConstructor

  var createdServers : Integer <- 0

  export operation create -> [newObject : ClonableType]
    newObject <- object timeServer
      var nrOfNodes: Integer
      var allNodes:NodeList 
      var there:Array.of[Node]
      var meanTime : Integer
      attached var serialNr : Integer
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Inner Agent def %%%%%%%%%%%%%%%%%%%%%%%%%%%%

const AgentConstr <- class Agent[nodes:NodeList, agentId:Integer,BMMonitor:BarrierMonitorType]
    attached var nrOfNodesToVisit:Integer
    attached var localTime: Time 
    attached var currentNode: Node
    
    process
      for i:Integer <- 1 while i<= nrOfNodesToVisit by i <- i + 1 
        currentNode <- nodes[i]$theNode
        move self to currentNode 
        
        if nodes[i-1]$theNode !== (locate self) then 
          localTime <- currentNode$timeOfDay
          %(locate self)$stdout.putstring["Agent: "||serialNr.asString||"." || agentId.asString || ". I have moved. Local time is: " || localTime.asString || "\n"]
          BMMonitor.registerTime[localTime] 
        end if
      end for 
      
      BMMonitor.done
      (locate self)$stdout.putstring["Agent " || agentId.asString || " is done. Message from agent.\n"]
    end process

    initially
      nrOfNodesToVisit <- nodes.upperbound
    end initially
  end Agent

  %%%%%% An instance of this class is to be moved to every node before the agents
  
  

%%%%%%%%%%%%%%%%%%%%%% End Agent def %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% Inner Barrier def %%%%%%%%%%%%%%%%%%%%%%%%%%

  const BarrierMonitor <- monitor object BarrierMonitor
    var agentsReturnQueue:Condition <- Condition.create
    var waitingForAgentsQueue:Condition <- Condition.create
    var totalTime:Time <- Time.create[0,0]
    var agentsFinished : Integer <- 0
    var nrOfAgents: Integer 

    export operation registerTime[t:Time]
      totalTime <- totalTime + t
    end registerTime

    export operation done 
      agentsFinished <- agentsFinished + 1
      if nrOfAgents > agentsFinished then
        wait agentsReturnQueue
      end if

      signal waitingForAgentsQueue
    end done

    export operation waitForAgents
      if agentsFinished < nrOfNodes then
        (locate self)$stdout.putstring["TimeServer nr: "||serialNr.asString||" is waiting for agents\n"]
       wait waitingForAgentsQueue
      end if
      signal agentsReturnQueue
    end waitForAgents

    export operation getTotalTime -> [res: Time]
      res <- totalTime
    end getTotalTime

    export operation setTotalAgents [nr:Integer]
      nrOfAgents <- nr
    end setTotalAgents

  end BarrierMonitor

%%%%%%%%%%%%%%%%%%%%%% End Barrier def %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    export operation getMeanTime -> [state : Any]
      state <- meanTime
    end getMeanTime
    
    export operation cloneMe -> [clone : ClonableType]
      clone <- timeServerConstructor.create
      clone.setData[self.getData]
    end cloneMe
    
    export operation setData[newData : Any]
      meanTime <- view newData as Integer
    end setData
    
    export operation getData -> [res : Any]
      res <- view self.getMeanTime as any
    end getData
    
    export operation getData[key : Any] -> [res : Any] 
    end getData
    
    export operation print[msg : String]
      (locate self)$stdout.putstring["Id: " || self.getSerial.asString||"Mean time" || "\n"]
    end print
    export operation getInitData[newKeys : Array.of[String], newObjects : Array.of[FilmDataType]]
    end getInitData

    operation getSerial -> [res : Integer]
      res <- serialNr
    end getSerial

    process  
      %if (locate self)$activeNodes.upperbound > 1 then 
        loop
          exit when false
          begin
            (locate self)$stdout.putstring["TimeServer process: "|| self.getSerial.asString ||"\n"]
            (locate self)$stdout.putstring["nrOfNodes: "|| nrOfNodes.asString ||"\n"]
            (locate self)$stdout.putstring["Active nodes: "|| (locate self)$activeNodes.upperbound.asString ||"\n"]
            if nrOfNodes !== (locate self)$activeNodes.upperbound then 
              nrOfNodes <- (locate self)$activeNodes.upperbound
              (locate self)$stdout.putstring["Sending out " || (locate self)$activeNodes.upperbound.asString || " agents: \n"]
              for i : Integer <- 1 while i <= nrOfNodes by i <- i + 1
                var temp:agentType <- AgentConstr.create[(locate self)$activeNodes, i, BarrierMonitor]
              end for
              BarrierMonitor.waitForAgents 
              meanTime <-  (BarrierMonitor.getTotalTime.getMicroSeconds/nrOfNodes)
              (locate self)$stdout.putstring["TimeServer nr: "||serialNr.asString||". All agents have returned. "
              ||"\n\tThe synchronized timestamp is: " 
                ||(BarrierMonitor.getTotalTime.getMicroSeconds/nrOfNodes).asString || "\n"]
            end if
            (locate self).delay[Time.create[2, 0]]
          end
        end loop
        
      %end if
    end process

    initially
      serialNr <- timeServerConstructor.createSerialNr
      there <- Array.of[Node].create[0]
      allNodes <- (locate self)$activeNodes
      nrOfNodes <- allNodes.upperbound
      BarrierMonitor.setTotalAgents [nrOfNodes]
      for j: Integer <- 1 while j <= allNodes.upperbound by j <- j +1
        there.addUpper[allNodes[j]$theNode] 
      end for

    end initially
    end timeServer
  end create

  export operation createSerialNr -> [newSerial : Integer]
    createdServers <- createdServers + 1
    newSerial <- createdServers
    (locate self)$stdout.putstring["Create serial. New serial: "|| newSerial.asString ||"\n"]
  end createSerialNr
end timeServerConstructor

