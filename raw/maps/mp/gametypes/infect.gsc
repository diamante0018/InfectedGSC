/*
	infect
	Author: FutureRave
	Date: 10/10/2021
	Notes: Removed prematch, console related things and added dm (FFA)
	spawn points
*/

main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	if ( isusingmatchrulesdata() )
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[ level.initializeMatchRules ]]();
		level thread maps\mp\_utility::reInitializeMatchRulesOnMigration();
	}
	else
	{
		maps\mp\_utility::registerTimeLimitDvar( level.gameType, 10 );
		maps\mp\_utility::setOverrideWatchDvar( "scorelimit", 0 );
		maps\mp\_utility::registerRoundLimitDvar( level.gameType, 1 );
		maps\mp\_utility::registerWinLimitDvar( level.gameType, 1 );
		maps\mp\_utility::registerNumLivesDvar( level.gameType, 0 );
		maps\mp\_utility::registerHalfTimeDvar( level.gameType, 0 );
		level.matchRules_numInitialInfected = 1;
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}

	setSpecialLoadouts();
	level.teamBased = 1;
	level.doPrematch = 0;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onDeadEvent = ::onDeadEvent;
	level.onTimeLimit = ::onTimeLimit;
	level.infect_perks = [];
	level.infect_perks[level.infect_perks.size] = "specialty_longersprint";
	level.infect_perks[level.infect_perks.size] = "specialty_fastreload";
	level.infect_perks[level.infect_perks.size] = "specialty_scavenger";
	level.infect_perks[level.infect_perks.size] = "specialty_blindeye";
	level.infect_perks[level.infect_perks.size] = "specialty_paint";
	level.infect_perks[level.infect_perks.size] = "specialty_hardline";
	level.infect_perks[level.infect_perks.size] = "specialty_coldblooded";
	level.infect_perks[level.infect_perks.size] = "specialty_quickdraw";
	level.infect_perks[level.infect_perks.size] = "_specialty_blastshield";
	level.infect_perks[level.infect_perks.size] = "specialty_detectexplosive";
	level.infect_perks[level.infect_perks.size] = "specialty_autospot";
	level.infect_perks[level.infect_perks.size] = "specialty_bulletaccuracy";
	level.infect_perks[level.infect_perks.size] = "specialty_quieter";
	level.infect_perks[level.infect_perks.size] = "specialty_stalker";

	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;
}

initializeMatchRules()
{
	maps\mp\_utility::setCommonRulesFromMatchRulesData();
	level.matchRules_numInitialInfected = getmatchrulesdata( "infectData", "numInitialInfected" );
	setdynamicdvar( "scr_" + level.gameType + "_numLives", 0 );
	maps\mp\_utility::registerNumLivesDvar( level.gameType, 0 );
	maps\mp\_utility::setOverrideWatchDvar( "scorelimit", 0 );
	setdynamicdvar( "scr_infect_roundswitch", 0 );
	maps\mp\_utility::registerRoundSwitchDvar( "infect", 0, 0, 9 );
	setdynamicdvar( "scr_infect_roundlimit", 1 );
	maps\mp\_utility::registerRoundLimitDvar( "infect", 1 );
	setdynamicdvar( "scr_infect_winlimit", 1 );
	maps\mp\_utility::registerWinLimitDvar( "infect", 1 );
	setdynamicdvar( "scr_infect_halftime", 0 );
	maps\mp\_utility::registerHalfTimeDvar( "infect", 0 );
	setdynamicdvar( "scr_infect_playerrespawndelay", 0 );
	setdynamicdvar( "scr_infect_waverespawndelay", 0 );
	setdynamicdvar( "scr_player_forcerespawn", 1 );
	setdynamicdvar( "scr_team_fftype", 0 );
	setdynamicdvar( "scr_infect_promode", 0 );
}

onPrecacheGameType()
{
	precachestring( &"MP_CONSCRIPTION_STARTS_IN" );
}

onStartGameType()
{
	setclientnamemode( "auto_change" );
	maps\mp\_utility::setObjectiveText( "allies", &"OBJECTIVES_INFECT" );
	maps\mp\_utility::setObjectiveText( "axis", &"OBJECTIVES_INFECT" );

	maps\mp\_utility::setObjectiveScoreText( "allies", &"OBJECTIVES_INFECT" );
	maps\mp\_utility::setObjectiveScoreText( "axis", &"OBJECTIVES_INFECT" );

	maps\mp\_utility::setObjectiveScoreText( "allies", &"OBJECTIVES_INFECT_SCORE" );
	maps\mp\_utility::setObjectiveScoreText( "axis", &"OBJECTIVES_INFECT_SCORE" );

	maps\mp\_utility::setObjectiveHintText( "allies", &"OBJECTIVES_INFECT_HINT" );
	maps\mp\_utility::setObjectiveHintText( "axis", &"OBJECTIVES_INFECT_HINT" );
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setmapcenter( level.mapCenter );
	var_0 = [];
	maps\mp\gametypes\_gameobjects::main( var_0 );

	if ( maps\mp\_utility::matchMakingGame() )
		maps\mp\_equipment::createkilltriggers();

	maps\mp\gametypes\_rank::registerScoreInfo( "firstblood", 0 );
	maps\mp\gametypes\_rank::registerScoreInfo( "first_draft", 350 );
	maps\mp\gametypes\_rank::registerScoreInfo( "final_rogue", 200 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "draft_rogue", 200 );
	maps\mp\gametypes\_rank::registerScoreInfo( "survivor", 50 );
	level.QuickMessageToAll = 1;
	level.blockWeaponDrops = 1;
	level.infect_allowsuicide = 0;
	level.infect_timerDisplay = maps\mp\gametypes\_hud_util::createServerTimer( "objective", 1.4 );
	level.infect_timerDisplay maps\mp\gametypes\_hud_util::setPoint( "TOPLEFT", "TOPLEFT", 115, 5 );
	level.infect_timerDisplay.label = &"MP_DRAFT_STARTS_IN";
	level.infect_timerDisplay.alpha = 0;
	level.infect_timerDisplay.archived = 0;
	level.infect_timerDisplay.hidewheninmenu = 1;
	level.infect_choseFirstInfected = 0;
	level.infect_choosingFirstInfected = 0;
	level.infect_awardedfinalsurvivor = 0;
	level.infect_teamscores["axis"] = 0;
	level.infect_teamscores["allies"] = 0;
	level.infect_players = [];
	level thread onPlayerConnect();
	level thread watchinfectforfeit();
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connected",  player  );
		player.infect_firstSpawn = 1;

		if ( maps\mp\_utility::gameFlag( "prematch_done" ) )
			player.infect_joinedatstart = 0;
		else
			player.infect_joinedatstart = 1;

		if ( isdefined( level.infect_players[player.name] ) )
			player.infect_rejoined = 1;
	}
}

getSpawnPoint()
{
	if ( self.infect_firstSpawn )
	{
		self.infect_firstSpawn = 0;
		self.pers["class"] = "gamemode";
		self.pers["lastClass"] = "";
		self.class = self.pers["class"];
		self.lastClass = self.pers["lastClass"];

		if ( isdefined( self.infect_rejoined ) )
			maps\mp\gametypes\_menus::addToTeam( "axis", 1 );
		else
			maps\mp\gametypes\_menus::addToTeam( "allies", 1 );

		thread onPlayerDisconnect();
	}

	if ( level.inGracePeriod )
	{
		var_0 = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dm_spawn" );
		var_1 = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( var_0 );
	}
	else
	{
		var_0 = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
		var_1 = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( var_0 );
	}

	return var_1;
}

onSpawnPlayer()
{
	self.teamchangedthisframe = undefined;
	self.infect_spawnpos = self.origin;
	updateTeamScores();

	if ( !level.infect_choosingFirstInfected )
	{
		level.infect_choosingFirstInfected = 1;
		level thread chooseFirstInfected();
	}

	if ( isdefined( self.infect_rejoined ) )
	{
		self.infect_rejoined = undefined;

		if ( !level.infect_allowsuicide )
		{
			level notify( "infect_stopCountdown" );
			level.infect_choseFirstInfected = 1;
			level.infect_allowsuicide = 1;

			foreach ( var_1 in level.players )
			{
				if ( isdefined( var_1.infect_isBeingChosen ) )
					var_1.infect_isBeingChosen = undefined;
			}
		}

		foreach ( var_1 in level.players )
		{
			if ( isdefined( var_1.isInitialInfected ) )
				var_1 thread setInitialToNormalInfected();
		}

		if ( level.infect_teamscores["axis"] == 1 )
			self.isInitialInfected = 1;
	}

	if ( isdefined( self.isInitialInfected ) )
		self.pers["gamemodeLoadout"] = level.infect_loadouts["axis_initial"];
	else
		self.pers["gamemodeLoadout"] = level.infect_loadouts[self.pers["team"]];

	thread onspawnfinished();
	level notify( "spawned_player" );
}

onspawnfinished()
{
	self endon( "death" );
	self endon( "disconnect" );
	self waittill( "spawned_player" );

	if ( self.pers["team"] == "axis" )
		thread setinfectedmsg();

	wait 0.05;

	if ( self.pers["team"] == "axis" )
		maps\mp\killstreaks\_killstreaks::clearKillstreaks();

	if ( maps\mp\_utility::matchMakingGame() )
	{
		foreach ( var_1 in level.infect_perks )
		{
			if ( maps\mp\_utility::_hasPerk( var_1 ) )
			{
				var_2 = tablelookup( "mp/perktable.csv", 1, var_1, 8 );

				if ( !maps\mp\_utility::_hasPerk( var_2 ) )
					maps\mp\_utility::givePerk( var_2, 0 );
			}
		}

		if ( self.pers["team"] == "allies" )
		{
			if ( !maps\mp\_utility::_hasPerk( "specialty_scavenger" ) )
			{
				maps\mp\_utility::givePerk( "specialty_scavenger", 0 );
				var_2 = tablelookup( "mp/perktable.csv", 1, "specialty_scavenger", 8 );

				if ( !maps\mp\_utility::_hasPerk( var_2 ) )
					maps\mp\_utility::givePerk( var_2, 0 );
			}
		}
		else if ( self.pers["team"] == "axis" )
		{
			if ( isdefined( self.isInitialInfected ) && !maps\mp\_utility::_hasPerk( "specialty_longersprint" ) )
			{
				maps\mp\_utility::givePerk( "specialty_longersprint", 0 );
				var_2 = tablelookup( "mp/perktable.csv", 1, "specialty_longersprint", 8 );

				if ( !maps\mp\_utility::_hasPerk( var_2 ) )
					maps\mp\_utility::givePerk( var_2, 0 );
			}

			if ( !maps\mp\_utility::_hasPerk( "specialty_falldamage" ) )
				maps\mp\_utility::givePerk( "specialty_falldamage", 0 );

			if ( maps\mp\_utility::_hasPerk( "specialty_longersprint" ) )
			{
				maps\mp\_utility::givePerk( "specialty_lightweight", 0 );
				self setmovespeedscale( 1.2 );
			}
		}
	}
}

setinfectedmsg()
{
	if ( isdefined( self.isInitialInfected ) )
		thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_FIRST_MERCENARY", ( 1, 0, 0 ), 0.3 );
	else if ( isdefined( self.changingtoregularinfected ) )
	{
		self.changingtoregularinfected = undefined;

		if ( isdefined( self.changingtoregularinfectedbykill ) )
		{
			self.changingtoregularinfectedbykill = undefined;
			thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_FIRSTBLOOD" );
			maps\mp\gametypes\_gamescore::givePlayerScore( "first_draft", self );
			thread maps\mp\gametypes\_rank::giveRankXP( "first_draft" );
		}
	}
	else
		thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_DRAFTED", ( 1, 0, 0 ), 0.3 );
}

chooseFirstInfected()
{
	level endon( "game_ended" );
	level endon( "infect_stopCountdown" );
	level.infect_allowsuicide = 0;
	maps\mp\_utility::gameFlagWait( "prematch_done" );
	level.infect_timerDisplay.label = &"MP_DRAFT_STARTS_IN";
	level.infect_timerDisplay settimer( 8 );
	level.infect_timerDisplay.alpha = 1;
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 8.0 );
	level.infect_timerDisplay.alpha = 0;
	level.players[randomint( level.players.size )] setfirstinfected( 1 );
}

setfirstinfected( var_0 )
{
	self endon( "disconnect" );

	if ( var_0 )
		self.infect_isBeingChosen = 1;

	while ( !maps\mp\_utility::isReallyAlive( self ) || maps\mp\_utility::isUsingRemote() )
		wait 0.05;

	if ( isdefined( self.isCarrying ) && self.isCarrying == 1 )
	{
		self notify( "force_cancel_placement" );
		wait 0.05;
	}

	while ( self ismantling() )
		wait 0.05;

	while ( !self isonground() && !self isonladder() )
		wait 0.05;

	if ( maps\mp\_utility::isJuggernaut() )
	{
		self notify( "lost_juggernaut" );
		wait 0.05;
	}

	if ( var_0 )
	{
		maps\mp\gametypes\_menus::addToTeam( "axis" );
		level.infect_choseFirstInfected = 1;
		self.infect_isBeingChosen = undefined;
		updateTeamScores();
		level.infect_allowsuicide = 1;
	}

	self.isInitialInfected = 1;
	self.pers["gamemodeLoadout"] = level.infect_loadouts["axis_initial"];

	if ( isdefined( self.setSpawnpoint ) )
		maps\mp\perks\_perkfunctions::deleteTI( self.setSpawnpoint );

	var_1 = spawn( "script_model", self.origin );
	var_1.angles = self.angles;
	var_1.playerSpawnPos = self.origin;
	var_1.notti = 1;
	self.setSpawnpoint = var_1;
	self notify( "faux_spawn" );
	self.faux_spawn_stance = self getstance();
	thread maps\mp\gametypes\_playerlogic::spawnPlayer( 1 );

	if ( var_0 )
		level.infect_players[self.name] = 1;

	thread maps\mp\_utility::teamPlayerCardSplash( "callout_first_mercenary", self );
	maps\mp\_utility::playSoundOnPlayers( "mp_enemy_obj_captured" );
}

setInitialToNormalInfected( var_0 )
{
	level endon( "game_ended" );
	self.isInitialInfected = undefined;
	self.changingtoregularinfected = 1;

	if ( isdefined( var_0 ) )
		self.changingtoregularinfectedbykill = 1;

	while ( !maps\mp\_utility::isReallyAlive( self ) )
		wait 0.05;

	if ( isdefined( self.isCarrying ) && self.isCarrying == 1 )
	{
		self notify( "force_cancel_placement" );
		wait 0.05;
	}

	while ( self ismantling() )
		wait 0.05;

	while ( !self isonground() )
		wait 0.05;

	if ( maps\mp\_utility::isJuggernaut() )
	{
		self notify( "lost_juggernaut" );
		wait 0.05;
	}

	while ( !maps\mp\_utility::isReallyAlive( self ) )
		wait 0.05;

	self.pers["gamemodeLoadout"] = level.infect_loadouts["axis"];

	if ( isdefined( self.setSpawnpoint ) )
		maps\mp\perks\_perkfunctions::deleteTI( self.setSpawnpoint );

	var_1 = spawn( "script_model", self.origin );
	var_1.angles = self.angles;
	var_1.playerSpawnPos = self.origin;
	var_1.notti = 1;
	self.setSpawnpoint = var_1;
	self notify( "faux_spawn" );
	self.faux_spawn_stance = self getstance();
	thread maps\mp\gametypes\_playerlogic::spawnPlayer( 1 );
}

onPlayerKilled( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9 )
{
	var_10 = 0;
	var_11 = 0;

	if ( self.team == "allies" && isdefined( var_1 ) )
	{
		if ( isplayer( var_1 ) && var_1 != self )
			var_10 = 1;
		else if ( level.infect_allowsuicide && ( var_1 == self || !isplayer( var_1 ) ) )
		{
			var_10 = 1;
			var_11 = 1;
		}
	}

	if ( var_10 )
	{
		self.teamchangedthisframe = 1;
		maps\mp\gametypes\_menus::addToTeam( "axis" );
		updateTeamScores();
		level.infect_players[self.name] = 1;

		if ( var_11 )
		{
			if ( level.infect_teamscores["axis"] > 1 )
			{
				foreach ( var_13 in level.players )
				{
					if ( isdefined( var_13.isInitialInfected ) )
						var_13 thread setInitialToNormalInfected();
				}
			}
		}
		else if ( isdefined( var_1.isInitialInfected ) )
			var_1 thread setInitialToNormalInfected( 1 );
		else
		{
			var_1 thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_DRAFTED" );
			maps\mp\gametypes\_gamescore::givePlayerScore( "draft_rogue", var_1, self, 1 );
			var_1 thread maps\mp\gametypes\_rank::giveRankXP( "draft_rogue" );
		}

		if ( level.infect_teamscores["allies"] > 1 )
		{
			maps\mp\_utility::playSoundOnPlayers( "mp_enemy_obj_captured", "allies" );
			maps\mp\_utility::playSoundOnPlayers( "mp_war_objective_taken", "axis" );
			thread maps\mp\_utility::teamPlayerCardSplash( "callout_got_drafted", self, "allies" );

			if ( !var_11 )
			{
				thread maps\mp\_utility::teamPlayerCardSplash( "callout_drafted_rogue", var_1, "axis" );

				foreach ( var_13 in level.players )
				{
					if ( var_13.team == "allies" && var_13 != self && distance( var_13.infect_spawnpos, var_13.origin ) > 32 )
					{
						var_13 thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_SURVIVOR" );
						maps\mp\gametypes\_gamescore::givePlayerScore( "survivor", var_13, undefined, 1 );
						var_13 thread maps\mp\gametypes\_rank::giveRankXP( "survivor" );
					}
				}
			}
		}
		else if ( level.infect_teamscores["allies"] == 1 )
			onfinalsurvivor();
		else if ( level.infect_teamscores["allies"] == 0 )
			onsurvivorseliminated();
	}
}

onfinalsurvivor()
{
	maps\mp\_utility::playSoundOnPlayers( "mp_obj_captured" );

	foreach ( var_1 in level.players )
	{
		if ( var_1.team == "allies" )
		{
			var_1 thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_FINAL_ROGUE" );

			if ( !level.infect_awardedfinalsurvivor )
			{
				if ( var_1.infect_joinedatstart && distance( var_1.infect_spawnpos, var_1.origin ) > 32 )
				{
					maps\mp\gametypes\_gamescore::givePlayerScore( "final_rogue", var_1, undefined, 1 );
					var_1 thread maps\mp\gametypes\_rank::giveRankXP( "final_rogue" );
				}

				level.infect_awardedfinalsurvivor = 1;
			}

			thread maps\mp\_utility::teamPlayerCardSplash( "callout_final_rogue", var_1 );

			if ( maps\mp\_utility::matchMakingGame() && !var_1 maps\mp\_utility::isJuggernaut() )
				level thread finalsurvivoruav( var_1 );

			break;
		}
	}
}

finalsurvivoruav( var_0 )
{
	level endon( "game_ended" );
	var_0 endon( "disconnect" );
	var_0 endon( "eliminated" );
	level endon( "infect_lateJoiner" );
	level thread enduavonlatejoiner( var_0 );
	var_1 = 0;
	level.radarmode["axis"] = "normal_radar";

	foreach ( var_3 in level.players )
	{
		if ( var_3.team == "axis" )
			var_3.radarmode = "normal_radar";
	}

	setteamradarstrength( "axis", 1 );

	for ( ;; )
	{
		var_5 = var_0.origin;
		wait 4;

		if ( var_1 )
		{
			setteamradar( "axis", 0 );
			var_1 = 0;
		}

		wait 6;

		if ( distance( var_5, var_0.origin ) < 200 )
		{
			setteamradar( "axis", 1 );
			var_1 = 1;

			foreach ( var_3 in level.players )
				var_3 playlocalsound( "recondrone_tag" );
		}
	}
}

enduavonlatejoiner( var_0 )
{
	level endon( "game_ended" );
	var_0 endon( "disconnect" );
	var_0 endon( "eliminated" );

	for ( ;; )
	{
		if ( level.infect_teamscores["allies"] > 1 )
		{
			level notify( "infect_lateJoiner" );
			wait 0.05;
			setteamradar( "axis", 0 );
			break;
		}

		wait 0.05;
	}
}

onPlayerDisconnect()
{
	level endon( "game_ended" );
	self endon( "eliminated" );
	self waittill( "disconnect" );
	updateTeamScores();

	if ( isdefined( self.infect_isBeingChosen ) || level.infect_choseFirstInfected )
	{
		if ( level.infect_teamscores["axis"] && level.infect_teamscores["allies"] )
		{
			if ( self.team == "allies" && level.infect_teamscores["allies"] == 1 )
				onfinalsurvivor();
			else if ( self.team == "axis" && level.infect_teamscores["axis"] == 1 )
			{
				foreach ( var_1 in level.players )
				{
					if ( var_1 != self && var_1.team == "axis" )
						var_1 setfirstinfected( 0 );
				}
			}
		}
		else if ( level.infect_teamscores["allies"] == 0 )
			onsurvivorseliminated();
		else if ( level.infect_teamscores["axis"] == 0 )
		{
			if ( level.infect_teamscores["allies"] == 1 )
			{
				level.finalKillCam_winner = "allies";
				level thread maps\mp\gametypes\_gamelogic::endGame( "allies", game["strings"]["axis_eliminated"] );
			}
			else if ( level.infect_teamscores["allies"] > 1 )
			{
				level.infect_choseFirstInfected = 0;
				level thread chooseFirstInfected();
			}
		}
	}

	self.isInitialInfected = undefined;
}

watchinfectforfeit()
{
	level endon( "game_ended" );
	level.forfeitInProgress = 1;

	for ( ;; )
	{
		if ( !isdefined( level.forfeitInProgress ) )
			level.forfeitInProgress = 1;

		wait 0.05;
	}
}

onDeadEvent( team )
{
	return;
}

onTimeLimit()
{
	level.finalKillCam_winner = "allies";
	level thread maps\mp\gametypes\_gamelogic::endGame( "allies", game["strings"]["time_limit_reached"] );
}

onsurvivorseliminated()
{
	level.finalKillCam_winner = "axis";
	level thread maps\mp\gametypes\_gamelogic::endGame( "axis", game["strings"]["allies_eliminated"] );
}

getnumaxis()
{
	var_0 = 0;

	foreach ( var_2 in level.players )
	{
		if ( isdefined( var_2.team ) && var_2.team == "axis" )
			var_0++;
	}

	return var_0;
}

getnumallies()
{
	var_0 = 0;

	foreach ( var_2 in level.players )
	{
		if ( isdefined( var_2.team ) && var_2.team == "allies" )
			var_0++;
	}

	return var_0;
}

updateTeamScores()
{
	level.infect_teamscores["axis"] = getnumaxis();
	level.infect_teamscores["allies"] = getnumallies();
	game["teamScores"]["axis"] = level.infect_teamscores["axis"];
	setteamscore( "axis", level.infect_teamscores["axis"] );
	game["teamScores"]["allies"] = level.infect_teamscores["allies"];
	setteamscore( "allies", level.infect_teamscores["allies"] );
}

setSpecialLoadouts()
{
	if ( isusingmatchrulesdata() && getmatchrulesdata( "defaultClasses", "axis", 0, "class", "inUse" ) )
	{
		level.infect_loadouts["axis"] = maps\mp\_utility::GetMatchRulesSpecialClass( "axis", 0 );
		level.infect_loadouts["axis"]["loadoutStreakType"] = "assault";
		level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";
	}
	else
	{
		level.infect_loadouts["axis"]["loadoutPrimary"] = "iw5_fmg9";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment"] = "reflex";
		level.infect_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondary"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis"]["loadoutEquipment"] = "throwingknife_mp";
		level.infect_loadouts["axis"]["loadoutOffhand"] = "none";
		level.infect_loadouts["axis"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis"]["loadoutPerk3"] = "specialty_quieter";
		level.infect_loadouts["axis"]["loadoutStreakType"] = "assault";
		level.infect_loadouts["axis"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis"]["loadoutKillstreak3"] = "none";
		level.infect_loadouts["axis"]["loadoutDeathstreak"] = "specialty_grenadepulldeath";
		level.infect_loadouts["axis"]["loadoutJuggernaut"] = 0;
	}

	if ( isusingmatchrulesdata() && getmatchrulesdata( "defaultClasses", "axis", 5, "class", "inUse" ) )
	{
		level.infect_loadouts["axis_initial"] = maps\mp\_utility::GetMatchRulesSpecialClass( "axis", 5 );
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "assault";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";
	}
	else
	{
		level.infect_loadouts["axis_initial"]["loadoutPrimary"] = "iw5_scar";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment"] = "reflex";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryAttachment2"] = "xmags";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryBuff"] = "specialty_bling";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondary"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutEquipment"] = "specialty_null";
		level.infect_loadouts["axis_initial"]["loadoutOffhand"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutPerk1"] = "specialty_longersprint";
		level.infect_loadouts["axis_initial"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["axis_initial"]["loadoutPerk3"] = "specialty_bulletaccuracy";
		level.infect_loadouts["axis_initial"]["loadoutStreakType"] = "assault";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak1"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak2"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutKillstreak3"] = "none";
		level.infect_loadouts["axis_initial"]["loadoutDeathstreak"] = "specialty_grenadepulldeath";
		level.infect_loadouts["axis_initial"]["loadoutJuggernaut"] = 0;
	}

	if ( isusingmatchrulesdata() && getmatchrulesdata( "defaultClasses", "allies", 0, "class", "inUse" ) )
		level.infect_loadouts["allies"] = maps\mp\_utility::GetMatchRulesSpecialClass( "allies", 0 );
	else
	{
		level.infect_loadouts["allies"]["loadoutPrimary"] = "iw5_spas12";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment"] = "silencer03";
		level.infect_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_longerrange";
		level.infect_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutPrimaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondary"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.infect_loadouts["allies"]["loadoutSecondaryReticle"] = "none";
		level.infect_loadouts["allies"]["loadoutEquipment"] = "claymore_mp";
		level.infect_loadouts["allies"]["loadoutOffhand"] = "flash_grenade_mp";
		level.infect_loadouts["allies"]["loadoutPerk1"] = "specialty_scavenger";
		level.infect_loadouts["allies"]["loadoutPerk2"] = "specialty_quickdraw";
		level.infect_loadouts["allies"]["loadoutPerk3"] = "specialty_quieter";
		level.infect_loadouts["allies"]["loadoutDeathstreak"] = "specialty_null";
		level.infect_loadouts["allies"]["loadoutJuggernaut"] = 0;
	}
}
