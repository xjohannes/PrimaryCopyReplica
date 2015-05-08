
install:
	ec types.m timeServer.m replica.m nameServer.m frameworkAPI.m testSuite.m
runTime:
	emx -U -R$(host) types.x frameworkAPI.x replica.x timeServer.x  testSuite.x
runName:
	emx -U -R$(host) types.x frameworkAPI.x replica.x nameServer.x  testSuite.x
clean:
	rm *.x