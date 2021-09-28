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
    thread onConnect();

    preCacheShader( "specialty_carepackage_crate" );
    preCacheShader( "iw5_cardicon_medkit" );
    preCacheShader( "iw5_cardicon_juggernaut_a" );

    preCacheItem( "at4_mp" );
    precacheItem( "uav_strike_marker_mp" );
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
        if ( self.sessionteam == "allies" )
        {
            self giveAllPerks();
        }
        else
        {
/*
            team = self.team;
            [[game[ self.team + "_model" ][ "GHILLIE" ]]]();
            self.isSniper = true;
*/
            self giveAllPerks();
            self SetOffhandPrimaryClass( "other" );
            self giveWeapon( "bouncingbetty_mp" );
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

	foreach( perkName in perks )
	{
		if( !self _hasPerk( perkName ) )
		{
			self givePerk( perkName, false );
			if( maps\mp\gametypes\_class::isPerkUpgraded( perkName ) )
			{
				perkUpgrade = tablelookup( "mp/perktable.csv", 1, perkName, 8 );
				self givePerk( perkUpgrade, false );
			}
		}
	}
}
