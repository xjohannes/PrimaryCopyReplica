export FrameworkType
export NodeElementType
export ReplicaType
export EventHandlerType
export ClonableType
export ConstructorType

const FrameworkType <- typeObject frameworkType 
	op replicateMe[X : ReplicaType, N : Integer] -> [proxy : ReplicaType]
end frameworkType

const ReplicaType <- typeObject replicaType
	op getId -> [replicaId : Integer]
	op getN -> [requiredReplicas : Integer]
	op getAvailableNodes -> [availableNodes : Array.of[node]]
	op getReplicas -> [replicas : Array.of[replicaType]]

	op update
	op update[primary : replicaType]
	op setData[newData : Any, upn : Integer]
	op getData -> [currentState : Any]
	op maintainReplicas
	op ping
end replicaType

const ClonableType <- typeObject ClonableType
	op cloneMe -> [clone : ClonableType]
	op setData[newData : Any]
	op print[msg : String]
end ClonableType

const EventHandlerType <- typeObject EventHandlerType
	op nodeUp[n : node, t : Time]
	op nodeDown[n : node, t : Time]
end EventHandlerType

const ConstructorType <- typeObject ConstructorType
	op create[id : Integer, availableNodes : Array.of[Node], reps : Array.of[replicaType], N : Integer, PrimConstructor : ConstructorType] -> [res : replicaType]
end ConstructorType

const NodeElementType <- typeObject nodeElementType
	op getReplica -> [rep : replicaType]
	op setReplica[replica : replicaType]
	op getNode -> [n : Node]
end nodeElementType