/*
    _inf_anti_camp
    Author: FutureRave
    Changelog:
    - Ignore bots
    - Remove map descriptions because I feel like they are useless
    Date: 27/09/2021
*/

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

NO_DESC = "No description";

init()
{
	precacheShader( "gradient_fadein" );
	precacheShader( "gradient_top" );
	precacheShader( "white" );

	level.mapVoteMaps = strtok( "mp_alpha#mp_bootleg#mp_bravo#mp_carbon#mp_dome#mp_exchange#mp_hardhat#mp_interchange#mp_lambeth#mp_mogadishu#mp_paris#mp_plaza2#mp_radar#mp_seatown#mp_underground#mp_village#mp_terminal_cls#mp_rust#mp_highrise#mp_italy#mp_park#mp_overwatch#mp_morningwood#mp_meteora#mp_cement#mp_qadeem#mp_restrepo_ss#mp_hillside_ss#mp_courtyard_ss#mp_aground_ss#mp_six_ss#mp_burn_ss#mp_crosswalk_ss#shipbreaker#mp_roughneck#mp_moab#mp_boardwalk#mp_nola#mp_nightshift#mp_nuked#mp_favela", "#" );
	level.mapVoteIndices = randomIndices();
	replacefunc( maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::finalKillcamHook );
}

randomIndices()
{
	array = [];

	for ( i = 0; i < 6; i++ )
	{
		array[i] = randomInt( level.mapVoteMaps.size );

		for ( j = 0; j < i; j++ )
		{
			if ( array[i] == array[j] )
			{
				i--;
				break;
			}
		}
	}

	return array;
}

finalKillcamHook()
{
	if ( !IsDefined( level.finalkillcam_winner ) )
	{
		mapVote();
		return false;
	}

	level waittill( "final_killcam_done" );
	mapVote();
	return true;
}

mapVote()
{
	if ( !wasLastRound() ) return;

	level.mapVoteUI[0] = shader( "white", "TOP", "TOP", 0, 120, 350, 20, ( 0.157, 0.173, 0.161 ), 1, 1, true );
	level.mapVoteUI[1] = shader( "white", "TOP", "TOP", 0, 140, 350, 60, ( 0.310, 0.349, 0.275 ), 1, 1, true );
	level.mapVoteUI[2] = shader( "gradient_top", "TOP", "TOP", 0, 140, 350, 2, ( 1, 1, 1 ), 1, 2, true );
	level.mapVoteUI[3] = shader( "white", "TOP", "TOP", 0, 200, 350, 20, ( 0.212, 0.231, 0.220 ), 1, 1, true );
	level.mapVoteUI[4] = shader( "white", "TOP", "TOP", 0, 220, 350, 20, ( 0.180, 0.196, 0.188 ), 1, 1, true );
	level.mapVoteUI[5] = shader( "white", "TOP", "TOP", 0, 240, 350, 20, ( 0.212, 0.231, 0.220 ), 1, 1, true );
	level.mapVoteUI[6] = shader( "white", "TOP", "TOP", 0, 260, 350, 20, ( 0.180, 0.196, 0.188 ), 1, 1, true );
	level.mapVoteUI[7] = shader( "white", "TOP", "TOP", 0, 280, 350, 20, ( 0.212, 0.231, 0.220 ), 1, 1, true );
	level.mapVoteUI[8] = shader( "white", "TOP", "TOP", 0, 300, 350, 20, ( 0.180, 0.196, 0.188 ), 1, 1, true );
	level.mapVoteUI[9] = shader( "white", "TOP", "TOP", 0, 320, 350, 20, ( 0.157, 0.173, .161 ), 1, 1, true );
	level.mapVoteUI[10] = shader( "white", "TOP", "TOP", 0, 340, 350, 20, ( 0.310, 0.349, 0.275 ), 1, 1, true );
	level.mapVoteUI[11] = shader( "gradient_top", "TOP", "TOP", 0, 320, 350, 2, ( 1, 1, 1 ), 1, 2, true );
	level.mapVoteUI[12] = text( &"VOTING PHASE: ", "LEFT", "TOP", -170, 130, 1, "hudSmall", ( 1, 1, 1 ), 1, 3, true, 30 );
	level.mapVoteUI[13] = text( mapToString( level.mapVoteMaps[level.mapVoteIndices[0]] ), "LEFT", "TOP", -170, 210, 1.5, "normal", ( 1, 1, 1 ), 1, 3, true, 0 );
	level.mapVoteUI[14] = text( mapToString( level.mapVoteMaps[level.mapVoteIndices[1]] ), "LEFT", "TOP", -170, 230, 1.5, "normal", ( 1, 1, 1 ), 1, 3, true, 0 );
	level.mapVoteUI[15] = text( mapToString( level.mapVoteMaps[level.mapVoteIndices[2]] ), "LEFT", "TOP", -170, 250, 1.5, "normal", ( 1, 1, 1 ), 1, 3, true, 0 );
	level.mapVoteUI[16] = text( mapToString( level.mapVoteMaps[level.mapVoteIndices[3]] ), "LEFT", "TOP", -170, 270, 1.5, "normal", ( 1, 1, 1 ), 1, 3, true, 0 );
	level.mapVoteUI[17] = text( mapToString( level.mapVoteMaps[level.mapVoteIndices[4]] ), "LEFT", "TOP", -170, 290, 1.5, "normal", ( 1, 1, 1 ), 1, 3, true, 0 );
	level.mapVoteUI[18] = text( mapToString( level.mapVoteMaps[level.mapVoteIndices[5]] ), "LEFT", "TOP", -170, 310, 1.5, "normal", ( 1, 1, 1 ), 1, 3, true, 0 );
	//TODO: speed_throw/toggleads_throw will show bound/unbound for hold/toggle ads players. compromise may be to use forward/back, depending on how controller
	//bindings handle this.
	level.mapVoteUI[19] = text( "Up ^2[{+attack}] ^7Down ^2[{+toggleads_throw}]", "LEFT", "TOP", -170, 330, 1.5, "normal", ( 1, 1, 1 ), 1, 3, true );
	level.mapVoteUI[20] = text( "Vote ^2[{+activate}]", "RIGHT", "TOP", 170, 330, 1.5, "normal", ( 1, 1, 1 ), 1, 3, true );

	foreach ( player in level.players )
	{
		guid = player getGuid();

		if ( ( isDefined( player.pers[ "isBot" ] ) && player.pers[ "isBot" ] ) || isSubStr( guid, "bot" ) )
			continue;

		player thread input();
	}

	for ( i = 0; i <= 30; i++ )
	{
		level.mapVoteUI[12] setValue( 30 - i );
		wait 1;
	}

	level notify( "mapvote_over" );
	besti = 0;
	bestv = -1;

	for ( i = 0; i < 6; i++ )
	{
		if ( level.mapVoteUI[i + 13].value > bestv )
		{
			besti = i;
			bestv = level.mapVoteUI[i + 13].value;
		}
	}

	//Note: We wait to prevent the scoreboard popping up at the end for a cleaner transition (Don't wait infinitely as a failsafe).
	//TODO: Proper manipulation of sv_maprotation is the better way to do this as it would allow the final scoreboard to show.
	cmdExec( "map " + level.mapVoteMaps[level.mapVoteIndices[besti]] );
	wait 5;
}

input()
{
	self endon( "disconnect" );
	self endon( "mapvote_over" );
	index = 0;
	selected = -1;

	select[0] = self text( ( index + 1 ) + "/6", "RIGHT", "TOP", 170, 130, 1.5, "normal", ( 1, 1, 1 ), 1, 3, false );
	select[1] = self text( NO_DESC, "LEFT", "TOP", -170, 150, 1.5, "normal", ( 1, 1, 1 ), 1, 3, false );
	select[2] = self shader( "gradient_fadein", "TOP", "TOP", 0, 200, 350, 20, ( 1, 1, 1 ), 0.5, 2, false );
	select[3] = self shader( "gradient_top", "TOP", "TOP", 0, 220, 350, 2, ( 1, 1, 1 ), 1, 2, false );
	self notifyOnPlayerCommand( "up", "+attack" );
	self notifyOnPlayerCommand( "up", "+forward" );
	self notifyOnPlayerCommand( "down", "+toggleads_throw" );
	self notifyOnPlayerCommand( "down", "+speed_throw" );
	self notifyOnPlayerCommand( "down", "+back" );
	self notifyOnPlayerCommand( "select", "+usereload" );
	self notifyOnPlayerCommand( "select", "+activate" );
	self notifyOnPlayerCommand( "select", "+frag" );

	for ( ;; )
	{
		command = self waittill_any_return( "up", "down", "select" );

		if ( command == "up" && index > 0 )
		{
			index--;
			select[0] setText( ( index + 1 ) + "/6" );
			select[1] setText( NO_DESC );
			select[2].y -= 20;
			select[3].y -= 20;
			self playLocalSound( "mouse_over" );
		}
		else if ( command == "down" && index < 5 )
		{
			index++;
			select[0] setText( ( index + 1 ) + "/6" );
			select[1] setText( NO_DESC );
			select[2].y += 20;
			select[3].y += 20;
			self playLocalSound( "mouse_over" );
		}
		else if ( command == "select" )
		{
			if ( selected == -1 )
			{
				selected = index;
				level.mapVoteUI[selected + 13].value += 1;
				level.mapVoteUI[selected + 13] setValue( level.mapVoteUI[selected + 13].value );
				self playLocalSound( "mouse_click" );
			}
			else if ( selected != index )
			{
				level.mapVoteUI[selected + 13].value -= 1;
				level.mapVoteUI[selected + 13] setValue( level.mapVoteUI[selected + 13].value );
				selected = index;
				level.mapVoteUI[selected + 13].value += 1;
				level.mapVoteUI[selected + 13] setValue( level.mapVoteUI[selected + 13].value );
				self playLocalSound( "mouse_click" );
			}
		}
	}
}

text( text, align, relative, x, y, fontscale, font, color, alpha, sort, server, value )
{
	element = spawnStruct();

	if ( server )
	{
		element = createServerFontString( font, fontscale );
	}
	else
	{
		element = self createFontString( font, fontscale );
	}

	if ( isdefined( value ) )
	{
		element.label = text;
		element.value = value;
		element setValue( value );
	}
	else
	{
		element setText( text );
	}

	element.hidewheninmenu = true;
	element.color = color;
	element.alpha = alpha;
	element.sort = sort;
	element setPoint( align, relative, x, y );
	return element;
}

shader( shader, align, relative, x, y, width, height, color, alpha, sort, server )
{
	element = spawnStruct();

	if ( server )
	{
		element = newHudElem( self );
	}
	else
	{
		element = newClientHudElem( self );
	}

	element.elemtype = "icon";
	element.hidewheninmenu = true;
	element.shader = shader;
	element.width = width;
	element.height = height;
	element.align = align;
	element.relative = relative;
	element.xoffset = 0;
	element.yoffset = 0;
	element.children = [];
	element.sort = sort;
	element.color = color;
	element.alpha = alpha;
	element setParent( level.uiparent );
	element setShader( shader, width, height );
	element setPoint( align, relative, x, y );
	return element;
}

mapToString( map )
{
	switch ( map )
	{
		case "mp_alpha":
			return &"LOCKDOWN: ";

		case "mp_bootleg":
			return &"BOOTLEG: ";

		case "mp_bravo":
			return &"MISSION: ";

		case "mp_carbon":
			return &"CARBON: ";

		case "mp_dome":
			return &"DOME: ";

		case "mp_exchange":
			return &"DOWNTURN: ";

		case "mp_hardhat":
			return &"HARDHAT: ";

		case "mp_interchange":
			return &"INTERCHANGE: ";

		case "mp_lambeth":
			return &"FALLEN: ";

		case "mp_mogadishu":
			return &"BAKAARA: ";

		case "mp_paris":
			return &"RESISTANCE: ";

		case "mp_plaza2":
			return &"ARKADEN: ";

		case "mp_radar":
			return &"OUTPOST: ";

		case "mp_seatown":
			return &"SEATOWN: ";

		case "mp_underground":
			return &"UNDERGROUND: ";

		case "mp_village":
			return &"VILLAGE: ";

		case "mp_terminal_cls":
			return &"TERMINAL: ";

		case "mp_rust":
			return &"RUST: ";

		case "mp_highrise":
			return &"HIGHRISE: ";

		case "mp_italy":
			return &"PIAZZA: ";

		case "mp_park":
			return &"LIBERATION: ";

		case "mp_overwatch":
			return &"OVERWATCH: ";

		case "mp_morningwood":
			return &"BLACK BOX: ";

		case "mp_meteora":
			return &"SANCTUARY: ";

		case "mp_qadeem":
			return &"OASIS: ";

		case "mp_restrepo_ss":
			return &"LOOKOUT: ";

		case "mp_hillside_ss":
			return &"GETAWAY: ";

		case "mp_courtyard_ss":
			return &"EROSION: ";

		case "mp_aground_ss":
			return &"AGROUND: ";

		case "mp_six_ss":
			return &"VORTEX: ";

		case "mp_burn_ss":
			return &"U-TURN: ";

		case "mp_crosswalk_ss":
			return &"INTERSECTION: ";

		case "mp_shipbreaker":
			return &"DECOMMISSION: ";

		case "mp_roughneck":
			return &"OFF SHORE: ";

		case "mp_moab":
			return &"GULCH: ";

		case "mp_boardwalk":
			return &"BOARDWALK: ";

		case "mp_nola":
			return &"PARISH: ";

		case "mp_favela":
			return &"FAVELA: ";

		case "mp_nuked":
			return &"NUKETOWN: ";

		case "mp_nightshift":
			return &"SKIDROW: ";

		default:
			return &"MAP: ";
	}
}