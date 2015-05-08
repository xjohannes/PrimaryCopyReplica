
install:
	ec types.m proxy.m primary.m ordinary.m timeServer.m nameServer.m framework.m testSuite.m
runTime:
	emx -U -R$(host) types.x frameworkAPI.x replica.x timeServer.x  testSuite.x
runName:
	emx -U -R$(host) types.x frameworkAPI.x replica.x nameServer.x  testSuite.x
clean:
	rm *.x