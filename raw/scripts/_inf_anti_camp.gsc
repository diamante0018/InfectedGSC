/*
    _inf_anti_camp
    Author: FutureRave
    Date: 27/09/2021
*/

#include common_scripts\utility;
#include maps\mp\_utility;

ANTI_CAMP_RADIUS = 350;

init()
{
	thread onConnect();
}

onConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
		player thread monitorKillStreak();
		player thread connected();
	}
}

connected()
{
	self endon( "disconnect" );
	level endon( "game_ended" );

	for ( ;; )
	{
		self waittill( "spawned_player" );

		if ( self.pers["team"] != "allies" )
		{
			self.anti_camp = false;
			return; // You can't go back to allies team because it's infect mode
		}
	}
}

startAntiCamp()
{
	assert( self.pers["team"] == "allies" );

	level endon( "game_ended" );
	self endon ( "disconnect" );

	oldPosition = self.origin;
	self iPrintLnBold( "^1Run ^:For Your Life^7!" );
	self scripts\_inf_utils::playLeaderDialog( "pushforward" );

	for ( ;; )
	{
		wait( 7.5 );

		if ( !self.anti_camp ) return;

		if ( self isUsingRemote() ) continue;

		newPosition = self.origin;

		if ( distance2D( oldPosition, newPosition ) < ANTI_CAMP_RADIUS )
		{
			dmg = 80;

			if ( self.health > 100 ) dmg = 300; // Jugg ?

			radiusDamage( newPosition, 36, dmg, dmg * 0.75, undefined, "MOD_TRIGGER_HURT" );
			self scripts\_inf_utils::playLeaderDialog( "new_positions" );
		}

		oldPosition = self.origin;
	}
}

monitorKillStreak()
{
	level endon( "game_ended" );
	self endon ( "disconnect" );

	for ( ;; )
	{
		self waittill( "killed_enemy" );
		count = self getPlayerData( "killstreaksState", "count" );

		if ( count > 24 && self.pers["team"] != "axis" )
		{
			self.anti_camp = true;
			self thread startAntiCamp();
			return;
		}
	}
}
