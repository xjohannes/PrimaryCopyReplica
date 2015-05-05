export FrameworkType
export NodeElementType
export ReplicaType

const FrameworkType <- typeObject frameworkType 
	op replicateMe[X : ReplicaType, N : Integer]
	op notify
	op getPrimary -> [primary : replicaType]
	op testMethod
end frameworkType

const NodeElementType <- typeObject nodeElementType
	op getReplica -> [rep : replicaType]
	op setReplica[replica : replicaType]
	op getNode -> [n : Node]
end nodeElementType

const ReplicaType <- typeObject replicaType
	op update[primary:replicaType]
	op getData -> [data : String]
	op setData[data : Any]
	op cloneMe -> [clone : replicaType]
	op isPrimary -> [res : boolean]
	op setToPrimary
	op print[msg : String]
	op getId -> [id : Integer]
	op insert[data : String]
	op ping
end replicaType