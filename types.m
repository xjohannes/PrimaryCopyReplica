export ReplicaType
export FrameworkType

const FrameworkType <- typeObject frameworkType 
	op replicateMe[X : ReplicaType, N : Integer]
	op notify[primary : ReplicaType]
end frameworkType

const ReplicaType <- typeObject replicaType
	op update
	op getData -> [state : Any]
	op setData[state : Any]
	op cloneMe -> [clone : replicaType]
	op isPrimary -> [res : boolean]
	op setToPrimary
	op print[msg:String]
end replicaType