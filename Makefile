
install:
	ec types.m monitor.m timeServer.m replica.m nameServer.m framework.m testSuite.m
runTime:
	emx -U -R$(host) types.x framework.x monitor.x replica.x timeServer.x testSuite.x
runName:
	emx -U -R$(host) types.x framework.x  monitor.x replica.x nameServer.x testSuite.x
clean:
	rm *.x