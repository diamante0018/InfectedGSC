/*
    _inf_model
    Author: FutureRave
    Date: 27/09/2021
    Notes: Fuck the models for now
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

		if ( self.pers["team"] == "allies" )
		{
			self giveAllPerks();
		}
		else
		{
			self giveAllPerks();
			self setOffhandSecondaryClass( "smoke" );
			self giveWeapon( "bouncingbetty_mp" );
			self giveWeapon( "smoke_grenade_mp" );
			self setWeaponAmmoClip( "smoke_grenade_mp", 1 );
		}
	}
}

giveAllPerks()
{
	perks = [];
	perks[ perks.size ] = "specialty_longersprint";
	perks[ perks.size ] = "specialty_fastreload";
	perks[ perks.size ] = "specialty_scavenger";
	perks[ perks.size ] = "specialty_blindeye";
	perks[ perks.size ] = "specialty_paint";
	perks[ perks.size ] = "specialty_hardline";
	perks[ perks.size ] = "specialty_coldblooded";
	perks[ perks.size ] = "specialty_quickdraw";

	perks[ perks.size ] = "_specialty_blastshield";
	perks[ perks.size ] = "specialty_detectexplosive";
	perks[ perks.size ] = "specialty_autospot";
	perks[ perks.size ] = "specialty_bulletaccuracy";

	perks[ perks.size ] = "specialty_quieter";
	perks[ perks.size ] = "specialty_stalker";

	perks[ perks.size ] = "specialty_bulletpenetration";
	perks[ perks.size ] = "specialty_marksman";
	perks[ perks.size ] = "specialty_sharp_focus";
	perks[ perks.size ] = "specialty_holdbreathwhileads";
	perks[ perks.size ] = "specialty_longerrange";
	perks[ perks.size ] = "specialty_fastermelee";
	perks[ perks.size ] = "specialty_reducedsway";
	perks[ perks.size ] = "specialty_lightweight";

	foreach ( perkName in perks )
	{
		if ( !self _hasPerk( perkName ) )
		{
			self givePerk( perkName, false );

			if ( maps\mp\gametypes\_class::isPerkUpgraded( perkName ) )
			{
				perkUpgrade = tablelookup( "mp/perktable.csv", 1, perkName, 8 );
				self givePerk( perkUpgrade, false );
			}
		}
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
