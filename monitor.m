export monitorConstructor

const monitorConstructor <- monitor class monitorObj[clonable : ClonableType]
	var cl : ClonableType <- clonable
	%var rp : ReplicaType <- replica
	attached var updateNumber : Integer <- 0

	export operation update[newData : Any, upn : Integer]
		if upn > self.getUpn then 
			cl.update[newData]
			self.countUpn
		end if 
	end update

	operation getUpn -> [upn : Integer]

	end getUpn

	operation countUpn
		updateNumber <- updateNumber + 1
	end countUpn
end monitorObj