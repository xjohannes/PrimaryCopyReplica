
install:
	ec types.m proxy.m replicaFactory.m  timeServer.m nameServer.m framework.m testSuite.m
runTime:
	emx -U -R$(host) types.x proxy.x  replicaFactory.x timeServer.x framework.x  testSuite.x
runName:
	emx -U -R$(host) types.x proxy.x replicaFactory.x nameServer.x framework.x  testSuite.x
clean:
	rm *.x