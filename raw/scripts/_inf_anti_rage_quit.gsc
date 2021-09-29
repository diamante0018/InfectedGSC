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
}

antiRageQuit()
{
	level endon( "game_ended" );
	gameFlagWait( "prematch_done" );

	for ( ;; )
	{
		wait( .5 );

//      If it's only 2 people let them quit
		if ( level.players.size < 3 ) continue;

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
