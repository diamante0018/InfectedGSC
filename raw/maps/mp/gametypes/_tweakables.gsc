/*
    _tweakables
    Author: FutureRave
    Date: 10/11/2021
*/

getTweakableDVarValue( var_0, var_1 )
{
	switch ( var_0 )
	{
		case "rule":
			var_2 = level.rules[var_1].dVar;
			break;

		case "game":
			var_2 = level.gameTweaks[var_1].dVar;
			break;

		case "team":
			var_2 = level.teamTweaks[var_1].dVar;
			break;

		case "player":
			var_2 = level.playerTweaks[var_1].dVar;
			break;

		case "class":
			var_2 = level.classTweaks[var_1].dVar;
			break;

		case "weapon":
			var_2 = level.weaponTweaks[var_1].dVar;
			break;

		case "hardpoint":
			var_2 = level.hardpointTweaks[var_1].dVar;
			break;

		case "hud":
			var_2 = level.hudTweaks[var_1].dVar;
			break;

		default:
			var_2 = undefined;
			break;
	}

	var_3 = getdvarint( var_2 );
	return var_3;
}

getTweakableDVar( var_0, var_1 )
{
	switch ( var_0 )
	{
		case "rule":
			var_2 = level.rules[var_1].dVar;
			break;

		case "game":
			var_2 = level.gameTweaks[var_1].dVar;
			break;

		case "team":
			var_2 = level.teamTweaks[var_1].dVar;
			break;

		case "player":
			var_2 = level.playerTweaks[var_1].dVar;
			break;

		case "class":
			var_2 = level.classTweaks[var_1].dVar;
			break;

		case "weapon":
			var_2 = level.weaponTweaks[var_1].dVar;
			break;

		case "hardpoint":
			var_2 = level.hardpointTweaks[var_1].dVar;
			break;

		case "hud":
			var_2 = level.hudTweaks[var_1].dVar;
			break;

		default:
			var_2 = undefined;
			break;
	}

	return var_2;
}

getTweakableValue( var_0, var_1 )
{
	switch ( var_0 )
	{
		case "rule":
			var_2 = level.rules[var_1].value;
			break;

		case "game":
			var_2 = level.gameTweaks[var_1].value;
			break;

		case "team":
			var_2 = level.teamTweaks[var_1].value;
			break;

		case "player":
			var_2 = level.playerTweaks[var_1].value;
			break;

		case "class":
			var_2 = level.classTweaks[var_1].value;
			break;

		case "weapon":
			var_2 = level.weaponTweaks[var_1].value;
			break;

		case "hardpoint":
			var_2 = level.hardpointTweaks[var_1].value;
			break;

		case "hud":
			var_2 = level.hudTweaks[var_1].value;
			break;

		default:
			var_2 = undefined;
			break;
	}

	return var_2;
}

getTweakableLastValue( var_0, var_1 )
{
	switch ( var_0 )
	{
		case "rule":
			var_2 = level.rules[var_1].lastValue;
			break;

		case "game":
			var_2 = level.gameTweaks[var_1].lastValue;
			break;

		case "team":
			var_2 = level.teamTweaks[var_1].lastValue;
			break;

		case "player":
			var_2 = level.playerTweaks[var_1].lastValue;
			break;

		case "class":
			var_2 = level.classTweaks[var_1].lastValue;
			break;

		case "weapon":
			var_2 = level.weaponTweaks[var_1].lastValue;
			break;

		case "hardpoint":
			var_2 = level.hardpointTweaks[var_1].lastValue;
			break;

		case "hud":
			var_2 = level.hudTweaks[var_1].lastValue;
			break;

		default:
			var_2 = undefined;
			break;
	}

	return var_2;
}

setTweakableValue( var_0, var_1, var_2 )
{
	switch ( var_0 )
	{
		case "rule":
			var_3 = level.rules[var_1].dVar;
			break;

		case "game":
			var_3 = level.gameTweaks[var_1].dVar;
			break;

		case "team":
			var_3 = level.teamTweaks[var_1].dVar;
			break;

		case "player":
			var_3 = level.playerTweaks[var_1].dVar;
			break;

		case "class":
			var_3 = level.classTweaks[var_1].dVar;
			break;

		case "weapon":
			var_3 = level.weaponTweaks[var_1].dVar;
			break;

		case "hardpoint":
			var_3 = level.hardpointTweaks[var_1].dVar;
			break;

		case "hud":
			var_3 = level.hudTweaks[var_1].dVar;
			break;

		default:
			var_3 = undefined;
			break;
	}

	setdvar( var_3, var_2 );
}

setTweakableLastValue( var_0, var_1, var_2 )
{
	switch ( var_0 )
	{
		case "rule":
			level.rules[var_1].lastValue = var_2;
			break;

		case "game":
			level.gameTweaks[var_1].lastValue = var_2;
			break;

		case "team":
			level.teamTweaks[var_1].lastValue = var_2;
			break;

		case "player":
			level.playerTweaks[var_1].lastValue = var_2;
			break;

		case "class":
			level.classTweaks[var_1].lastValue = var_2;
			break;

		case "weapon":
			level.weaponTweaks[var_1].lastValue = var_2;
			break;

		case "hardpoint":
			level.hardpointTweaks[var_1].lastValue = var_2;
			break;

		case "hud":
			level.hudTweaks[var_1].lastValue = var_2;
			break;

		default:
			break;
	}
}

registerTweakable( var_0, var_1, var_2, var_3 )
{
	if ( isstring( var_3 ) )
		var_3 = getdvar( var_2, var_3 );
	else
		var_3 = getdvarint( var_2, var_3 );

	switch ( var_0 )
	{
		case "rule":
			if ( !isdefined( level.rules[var_1] ) )
				level.rules[var_1] = spawnstruct();

			level.rules[var_1].value = var_3;
			level.rules[var_1].lastValue = var_3;
			level.rules[var_1].dVar = var_2;
			break;

		case "game":
			if ( !isdefined( level.gameTweaks[var_1] ) )
				level.gameTweaks[var_1] = spawnstruct();

			level.gameTweaks[var_1].value = var_3;
			level.gameTweaks[var_1].lastValue = var_3;
			level.gameTweaks[var_1].dVar = var_2;
			break;

		case "team":
			if ( !isdefined( level.teamTweaks[var_1] ) )
				level.teamTweaks[var_1] = spawnstruct();

			level.teamTweaks[var_1].value = var_3;
			level.teamTweaks[var_1].lastValue = var_3;
			level.teamTweaks[var_1].dVar = var_2;
			break;

		case "player":
			if ( !isdefined( level.playerTweaks[var_1] ) )
				level.playerTweaks[var_1] = spawnstruct();

			level.playerTweaks[var_1].value = var_3;
			level.playerTweaks[var_1].lastValue = var_3;
			level.playerTweaks[var_1].dVar = var_2;
			break;

		case "class":
			if ( !isdefined( level.classTweaks[var_1] ) )
				level.classTweaks[var_1] = spawnstruct();

			level.classTweaks[var_1].value = var_3;
			level.classTweaks[var_1].lastValue = var_3;
			level.classTweaks[var_1].dVar = var_2;
			break;

		case "weapon":
			if ( !isdefined( level.weaponTweaks[var_1] ) )
				level.weaponTweaks[var_1] = spawnstruct();

			level.weaponTweaks[var_1].value = var_3;
			level.weaponTweaks[var_1].lastValue = var_3;
			level.weaponTweaks[var_1].dVar = var_2;
			break;

		case "hardpoint":
			if ( !isdefined( level.hardpointTweaks[var_1] ) )
				level.hardpointTweaks[var_1] = spawnstruct();

			level.hardpointTweaks[var_1].value = var_3;
			level.hardpointTweaks[var_1].lastValue = var_3;
			level.hardpointTweaks[var_1].dVar = var_2;
			break;

		case "hud":
			if ( !isdefined( level.hudTweaks[var_1] ) )
				level.hudTweaks[var_1] = spawnstruct();

			level.hudTweaks[var_1].value = var_3;
			level.hudTweaks[var_1].lastValue = var_3;
			level.hudTweaks[var_1].dVar = var_2;
			break;
	}
}

init()
{
	level.clientTweakables = [];
	level.tweakablesInitialized = 1;
	level.rules = [];
	level.gameTweaks = [];
	level.teamTweaks = [];
	level.playerTweaks = [];
	level.classTweaks = [];
	level.weaponTweaks = [];
	level.hardpointTweaks = [];
	level.hudTweaks = [];

	if ( level.console )
		registerTweakable( "game", "graceperiod", "scr_game_graceperiod", 5 );
	else
	{
		registerTweakable( "game", "playerwaittime", "scr_game_playerwaittime", 1 );
		registerTweakable( "game", "matchstarttime", "scr_game_matchstarttime", 5 );
	}

	registerTweakable( "game", "onlyheadshots", "scr_game_onlyheadshots", 0 );
	registerTweakable( "game", "allowkillcam", "scr_game_allowkillcam", 1 );
	registerTweakable( "game", "spectatetype", "scr_game_spectatetype", 2 );
	registerTweakable( "game", "deathpointloss", "scr_game_deathpointloss", 0 );
	registerTweakable( "game", "suicidepointloss", "scr_game_suicidepointloss", 0 );
	registerTweakable( "team", "teamkillpointloss", "scr_team_teamkillpointloss", 0 );
	registerTweakable( "team", "fftype", "scr_team_fftype", 0 );
	registerTweakable( "team", "teamkillspawndelay", "scr_team_teamkillspawndelay", 0 );
	registerTweakable( "player", "maxhealth", "scr_player_maxhealth", 100 );
	registerTweakable( "player", "healthregentime", "scr_player_healthregentime", 5 );
	registerTweakable( "player", "forcerespawn", "scr_player_forcerespawn", 1 );
	registerTweakable( "weapon", "allowfrag", "scr_weapon_allowfrags", 1 );
	registerTweakable( "weapon", "allowsmoke", "scr_weapon_allowsmoke", 1 );
	registerTweakable( "weapon", "allowflash", "scr_weapon_allowflash", 1 );
	registerTweakable( "weapon", "allowc4", "scr_weapon_allowc4", 1 );
	registerTweakable( "weapon", "allowclaymores", "scr_weapon_allowclaymores", 1 );
	registerTweakable( "weapon", "allowrpgs", "scr_weapon_allowrpgs", 1 );
	registerTweakable( "weapon", "allowmines", "scr_weapon_allowmines", 1 );
	registerTweakable( "hardpoint", "allowartillery", "scr_hardpoint_allowartillery", 1 );
	registerTweakable( "hardpoint", "allowuav", "scr_hardpoint_allowuav", 1 );
	registerTweakable( "hardpoint", "allowsupply", "scr_hardpoint_allowsupply", 1 );
	registerTweakable( "hardpoint", "allowhelicopter", "scr_hardpoint_allowhelicopter", 1 );
	registerTweakable( "hud", "showobjicons", "ui_hud_showobjicons", 1 );
	makedvarserverinfo( "ui_hud_showobjicons", 1 );
}
