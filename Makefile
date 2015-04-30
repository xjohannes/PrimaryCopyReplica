
install:
	ec types.m   timeServer.m  nameServer.m  framework.m testSuite.m
runTime:
	emx -U -R$(host) types.x framework.x timeServer.x  testSuite.x
runName:
	emx -U -R$(host) types.x framework.x nameServer.x  testSuite.x
clean:
	rm *.x