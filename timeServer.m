

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Prog Env %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
const env <- object ENVIRONMENT
  const home <- (locate self)
  var nrOfNodes: Integer
  var allNodes:NodeList 
  var there:Array.of[Node]
  var meanTime : Integer
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Object def %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
          currentNode$stdout.putstring["Agent: " || agentId.asString || ". I have moved. Local time is: " || localTime.asString || "\n"]
          BMMonitor.registerTime[localTime] 
        end if
      end for 
      
      BMMonitor.done
      currentNode$stdout.putstring["Agent " || agentId.asString || " is done. Message from agent.\n"]
    end process

    initially
      nrOfNodesToVisit <- nodes.upperbound
    end initially
  end Agent

  %%%%%% An instance of this class is to be moved to every node before the agents
  
  

%%%%%%%%%%%%%%%%%%%%%% End Object def %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

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
        stdout.putstring["Main process is waiting for agents\n"]
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

  export operation getState -> [state : Any]
    state <- meanTime
  end getState

  export operation setState[newState : Any]
    meanTime <- view newState as Integer
  end setState

  export operation cloneMe -> [res : ClonableType]
    % Remember to clone State as well
  end cloneMe

    process
      stdout.putstring["Sending out " || nrOfNodes.asString || " agents: \n"]
    
      for i : Integer <- 1 while i <= nrOfNodes by i <- i + 1
        var temp:agentType <- AgentConstr.create[allNodes, i, BarrierMonitor]
      end for
      
      BarrierMonitor.waitForAgents 
      meanTime <-  (BarrierMonitor.getTotalTime.getMicroSeconds/nrOfNodes)
      stdout.putstring["All agents have returned. The synchronized timestamp is: " ||   (BarrierMonitor.getTotalTime.getMicroSeconds/nrOfNodes).asString || "\n"]
    end process

    initially
      there <- Array.of[Node].create[0]
      allNodes <- home$activeNodes
      nrOfNodes <- allNodes.upperbound
      BarrierMonitor.setTotalAgents [nrOfNodes]
      for j: Integer <- 1 while j <= allNodes.upperbound by j <- j +1
        there.addUpper[allNodes[j]$theNode] 
      end for

    end initially
end ENVIRONMENT

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Types etc %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
const agentType <- typeobject agentType
  
end agentType

const BarrierMonitorType <- typeobject BarrierMonitorType
  operation registerTime[t:Time]
  operation done
  operation waitForAgents
  operation setTotalAgents[i:integer]
end BarrierMonitorType