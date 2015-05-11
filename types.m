export FrameworkType
export NodeElementType
export ReplicaType
export MonitorType
export ClonableType
export ReplicaFactoryType

const FrameworkType <- typeObject frameworkType 
	op replicateMe[X : ReplicaType, N : Integer] -> [proxy : ReplicaType]
end frameworkType

const ReplicaType <- typeObject replicaType
	op update
	op setData[newData : Any, upn : Integer]
	op getData -> [currentState : Any]
	op ping
end replicaType

const ClonableType <- typeObject ClonableType
	op cloneMe -> [clone : ClonableType]
	op setData[newData : Any]
	op print[msg : String]
end ClonableType

const MonitorType <- typeObject monitorType
	op update[newData : Any, upn : Integer]
end monitorType

const ReplicaFactoryType <- typeObject replicaFactoryType
	op createPrimary[availableNodes : Array.of[node]] -> [primary : replicaType] 
	op createOrdinary[availableNodes : Array.of[node]] -> [ordinary : replicaType]
end replicaFactoryType

const NodeElementType <- typeObject nodeElementType
	op getReplica -> [rep : replicaType]
	op setReplica[replica : replicaType]
	op getNode -> [n : Node]
end nodeElementType