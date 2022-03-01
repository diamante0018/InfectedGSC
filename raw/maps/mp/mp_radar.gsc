// IW5 GSC SOURCE
// Decompiled by https://github.com/xensik/gsc-tool

main()
{
    maps\mp\mp_radar_precache::main();
    maps\createart\mp_radar_art::main();
    maps\mp\mp_radar_fx::main();
    maps\mp\_explosive_barrels::main();
    maps\mp\_load::main();
    ambientplay( "ambient_mp_radar" );
    maps\mp\_compass::setupMiniMap( "compass_map_mp_radar" );
    setdvar( "r_lightGridEnableTweaks", 1 );
    setdvar( "r_lightGridIntensity", 1.33 );
    game["attackers"] = "allies";
    game["defenders"] = "axis";
    audio_settings();
}

audio_settings()
{
    maps\mp\_audio::add_reverb( "default", "mountains", 0.2, 0.9, 2 );
}

_id_4410()
{
    level endon( "game_ended" );
    var_0 = common_scripts\utility::getstruct( "mig_start", "targetname" );
    var_1 = common_scripts\utility::getstruct( "mig_launch", "targetname" );
    var_2 = common_scripts\utility::getstruct( "mig_air1", "targetname" );
    var_3 = common_scripts\utility::getstruct( "mig_end", "targetname" );
    var_4 = distance( var_0.origin, var_1.origin );
    var_5 = distance( var_1.origin, var_2.origin );
    var_6 = distance( var_2.origin, var_3.origin );
    var_7 = vectortoangles( vectornormalize( var_1.origin - var_0.origin ) );
    var_8 = vectortoangles( vectornormalize( var_2.origin - var_1.origin ) );
    var_9 = vectortoangles( vectornormalize( var_3.origin - var_2.origin ) );
    var_10 = spawn( "script_model", var_0.origin );
    var_10 setmodel( "vehicle_mig29_low_mp" );

    for (;;)
    {
        wait(randomintrange( 10, 25 ));
        var_10.origin = var_0.origin;
        var_10.angles = var_7;
        var_10 show();
        playfxontag( level.fx_airstrike_afterburner, var_10, "tag_origin" );
        var_10 playloopsound( "veh_mig29_dist_loop" );
        var_10 moveto( var_1.origin, var_4 / 3000, 1, 0 );
        wait(var_4 / 3000);
        playfxontag( level.fx_airstrike_contrail, var_10, "tag_origin" );
        var_10 rotateto( var_8, 0.5 );
        var_10 moveto( var_2.origin, var_5 / 6000, 0, 0 );
        wait(var_5 / 6000);
        var_10 rotateto( var_9, 0.5 );
        var_10 moveto( var_3.origin, var_6 / 9000, 0, 0 );
        wait(var_6 / 9000);
        stopfxontag( level.fx_airstrike_afterburner, var_10, "tag_origin" );
        stopfxontag( level.fx_airstrike_contrail, var_10, "tag_origin" );
        var_10 hide();
        wait 2;
        var_10 stopsounds();
    }
}
