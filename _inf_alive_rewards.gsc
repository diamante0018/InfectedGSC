/*
	_inf_alive_rewards
	Author: FutureRave
	Date: 28/09/2021
*/

#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	replaceFunc(  maps\mp\killstreaks\_juggernaut::giveJuggernaut, ::giveJuggernautStub );

	maps\mp\killstreaks\_airdrop::addCrateType( "nuke_drop", "nuke", 1, maps\mp\killstreaks\_airdrop::nukeCrateThink );
	maps\mp\killstreaks\_airdrop::addCrateType( "airdrop", "ammo", 17, ::ammoCrateThink );
	maps\mp\killstreaks\_airdrop::addCrateType( "airdrop_mega", "ammo", 12, ::ammoCrateThink );

	thread onConnect();
}

onConnect()
{
    for ( ;; )
    {
        level waittill( "connected", player );
        player thread monitorForRewards();
    }
}

monitorForRewards()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    for ( ;; )
    {
        self waittill( "killed_enemy" );
        if ( self.sessionteam == "axis" ) return; // It's infected. Once your team is axis you are done for the game
        count = self.kills;
        switch( count )
        {
		case 1:
			self scripts\_inf_utils::playLeaderDialog( "kill_confirmed" );
			level thread dropAmmo( self );
			break;
		case 5:
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "deployable_vest" );
			break;
		case 9:
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "predator_missile" );
			break;
		case 18:
			level thread maps\mp\killstreaks\_airdrop::doMegaC130FlyBy( self, self.origin, randomFloat( 360 ), "airdrop_grnd", -360 );
			break;
		case 25:
			self maps\mp\killstreaks\_juggernaut::giveJuggernaut( "juggernaut" );
			break;
		case 45:
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "ac130" );
			break;
		case 85:
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "helicopter_flares" );
			break;
		case 100:
			self maps\mp\killstreaks\_killstreaks::giveKillstreak( "osprey_gunner" );
			break;
		case 120:
			level thread maps\mp\killstreaks\_airdrop::dropNuke( self.origin, self, "nuke_drop" );
			break;
		}
    }
}

dropAmmo( owner )
{
    planeHalfDistance = 24000;
    planeFlySpeed = 2000;
    yaw = RandomInt( 360 );

    yaw = RandomInt( 360 );
    direction = ( 0, yaw, 0 );

    dropSite = owner.origin;
    lbheight = level maps\mp\killstreaks\_airdrop::getFlyHeightOffset( dropSite );

    startPos = dropSite + ( AnglesToForward( direction ) * ( -1 * planeHalfDistance ) );
    startPos = startPos * ( 1, 1, 0 ) + ( 0, 0, lbHeight );

	endPos = dropSite + ( AnglesToForward( direction ) * planeHalfDistance );
	endPos = endPos * ( 1, 1, 0 ) + ( 0, 0, lbHeight );

    d = length( startPos - endPos );
    flyTime = ( d / planeFlySpeed );
	
	c130 = maps\mp\killstreaks\_airdrop::c130Setup( owner, startPos, endPos );
	c130.veh_speed = planeFlySpeed;
	c130.dropType = "airdrop";
	c130 playloopsound( "veh_ac130_dist_loop" );

	c130.angles = direction;
	forward = anglesToForward( direction );
	c130 moveTo( endPos, flyTime, 0, 0 ); 

	boomPlayed = false;
	minDist = distance2D( c130.origin, dropSite );
	for ( ;; )
	{
		dist = distance2D( c130.origin, dropSite );

		if ( dist < minDist )
			minDist = dist;
		else if ( dist > minDist )
			break;
		
		if ( dist < 256 )
		{
			break;
		}
		else if ( dist < 768 )
		{
			earthquake( 0.15, 1.5, dropSite, 1500 );
			if ( !boomPlayed )
			{
				c130 playSound( "veh_ac130_sonic_boom" );
				boomPlayed = true;
			}
		}	

		wait( .05 );	
	}	
	
	c130 thread maps\mp\killstreaks\_airdrop::dropTheCrate( dropSite, "airdrop", lbHeight, false, "ammo", startPos );
	wait( 0.05 );
	c130 notify ( "drop_crate" );

	wait( 4 );
	c130 delete();
}

ammoCrateThink( dropType )
{	
	self endon ( "death" );
	self.usedBy = [];
	
	if ( dropType == "airdrop" || !level.teamBased )
		maps\mp\killstreaks\_airdrop::crateSetupForUse( game["strings"]["ammo_hint"], "all", "waypoint_ammo_friendly" );
	else
		maps\mp\killstreaks\_airdrop::crateSetupForUse( game["strings"]["ammo_hint"], "all", "waypoint_ammo_friendly" );

	self thread maps\mp\killstreaks\_airdrop::crateOtherCaptureThink();
	self thread maps\mp\killstreaks\_airdrop::crateOwnerCaptureThink();

	for ( ;; )
	{
		self waittill ( "captured", player );
		
		if ( isDefined( self.owner ) && player != self.owner )
		{
			if ( !level.teamBased || player.team != self.team )
			{
				if ( dropType == "airdrop" )
					player thread maps\mp\killstreaks\_airdrop::hijackNotify( self, "airdrop" );
				else
					player thread maps\mp\killstreaks\_airdrop::hijackNotify( self, "emergency_airdrop" );
			}
		}		
		
		player maps\mp\killstreaks\_teamammorefill::refillAmmo( true );
		self maps\mp\killstreaks\_airdrop::deleteCrate();
	}
}

giveJuggernautStub( juggType )
{
	self endon( "death" );
	self endon( "disconnect" );
	wait( .05 );

	if ( isDefined( self.hasLightArmor ) && self.hasLightArmor == true )
		maps\mp\perks\_perkfunctions::removeLightArmor( self.previousMaxHealth );

	switch( juggType )
	{
	case "juggernaut":
		self.isJuggernaut = true;
		self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], juggType, false, false );
		break;
	case "juggernaut_recon":
		self.isJuggernautRecon = true;
		self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], juggType, false, false );

		portable_radar = spawn( "script_model", self.origin );
		portable_radar.team = self.team;

		portable_radar makePortableRadar( self );
		self.personalRadar = portable_radar;

		self thread maps\mp\killstreaks\_juggernaut::radarMover( portable_radar );
		break;
	}

	if ( !getDvarInt( "camera_thirdPerson" ) )
	{
		self.juggernautOverlay = newClientHudElem( self );
		self.juggernautOverlay.x = 0;
		self.juggernautOverlay.y = 0;
		self.juggernautOverlay.alignX = "left";
		self.juggernautOverlay.alignY = "top";
		self.juggernautOverlay.horzAlign = "fullscreen";
		self.juggernautOverlay.vertAlign = "fullscreen";
		self.juggernautOverlay SetShader( level.juggSettings[ juggType ].overlay, 640, 480 );
		self.juggernautOverlay.sort = -10;
		self.juggernautOverlay.archived = true;
		self.juggernautOverlay.hidein3rdperson = true;
	}

	self thread maps\mp\killstreaks\_juggernaut::juggernautSounds();
	self setPerk( "specialty_radarjuggernaut", true, false );

	self thread teamPlayerCardSplash( level.juggSettings[ juggType ].splashUsedName, self );	
	self PlaySoundToTeam( game[ "voice" ][ self.team ] + "use_juggernaut", self.team, self );
	self PlaySoundToTeam( game[ "voice" ][ level.otherTeam[ self.team ] ] + "enemy_juggernaut", level.otherTeam[ self.team ] );

	self thread maps\mp\killstreaks\_killstreaks::updateKillstreaks( true );

	self thread maps\mp\killstreaks\_juggernaut::juggRemover();

	if ( isDefined( self.carryFlag ) )
	{
		wait( 0.05 );
		self attach( self.carryFlag, "J_spine4", true );
	}

	level notify( "juggernaut_equipped", self );
	self maps\mp\_matchdata::logKillstreakEvent( "juggernaut", self.origin );
}
