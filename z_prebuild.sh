#!/bin/sh
cd raw/
zip -r z_svr_infect.iwd scripts/ maps/
mv z_svr_infect.iwd ../
cd ../
mkdir out/
mv z_svr_infect.iwd out/
