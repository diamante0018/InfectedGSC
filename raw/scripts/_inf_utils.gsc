/*
    _inf_utils
    Author: FutureRave
    Date: 26/09/2021
*/

#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
    replaceFunc( maps\mp\perks\_perkfunctions::GlowStickDamageListener, ::GlowStickDamageListenerStub );
    replaceFunc( maps\mp\perks\_perkfunctions::GlowStickEnemyUseListener, ::GlowStickEnemyUseListenerStub );

    create_dvar( "sv_fallDamage", 0 );
    setDvar( "scr_killcam_time", 7 );
    setDvar( "scr_killcam_posttime", 2 );

    thread gameEnded();
    thread gameStart();

    if ( getDvarInt( "sv_fallDamage" ) != 0 ) return;
    level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::codeCallbackPlayerDamage;
}

gameEnded()
{
    gameFlagWait( "prematch_done" );
    for ( ;; )
    {
        level waittill( "game_ended", team );
        foreach ( player in level.players )
        {
            player setClientDvar ( "cg_thirdperson", true );
            player setClientDvar ( "cg_thirdPersonRange", 170 );
        }
        wait( 1.5 );
        foreach ( player in level.players )
        {
            player freezecontrols( false );
        }
    }
}

// Might need to set cg_thirdperson to false when a player spawns
gameStart()
{
    gameFlagWait( "prematch_done" );
    foreach ( player in level.players )
    {
        player setClientDvar ( "cg_thirdperson", false );
    }
}

codeCallbackPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset )
{
    self endon( "disconnect" );

    if ( sMeansOfDeath == "MOD_FALLING" || self isUsingRemote() )
    {
        eAttacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "" );
        return;
    }

    [[level.prevCallbackPlayerDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset );
}

playLeaderDialog( sound )
{
    assert( self.pers["team"] != "spectator" );

    suffix = "1mc_" + sound;

    if ( self.pers["team"] == "allies" )
    {
        self playLocalSound( getTeamVoicePrefix( game["allies"] ) + suffix );
    }
    else
    {
        self playLocalSound( getTeamVoicePrefix( game["axis"] ) + suffix );
    }
}

getTeamVoicePrefix( team )
{
    return tableLookup( "mp/factionTable.csv", 0, team, 7 );
}

GlowStickDamageListenerStub( owner )
{
    self endon ( "death" );

    self setCanDamage( true );

    self.health = 999999;
    self.maxHealth = 100;
    self.damageTaken = 0;

    for ( ;; )
    {
        self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );

        if ( !maps\mp\gametypes\_weapons::friendlyFireCheck( self.owner, attacker ) )
            continue;

        if ( !isdefined( self ) )
            return;
//      Can only be damaged by knife
        if ( type == "MOD_MELEE" )
        {
            self.damageTaken += self.maxHealth;
            self.wasDamaged = true;
        }

        if( isPlayer( attacker ) )
        {
            attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "tactical_insertion" );
        }

        if ( self.damageTaken >= self.maxHealth )
        {
            if ( isDefined( owner ) && attacker != owner )
            {
                attacker notify ( "destroyed_insertion", owner );
                attacker notify( "destroyed_explosive" ); // count towards SitRep Pro challenge
                owner thread leaderDialogOnPlayer( "ti_destroyed" );
            }

            attacker thread maps\mp\perks\_perkfunctions::deleteTI( self );
        }
    }
}

GlowStickEnemyUseListenerStub( owner )
{
    self endon ( "death" );
    level endon ( "game_ended" );
    owner endon ( "disconnect" );

    self.enemyTrigger setCursorHint( "HINT_NOICON" );
    self.enemyTrigger setHintString( &"MP_DESTROY_TI" );
    self.enemyTrigger makeEnemyUsable( owner );
	
    for ( ;; )
    {
        self.enemyTrigger waittill ( "trigger", player );
        player iPrintLnBold( "Nice try" );
    }
}
