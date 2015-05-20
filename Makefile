
install:
	ec types.m eventHandlers.m primaryReplica.m ordinaryReplica.m filmDataObject.m timeServer.m nameServer.m framework.m timeServerTestSuite.m nameServerTestSuite.m
runTime:
	emx -U -R$(host) types.x eventHandlers.x  primaryReplica.x ordinaryReplica.x timeServer.x framework.x timeServerTestSuite.x
runName:
	emx -U -R$(host) types.x eventHandlers.x primaryReplica.x ordinaryReplica.x filmDataObject.x nameServer.x framework.x nameServerTestSuite.x
clean:
	rm *.x