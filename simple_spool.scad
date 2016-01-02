/* [Basic Settings] */

part = "assembly"; // [hub:Hub,arm:Arm,guidehub:Guide Hub,guidearm1:Guide Arm 1,guidearm2:Guide Arm 2,assembly:Assembly]

// Primary radius of the spool.
radius = 100;

// Length of the fingers holding the filament.
cage_depth = 40;

// Width of the filament slot.
cage_width = 15;

// Radius of the hole at the centre of the hub, 11mm matches an LM8UU roller-skate bearing.
shaft_radius = 4.5;

// Thickness of the arms.
arm_thickness = 5;

// Thickness of the hub. 7mm matches a roller-skate bearing.
hub_thickness = 8;

// The width of the arms
width = 6;

// Size of your filament, for the retaining holes
filament_diameter = 3.2;

// Size of the filament guide tube, or zero if not using a tube
filament_guide_diameter = 7;

/* [Advanced Settings] */

// Radius of the hub at the centre
hub_radius = 40;

// Size of the arm-click key
key_size=2;

// Extra space to add around joints to allow for your printer's tolerances
join_clearance = 0.25;


/* [Printer] */
build_plate_selector = 3; //[0:Replicator 2,1: Replicator,2:Thingomatic,3:Manual]

//when Build Plate Selector is set to "manual" this controls the build plate x dimension
build_plate_manual_x = 200; //[100:400]

//when Build Plate Selector is set to "manual" this controls the build plate y dimension
build_plate_manual_y = 200; //[100:400]

/* [Hidden] */

slot_depth = hub_radius/3;
slot_start = hub_radius-slot_depth;
slot_overlap = slot_depth;

hub_arm_positions = [0, 120, 240];
guide_arm_positions = [0, 90];

// Jitter, used to prevent coincident-surface problems. Should be less than layer-thickness.
j=0.05;
j2 = j*2;
x = 0; y = 1; z = 2;
$fn = 80;

use<utils/build_plate.scad>;


module HubArm()
{
	roundness = 5;

	difference()
	{
		hull()
		{
			// The centre
			cylinder(r = hub_radius/3-j2, h = hub_thickness);

			// The end of the arm
			translate([hub_radius - roundness, 0, 0])
			cylinder(r = roundness, h = hub_thickness);
		}

		// The centre
		translate([0, 0, -j])
		cylinder(r = hub_radius/3-j, h = hub_thickness+j2);
		
		// Slot for the arm
		translate([slot_start-join_clearance, -arm_thickness/2-join_clearance, -j])
		cube([slot_depth+join_clearance+j, arm_thickness+join_clearance*2, hub_thickness+j2]);
	}
}

module HubCentre()
{
	difference()
	{
		union()
		{
			// The centre of the hub
			cylinder(r = hub_radius/2, h = hub_thickness);
		}
		
		// The hole for the shaft
		translate([0, 0, -j])
		cylinder(r = shaft_radius, h = hub_thickness + j2);
		
		// Chamfer the shaft hole a bit to make it easier to insert a bearing
		translate([0, 0, hub_thickness * 0.8])
		cylinder(r1 = shaft_radius, r2 = shaft_radius * 1.1, h = hub_thickness * 0.2 + j);
		
	}
}

module Hub(angles = [])
{	
	difference()
	{
		union()
		{
			// The centre of the hub
			HubCentre();

			// The ends of the arms
			for(i = angles)
			{
				rotate([0, 0, i])
				HubArm();				
			}
		}
		
		// The arm-click slots
		for(i = angles)
		{
			rotate([0, 0, i])
			translate([hub_radius-slot_overlap-slot_depth+key_size, 0, hub_thickness])
			rotate([90, 0, 0])
			cylinder(r=key_size+join_clearance, h = arm_thickness+1, center=true);
		}
		
	}
}

module GuideHub()
{
	union()
	{
		Hub(guide_arm_positions);
	}
}

module ArmClip()
{
	roundness = width;
	union()
	{
		difference()
		{
			union()
			{
				// Fatten up the clip end a bit
				hull()
				{
					translate([-slot_overlap+1, -hub_thickness/2-width, 0])
					cylinder(r = 1, h = arm_thickness);
					
					translate([-slot_overlap+1, hub_thickness/2+width, 0])
					cylinder(r = 1, h = arm_thickness);

					translate([width/2, -hub_thickness/2-width, 0])
					cylinder(r = 1, h = arm_thickness);
					
					translate([width/2, hub_thickness/2+width, 0])
					cylinder(r = 1, h = arm_thickness);

					translate([slot_overlap, -width/2, 0])
					cube([j, width, arm_thickness]);
				}
			}
			
			// Slot
			translate([-slot_overlap-j, -hub_thickness/2-join_clearance, -j])
			cube([slot_overlap+j, hub_thickness + join_clearance*2, arm_thickness+j2]);

		}
		
		// Slot key
		translate([-slot_overlap+key_size, hub_thickness/2+join_clearance, 0])
		scale([1, 0.75, 1])
		cylinder(r=key_size, h = arm_thickness);
		
	}
}

module Arm(length)
{
	union()
	{
		// Arm
		translate([0, -width/2, 0])
		cube([length+j, width, arm_thickness]);				
	}
}

module FilamentCage()
{
	roundness = width;
	
	cage_start = [0, 0, 0];
	
	finger_base1 = [
		roundness/2,
		-(width+cage_width+width)/2+roundness/2, 
		0
	];
	
	finger_base2 = [
		roundness/2, 
		cage_width/2 + roundness/2, 
		0
	];
	
	finger_tip1	= [
		cage_depth-roundness/2,
		-(width+cage_width+width)/2+roundness/2, 
		0
	];

	finger_tip2	= [
		cage_depth-roundness/2,
		(width+cage_width+width)/2-roundness/2, 
		0
	];
	
	translate([-width, 0, 0])
	difference()
	{
		union()
		{
			// Arm to base of finger
			hull()
			{
				translate(cage_start)
				cylinder(r = roundness/2, h = arm_thickness);
				
				translate(finger_base1)
				cylinder(r = roundness/2, h = arm_thickness);
				
				translate(finger_base2)
				cylinder(r = roundness/2, h = arm_thickness);
			}
			
			// Base of fingers
			hull()
			{
				translate(finger_base1)
				cylinder(r = roundness/2, h = arm_thickness);

				translate(finger_base2)
				cylinder(r = roundness/2, h = arm_thickness);
			}
			
			// Finger 1
			hull()
			{
				translate(finger_base1)
				cylinder(r = roundness/2, h = arm_thickness);

				translate(finger_tip1)
				cylinder(r = roundness/2, h = arm_thickness);
			}
			hull()
			{
				translate(finger_tip1)
				cylinder(r = roundness/2, h = arm_thickness);
				translate(finger_tip1+[arm_thickness, -arm_thickness, 0])
				cylinder(r = roundness/2, h = arm_thickness);
			}
			
			// Finger 2
			hull()
			{
				translate(finger_base2)
				cylinder(r = roundness/2, h = arm_thickness);

				translate(finger_tip2)
				cylinder(r = roundness/2, h = arm_thickness);
			}
			hull()
			{
				translate(finger_tip2)
				cylinder(r = roundness/2, h = arm_thickness);
				translate(finger_tip2+[arm_thickness, arm_thickness, 0])
				cylinder(r = roundness/2, h = arm_thickness);
			}
		}

		// Round the bottom of the fingers a bit
		translate([width, 0, -j])
		scale([0.3, 1, 1]) 
		cylinder(r = cage_width/2, h = arm_thickness+j2);

		// Filament clip hole
		translate(finger_tip1+[arm_thickness, -arm_thickness, -j])
		cylinder(r = filament_diameter/2, h = arm_thickness+j2);
	}
}

module CageArm()
{
	union()
	{
		ArmClip();

		translate([slot_overlap, 0, 0])
		difference()
		{
			union()
			{
				Arm(radius-hub_radius-width/3);

				translate([radius-hub_radius, 0, 0])
				FilamentCage();
			}
			
			// Filament start hole on finger
			translate([radius-hub_radius-width, 0, -j])
			cylinder(r = filament_diameter/2, h = arm_thickness+j2);
		}
	}
}

module FilamentEntryGuide()
{
	major_radius = filament_diameter*2;
	torus_minor_radius = (major_radius - (filament_diameter/2))/2;
	torus_major_radius = filament_diameter/2 + torus_minor_radius;
	
	translate([filament_diameter, 0, 0])
	difference()
	{
		union()
		{
			cylinder(r = major_radius, h = hub_thickness);
			
			translate([0, 0, hub_thickness])
			rotate_extrude(convexity = 10)
			translate([torus_major_radius, 0, 0])
			circle(r = torus_minor_radius);
		}
		
		// Main hole
		translate([0, 0, -j])
		cylinder(r = filament_diameter/2, h = hub_thickness+j2);
		
		// Socket for filament-guide
		if(filament_guide_diameter > 0)
		{
			translate([0, 0, -j])
			cylinder(r = filament_guide_diameter/2, h=hub_thickness/3);

			translate([0, 0, hub_thickness/3-j2])
			cylinder(r1 = filament_guide_diameter/2, r2 = filament_diameter/2, h=hub_thickness/3);
		}
	}
}

module FilamentGuide()
{
	guide_radius = (filament_guide_diameter == 0 ? filament_diameter : filament_guide_diameter)/2;
	guide_height = hub_thickness;

	major_radius = filament_diameter*2.5;
	torus_minor_radius = (major_radius - (guide_radius))/2;
	torus_major_radius = guide_radius + torus_minor_radius;
	
	translate([major_radius-(major_radius - guide_radius*1.5)+j, 0, 0])
	difference()
	{
		cylinder(r = major_radius, h = guide_height);
		
		// Main hole
		translate([0, 0, -j])
		cylinder(r = guide_radius, h = guide_height+j2);
		
		// Chamfer in
		translate([0, 0, -j])
		cylinder(r1 = guide_radius*1.5, r2 = guide_radius, h = guide_height/3);
		
		// Chamfer out
		translate([0, 0, 2*guide_height/3])
		cylinder(r1 = guide_radius, r2 = guide_radius*1.5, h = guide_height/3+j);
	}
}

module GuideEntryArm()
{
	union()
	{
		ArmClip();
		
		translate([slot_overlap, 0, 0])
		Arm(radius-slot_start+slot_overlap);
		
		translate([radius, 0, 0])
		FilamentEntryGuide();
	}
}

module GuideArm()
{
	union()
	{
		ArmClip();
		
		translate([slot_overlap, 0, 0])
		Arm(radius-slot_start+slot_overlap);
		
		translate([radius, 0, 0])
		FilamentGuide();
	}
}

if(part == "assembly")
{
	color("maroon")
	translate([0, 0, -hub_thickness/2])
	Hub(hub_arm_positions);

	color("orange")
	for(i = hub_arm_positions)
	{
		rotate([90, 0, i])
		translate([slot_start, 0, -arm_thickness/2]) 
		CageArm();
	}
	
	// The Filament-guide assembly
	translate([0, 0, -cage_width*2])
	union()
	{
		color("green")
		translate([0, 0, -hub_thickness/2])
		GuideHub();

		rotate([90, 0, guide_arm_positions[0]])
		translate([slot_start, 0, -arm_thickness/2]) 
		GuideEntryArm();

		rotate([90, 0, guide_arm_positions[1]])
		translate([slot_start, 0, -arm_thickness/2]) 
		GuideArm();
		
	}

	%cylinder(r = 4, h = 1000, center = true); // axle
	
	%cylinder(r = radius, h = 1, center = true);
	%cylinder(r = hub_radius, h = 1.5, center = true);
}
else
{
	if(part == "hub")
	{
		!Hub(hub_arm_positions);
	}
	if(part == "arm")
	{
		translate([-(radius+cage_depth-slot_start)/2, 0, 0])
		CageArm();
	}
	if(part == "guidehub")
	{
		Hub(guide_arm_positions);
	}
	if(part == "guidearm1")
	{
		translate([-(radius+cage_depth-slot_start)/2, 0, 0])
		GuideEntryArm();
	}
	if(part == "guidearm2")
	{
		translate([-(radius+cage_depth-slot_start)/2, 0, 0])
		GuideArm();
	}

	//%build_plate(build_plate_selector, build_plate_manual_x, build_plate_manual_y);
}