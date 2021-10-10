/*
    _inf_model
    Author: FutureRave
    Date: 27/09/2021
*/

#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	replaceFunc(  maps\mp\gametypes\_teams::playerModelForWeapon, ::playerModelForWeaponStub );

	thread onConnect();

	preCacheShader( "specialty_carepackage_crate" );
	preCacheShader( "iw5_cardicon_medkit" );
	preCacheShader( "iw5_cardicon_juggernaut_a" );

	preCacheItem( "at4_mp" );
	preCacheItem( "uav_strike_marker_mp" );
}

onConnect()
{
	for ( ;; )
	{
		level waittill( "connected", player );
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
		waittillframeend;

		if ( self.pers["team"] != "axis" ) continue;

		self setOffhandSecondaryClass( "smoke" );
		self _giveWeapon( "bouncingbetty_mp" );
		self _giveWeapon( "smoke_grenade_mp" );
		self setWeaponAmmoClip( "smoke_grenade_mp", 1 );
	}
}

playerModelForWeaponStub( weapon, secondary )
{
	team = self.team;

	if ( isDefined( game[ team + "_model" ][weapon] ) )
	{
		[[game[ team + "_model" ][weapon]]]();
		return;
	}

	if ( self.pers["team"] == "axis" ) // Hack for infected players
	{
		if ( level.environment != "" && self isItemUnlocked( "ghillie_" + level.environment ) )
			[[game[ team + "_model" ]["GHILLIE"]]]();
		else
			[[game[ team + "_model" ]["SNIPER"]]]();

		return;
	}

	weaponClass = tablelookup( "mp/statstable.csv", 4, weapon, 2 );

	switch ( weaponClass )
	{
		case "weapon_smg":
			[[game[ team + "_model" ]["SMG"]]]();
			break;

		case "weapon_assault":
			[[game[ team + "_model" ]["ASSAULT"]]]();
			break;

		case "weapon_sniper":

			if ( level.environment != "" && self isItemUnlocked( "ghillie_" + level.environment ) )
				[[game[ team + "_model" ]["GHILLIE"]]]();
			else
				[[game[ team + "_model" ]["SNIPER"]]]();

			break;

		case "weapon_lmg":
			[[game[ team + "_model" ]["LMG"]]]();
			break;

		case "weapon_riot":
			[[game[ team + "_model" ]["RIOT"]]]();
			break;

		case "weapon_shotgun":
			[[game[ team + "_model" ]["SHOTGUN"]]]();
			break;

		default:
			[[game[team + "_model"]["ASSAULT"]]]();
			break;
	}

	if ( self isJuggernaut() )
	{
		[[game[ team + "_model" ]["JUGGERNAUT"]]]();
	}
}
