import std.stdio;
import std.process;

import core.thread;

import inireader;


__gshared INIReader ini;

void main()
{
	ini = new INIReader("config.ini");

	auto tg = new ThreadGroup();
	tg.create(&HWDaemonWatchdog);
	tg.create(&IntelligenceWatchdog);

	tg.joinAll();
}


void HWDaemonWatchdog(){
	string sCmd = ini.Get!string("bin", "hwdaemon");
	writeln(sCmd);
	while(1){
		writeln("====> Start HardwareDaemon: ",sCmd);
		auto pid = spawnProcess(sCmd.split);
		wait(pid);
		writeln("XXXXX HardwareDaemon crashed");
	}
}

void IntelligenceWatchdog(){
	string sCmd = ini.Get!string("bin", "intelligence");
	while(1){
		writeln("====> Start Intelligence: ",sCmd);
		auto pid = spawnProcess(sCmd.split);
		wait(pid);
		writeln("XXXXX Intelligence crashed");
	}
}