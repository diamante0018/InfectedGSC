/*
	_inf_nuke_dome
	Author: FutureRave, Slvr11
	Date: 10/06/2021
*/

#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	level._effect[ "nolight_burst_mp" ] = loadfx( "fire/firelp_huge_pm_nolight_burst" );
	precacheMpAnim( "windmill_spin_med" );
	precacheMpAnim( "foliage_desertbrush_1_sway" );
	precacheMpAnim( "oilpump_pump01" );
	precacheMpAnim( "oilpump_pump02" );
	precacheMpAnim( "windsock_large_wind_medium" );

	thread domeDyn();
	thread nukeDeath();
}

domeDyn()
{
	if ( getDvar( "mapname" ) != "mp_dome" ) return;

	animated = getentarray( "animated_model", "targetname" );

	for ( i = 0; i < animated.size; i++ )
	{
		model_name = animated[i].model;

		if ( isSubStr( model_name, "fence_tarp_" ) )
		{
			animated[i].targetname = "dynamic_model";
			precacheMpAnim( model_name + "_med_01" );
			animated[i] ScriptModelPlayAnim( model_name + "_med_01" );
		}
		else if ( model_name == "machinery_windmill" )
		{
			animated[i].targetname = "dynamic_model";
			animated[i] ScriptModelPlayAnim( "windmill_spin_med" );
		}
		else if ( isSubStr( model_name, "foliage" ) )
		{
			animated[i].targetname = "dynamic_model";
			animated[i] ScriptModelPlayAnim( "foliage_desertbrush_1_sway" );
		}
		else if ( isSubStr( model_name, "oil_pump_jack" ) )
		{
			animated[i].targetname = "dynamic_model";
			animation = "oilpump_pump0" + ( randomint( 2 ) + 1 );
			animated[i] ScriptModelPlayAnim( animation );
		}
		else if ( model_name == "accessories_windsock_large" )
		{
			animated[i].targetname = "dynamic_model";
			animated[i] ScriptModelPlayAnim( "windsock_large_wind_medium" );
		}
	}
}

doBoxEffect( effect )
{
	wait ( 3 );
	forward = AnglesToForward( self.angles );
	up = AnglesToUp( self.angles );

	effect delete ();
	PlayFX( getfx( "box_explode_mp" ), self.origin, forward, up );

	self self_func( "scriptModelClearAnim" );
	self Hide();
}

fenceEffect()
{
	forward = AnglesToForward( self.angles );
	up = AnglesToUp( self.angles );

	fxEnt = SpawnFx( getfx( "nolight_burst_mp" ), self.origin, forward, up );
	TriggerFx( fxEnt );

	self thread doBoxEffect( fxEnt );
}

clearAmim( delay )
{
	wait ( delay );
	self self_func( "scriptModelClearAnim" );
}

windsockLarge()
{
	self self_func( "scriptModelClearAnim" );
	self.origin += ( 0, 0, 20 );
	bounds_1 = spawn( "script_model", self.origin + ( 15, -7, 0 ) );
	bounds_2 = spawn( "script_model", self.origin + ( 70, -38, 0 ) );

	bounds_1 setModel( "com_plasticcase_friendly" );
	bounds_2 setModel( "com_plasticcase_friendly" );

	bounds_1 hide();
	bounds_2 hide();

	bounds_1 CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	bounds_2 CloneBrushmodelToScriptmodel( level.airDropCrateCollision );

	bounds_1 SetContents( 1 );
	bounds_2 SetContents( 1 );

	bounds_1.angles = self.angles + ( 0, 90, 0 );
	bounds_2.angles = bounds_1.angles;

	self linkto( bounds_2 );
	bounds_2 linkto( bounds_1 );
	bounds_1 PhysicsLaunchServer( ( 0, 0, 0 ), ( -400, -250, 10 ) );
}

nukeDeath()
{
	level endon( "game_ended" );
	gameFlagWait( "prematch_done" );

	if ( getDvar( "mapname" ) != "mp_dome" ) return;

	for ( ;; )
	{
		level waittill( "nuke_death" );
		dynamic = getentarray( "dynamic_model", "targetname" );

		for ( i = 0; i < dynamic.size; i++ )
		{
			model_name = dynamic[i].model;

			if ( isSubStr( model_name, "fence_tarp_" ) )
			{
				dynamic[i] thread fenceEffect();
			}

			else if ( model_name == "machinery_windmill" )
			{
				dynamic[i] rotateroll( 80, 2, .5, .1 );
				dynamic[i] thread clearAmim( 1 );
			}

			else if ( isSubStr( model_name, "foliage" ) )
			{
				dynamic[i].origin -= ( 0, 0, 50 );
			}

			else if ( isSubStr( model_name, "oil_pump_jack" ) )
			{
				dynamic[i] self_func( "scriptModelClearAnim" );
			}

			else if ( model_name == "accessories_windsock_large" )
			{
				dynamic[i] thread windsockLarge();
			}
		}

		wait( 5 );
		ents_to_blowup = getentarray( "destructable", "targetname" );
		ents_to_blowup = array_combine( ents_to_blowup, getentarray( "destructible_toy", "targetname" ) );
		ents_to_blowup = array_combine( ents_to_blowup, getentarray( "destructible_vehicle", "targetname" ) );
		ents_to_blowup = array_combine( ents_to_blowup, getentarray( "explodable_barrel", "targetname" ) );

		for ( i = 0; i < ents_to_blowup.size; i++ )
		{
			ents_to_blowup[i] thread maps\mp\_destructables::destructable_destruct();
		}

		level notify( "game_cleanup" );
		print( "Destroyed a lot of stuff" );
	}
}
