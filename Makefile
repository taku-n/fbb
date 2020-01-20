all: fbb.ex5

fbb.ex5: fbb.mq5
	-metaeditor64.exe /compile:fbb.mq5 /log:log.log
	cat log.log
	rm log.log
