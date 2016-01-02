@ECHO OFF

:: If you don't have the openscad.com executable in your PATH, you need to set the full location to it here:
SET OPENSCAD="C:\Program Files\OpenSCAD\openscad"

:: Screenshots for documentation
%OPENSCAD% -D "part=""hub"""       --imgsize=500,300 --render -o hub.png simple_spool.scad
%OPENSCAD% -D "part=""arm"""       --imgsize=500,300 --render -o arm.png simple_spool.scad
%OPENSCAD% -D "part=""guidehub"""  --imgsize=500,300 --render -o guide_hub.png simple_spool.scad
%OPENSCAD% -D "part=""guidearm1""" --imgsize=500,300 --render -o guide_arm1.png simple_spool.scad
%OPENSCAD% -D "part=""guidearm2""" --imgsize=500,300 --render -o guide_arm2.png simple_spool.scad

:: STLs of individual parts
%OPENSCAD% -D "part=""hub"""       -o hub.stl simple_spool.scad
%OPENSCAD% -D "part=""arm"""       -o arm.stl simple_spool.scad
%OPENSCAD% -D "part=""guidehub"""  -o guide_hub.stl simple_spool.scad
%OPENSCAD% -D "part=""guidearm1""" -o guide_arm1.stl simple_spool.scad
%OPENSCAD% -D "part=""guidearm2""" -o guide_arm2.stl simple_spool.scad


:END