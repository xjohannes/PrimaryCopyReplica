export FrameworkType
export NodeElementType
export ReplicaType
export MonitorType
export ClonableType

const FrameworkType <- typeObject frameworkType 
	op replicateMe[X : ReplicaType, N : Integer]
	op notify
	op getPrimary -> [primary : replicaType]
<<<<<<< HEAD
	op testMethod
=======
	op nodeDown[n : node]
>>>>>>> 6fbbe302f9d115ecd4d3a5389eeeee3f51076179
end frameworkType

const NodeElementType <- typeObject nodeElementType
	op getReplica -> [rep : replicaType]
	op setReplica[replica : replicaType]
	op getNode -> [n : Node]
end nodeElementType

const ReplicaType <- typeObject replicaType
	op update
	op update[newData : Any]
	op getUpn -> [updateNr : Integer]
	op getMyObject -> [myObject : ClonableType]
	op getData -> [data : String]
	op setData[data : Any]
	op cloneMe -> [clone : replicaType]
	op isPrimary -> [res : boolean]
	op setToPrimary[msg : String]
	op print[msg : String]
	op getId -> [id : Integer]
	op insert[data : String]
	op ping
end replicaType

const ClonableType <- typeObject ClonableType
	op cloneMe -> [clone : ClonableType]
	op update[newData : Any]
	op print[msg : String]
end ClonableType

const MonitorType <- typeObject monitorType
	op update[newData : Any, upn : Integer]
end monitorType
