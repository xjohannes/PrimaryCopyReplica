export FrameworkType
export NodeElementType
export ReplicaType
export MonitorType
export ClonableType

const FrameworkType <- typeObject frameworkType 
	op replicateMe[X : ReplicaType, N : Integer] -> [proxy : ProxyType]
end frameworkType

const ReplicaType <- typeObject replicaType
	op update
	op setData[newData : Any, upn : Integer]
	op getState -> [currentState : Any]
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

const NodeElementType <- typeObject nodeElementType
	op getReplica -> [rep : replicaType]
	op setReplica[replica : replicaType]
	op getNode -> [n : Node]
end nodeElementType