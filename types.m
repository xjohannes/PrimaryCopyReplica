export FrameworkType
export NodeElementType
export ReplicaType
export EventHandlerType
export FilmDataType
export ClonableType
export ConstructorType

const FrameworkType <- typeObject frameworkType 
	op replicateMe
	op replicateMe[X : ClonableType, N : Integer] -> [proxy : ReplicaType]
end frameworkType

const ReplicaType <- typeObject replicaType
	op cloneMe -> [clone : ClonableType]
	op getId -> [replicaId : Integer]
	op getN -> [requiredReplicas : Integer]
	op getAvailableNodes -> [availableNodes : Array.of[node]]
	op addAvailableNode[newAvailableNode : Node]
	op getReplicas -> [replicas : Array.of[replicaType]]
	op killProcess
	op update
	op update[primary : replicaType]
	op setData[newData : Any]
	op setData[newData : Any, upn : Time]
	op getData -> [currentState : Any]
	op getData[key : Any] -> [res : Any]
	op copyInitData[inKeys : Array.of[String], inObjects : Array.of[FilmDataType]]
	op removeUnavailableReplica
	op maintainReplicas
	op initializeDataStructures[reps : Array.of[replicaType], an : Array.of[node]]
	op ping
	op print[msg : String]
end replicaType

const FilmDataType <- typeObject filmDataType
	op getTitle -> [title : String]
	op getActor -> [actor : String]
	op getProductionYear -> [prodYear : String]
	op print
end filmDataType

const ClonableType <- typeObject ClonableType
	op cloneMe -> [clone : ClonableType]
	op setData[newData : Any]
	op getData -> [res : Any]
	op getData[key : Any] -> [res : Any]
	op copyInitData[inKeys : Array.of[String], inObjects : Array.of[FilmDataType]] 
	op print[msg : String]
end ClonableType

const EventHandlerType <- typeObject EventHandlerType
	op nodeUp[n : node, t : Time]
	op nodeDown[n : node, t : Time]
end EventHandlerType

const ConstructorType <- typeObject ConstructorType
	op create[clonable: ClonableType, id : Integer, N : Integer, PrimaryConstructor : ConstructorType, OrdinaryConstructor : ConstructorType] -> [res : replicaType]
end ConstructorType

const NodeElementType <- typeObject nodeElementType
	op getReplica -> [rep : replicaType]
	op setReplica[replica : replicaType]
	op getNode -> [n : Node]
end nodeElementType