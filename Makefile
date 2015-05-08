
install:
	ec types.m proxy.m abstractReplica.m replicaFactory.m  timeServer.m nameServer.m framework.m testSuite.m
runTime:
	emx -U -R$(host) types.x proxy.x abstractReplica.x  replicaFactory.x timeServer.x framework.x  testSuite.x
runName:
	emx -U -R$(host) types.x proxy.x abstractReplica.x replicaFactory.x nameServer.x framework.x  testSuite.x
clean:
	rm *.x