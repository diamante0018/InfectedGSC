/*
	_inf_anti_rage_quit
	Author: FutureRave
	Date: 29/09/2021
*/

#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	thread antiRageQuit();
	thread onPlayerConnect();
}

antiRageQuit()
{
	level endon( "game_ended" );
	gameFlagWait( "prematch_done" );

	for ( ;; )
	{
		wait( .5 );

		if ( level.players.size < 3 ) continue; // If it's only 2 people let them quit

		foreach ( player in level.players )
		{
			if ( player.pers["team"] == "axis" )
			{
				player closepopupmenu( "" );
				player closeingamemenu();
			}
		}
	}
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		player thread onPlayerDisconnect();
	}
}

onPlayerDisconnect()
{
	self waittill( "disconnect" );
	text = self.name + " ^1Left the server";
	iPrintLn( text );
}
