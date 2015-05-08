
install:
	ec types.m proxy.m abstractReplica.m primary.m ordinary.m timeServer.m nameServer.m framework.m testSuite.m
runTime:
	emx -U -R$(host) types.x proxy.x abstractReplica.x primary.x ordinary.x timeServer.x framework.x  testSuite.x
runName:
	emx -U -R$(host) types.x proxy.x abstractReplica.x primary.x ordinary.x nameServer.x framework.x  testSuite.x
clean:
	rm *.x