export monitorConstructor

const monitorConstructor <- monitor class monitorObj
	attached var cl : ClonableType <- nil

	export operation setData[newData : Any]
		cl.update[newData]
	end setData
end monitorObj