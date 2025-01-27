trayWidth = 255;
trayHeight = 175;
trayThick = 15;
trayWallThickness = 2;
trayBaseThickness = 2;
trayCornerRadius = 4;
trayHookRadius = 4;

//screws
Screw3MDiameter = 3;

//Tray Holes
holeYFactor = 6;
holeXFactor = holeYFactor*(trayWidth/trayHeight);
holeSize = trayHeight/holeYFactor;

//Tray Guides
guideLength = 20;//Cilinder to Cilinder
guideThick = 5;
guideWidth = 10;//From tray to outside

//Tray Rails
railThickness=3;
railTolerance=2;
railScrewHolderThick=1;
railScrewHolderSide=railThickness*2+Screw3MDiameter*2;

//Tray Spine 
spineWidth = 15;
spineTolerance = 0.25;
spineCylindDiam = 3;

//HookHolder
hookHolderDepth= trayHookRadius*2;
hookHolderHeight= trayHookRadius*2+6;
hookThickness = 1;

//General Params
$fn=40;


module tray () {
    union(){
        _trayStructure();
        
        //Add tray guides
        translate([trayWidth/2+guideWidth/2-0.5, trayHeight/2-guideLength-guideThick/2-trayCornerRadius, trayThick/2-guideThick/2]){
            _trayGuide();
        }
        translate([-trayWidth/2-guideWidth/2+0.5, trayHeight/2-guideLength-guideThick/2-trayCornerRadius, trayThick/2-guideThick/2]){
            _trayGuide();
        }
        
        _trayHook();
    }
    
}


module _trayStructure(){
    union(){
        //Tray base with holes and walls with rounded corners
        translate([0,0,-trayThick/2+trayBaseThickness/2])
        difference(){
            hull(){
                translate([trayWidth/2-trayCornerRadius, trayHeight/2-trayCornerRadius, 0]) cylinder(r=trayCornerRadius, h=trayBaseThickness, center=true);
                translate([-(trayWidth/2-trayCornerRadius), trayHeight/2-trayCornerRadius, 0]) cylinder(r=trayCornerRadius, h=trayBaseThickness, center=true);
                translate([-(trayWidth/2-trayCornerRadius), -(trayHeight/2-trayCornerRadius), 0]) cylinder(r=trayCornerRadius, h=trayBaseThickness, center=true);
                translate([trayWidth/2-trayCornerRadius, -(trayHeight/2-trayCornerRadius), 0]) cylinder(r=trayCornerRadius, h=trayBaseThickness, center=true);
            }
            _trayHoles();
        }
        
        // Tray walls
        difference(){
            hull(){
                translate([trayWidth/2-trayCornerRadius, trayHeight/2-trayCornerRadius, 0]) cylinder(r=trayCornerRadius, h=trayThick, center=true);
                translate([-(trayWidth/2-trayCornerRadius), trayHeight/2-trayCornerRadius, 0]) cylinder(r=trayCornerRadius, h=trayThick, center=true);
                translate([-(trayWidth/2-trayCornerRadius), -(trayHeight/2-trayCornerRadius), 0]) cylinder(r=trayCornerRadius, h=trayThick, center=true);
                translate([trayWidth/2-trayCornerRadius, -(trayHeight/2-trayCornerRadius), 0]) cylinder(r=trayCornerRadius, h=trayThick, center=true);
            }
            hull(){
                translate([trayWidth/2-trayCornerRadius-trayWallThickness, trayHeight/2-trayCornerRadius-trayWallThickness, 0]) cylinder(r=trayCornerRadius, h=trayThick, center=true);
                translate([-(trayWidth/2-trayCornerRadius-trayWallThickness), trayHeight/2-trayCornerRadius-trayWallThickness, 0]) cylinder(r=trayCornerRadius, h=trayThick, center=true);
                translate([-(trayWidth/2-trayCornerRadius-trayWallThickness), -(trayHeight/2-trayCornerRadius-trayWallThickness), 0]) cylinder(r=trayCornerRadius, h=trayThick, center=true);
                translate([trayWidth/2-trayCornerRadius-trayWallThickness, -(trayHeight/2-trayCornerRadius-trayWallThickness), 0]) cylinder(r=trayCornerRadius, h=trayThick, center=true);
            }
            
            //Walls hole for cables
            hull(){
                translate([-trayWidth/3,trayHeight/2-trayWallThickness/2,trayThick/2+trayBaseThickness+2])rotate([90,0,0])cylinder(h=trayWallThickness, d=trayThick*2, center=true);
                translate([trayWidth/3,trayHeight/2-trayWallThickness/2,trayThick/2+trayBaseThickness+2])rotate([90,0,0])cylinder(h=trayWallThickness, d=trayThick*2, center=true);
            }
        }
    }
    
}

module _trayHoles(){
    translate([-holeSize*(holeYFactor*holeXFactor/(holeYFactor+holeXFactor))+trayWidth/trayHeight, 0, 0]){
        union(){
            for(j=[0:1:holeXFactor/2-1]){
                for(i=[0:1:holeYFactor]){
                    translate([holeSize*2*j,holeSize*i-(holeSize*holeYFactor/2), 0]){
                        cylinder(h=trayBaseThickness, d=holeSize, center=true, $fn=6 );
                    }
                    translate([holeSize*(2*j+1),holeSize*i-(holeSize*(holeYFactor/4+1)), 0]){
                        cylinder(h=trayBaseThickness, d=holeSize, center=true, $fn=6 );
                    }
                }
            }
        }
    }
}

module _trayGuide(){
    $fn=40;
    rotate ([90, 0, 90]){
        hull(){
            cylinder(h=guideWidth, d=guideThick, center=true);
            translate([guideLength,0,0]){
                cylinder(h=guideWidth, d=guideThick, center=true);
            }
        }
    }
}

module _trayHook(){
    $fn=40;
    translate([0, -(trayHeight/2+trayHookRadius-trayWallThickness), trayThick/2-trayHookRadius]){
        rotate ([90, 0, 90]){
            difference(){
                union(){
                    cylinder(h=trayWidth-trayCornerRadius*4, r=trayHookRadius, center=true);
                    translate([0,trayHookRadius/2,0])cube([trayHookRadius*2,trayHookRadius,trayWidth-trayCornerRadius*4], center=true);
                }
                translate([0,-trayHookRadius/2,0]){
                    cube([trayHookRadius*2,trayHookRadius,trayWidth-trayCornerRadius*4], center=true);
                    cylinder(h=trayWidth-trayCornerRadius*4, r=trayHookRadius, center=true);
                }
            }
        }
    }
}

/*
 * Hook holder
 *
 */
module hookHolder(){
    difference(){
        cube([trayWidth, hookHolderDepth*2, hookHolderHeight/2+hookThickness*2], center=true);
        translate([0,-hookHolderDepth-hookThickness,-hookThickness]){
            cube([trayWidth, hookHolderDepth*2, hookHolderHeight/2+hookThickness], center=true);
        }
        translate([0,hookHolderDepth+hookThickness,hookThickness+1]){
            cube([trayWidth, hookHolderDepth*2, hookHolderHeight/2+hookThickness], center=true);
        }
        translate([0,hookHolderDepth/2,hookThickness]){
            cube([trayWidth, hookHolderDepth/2, hookHolderHeight/2+hookThickness], center=true);
        }
        translate([-(trayWidth/2-Screw3MDiameter-hookThickness*2),-hookHolderDepth/2,hookHolderHeight/4]){
            cylinder (h=hookThickness*2, d=Screw3MDiameter, center=true, $fn=40);
        }
        translate([trayWidth/2-Screw3MDiameter-hookThickness*2,-hookHolderDepth/2,hookHolderHeight/4]){
            cylinder (h=hookThickness*2, d=Screw3MDiameter, center=true, $fn=40);
        }
    } 
}

/*
 * Tray Rail
 *
 */
module trayRailLeft(){
    $fn=40;
    translate([-railScrewHolderSide/2,trayHeight/2-guideThick-railThickness,guideThick/2+railTolerance+railThickness-railScrewHolderThick]){
        difference(){
            cube([railScrewHolderSide,railScrewHolderSide,railScrewHolderThick], center=true);
            cylinder(h=railScrewHolderThick, d=Screw3MDiameter, center=true);
        }
    }
    translate([-railScrewHolderSide/2,-(trayHeight/2-guideThick-railThickness),guideThick/2+railTolerance+railThickness-railScrewHolderThick]){
        difference(){
            cube([railScrewHolderSide,railScrewHolderSide,railScrewHolderThick], center=true);
            cylinder(h=railScrewHolderThick, d=Screw3MDiameter, center=true);
        }
    }
    rotate([0, 90, 0]){
        difference(){
            union(){
                hull(){
                    translate([0,trayHeight/2,0])cylinder (h=railThickness, d=guideThick+railTolerance+railThickness*2, center=true);
                    translate([0,-trayHeight/2,0])cylinder (h=railThickness, d= guideThick+railTolerance+railThickness*2, center=true);
                }
                hull(){
                    translate([0,trayHeight/2-guideLength,0])cylinder (h=railThickness, d=guideThick+railTolerance+railThickness*2, center=true);
                    translate([0,-trayHeight/2,0])cylinder (h=railThickness, d= guideThick+railTolerance+railThickness*2, center=true);
                    translate([20,-trayHeight/2,0])cylinder (h=railThickness, d= guideThick+railTolerance+railThickness*2, center=true);
                }
            }
            hull(){
                translate([0,trayHeight/2-guideLength,0])cylinder (h=railThickness, d=guideThick+railTolerance, center=true);
                translate([0,-trayHeight/2+5,0])cylinder (h=railThickness, d= guideThick+railTolerance, center=true);
                translate([15,-trayHeight/2+5,0])cylinder (h=railThickness, d= guideThick+railTolerance, center=true);
            }
            hull(){
                translate([0,trayHeight/2,0])cylinder (h=railThickness, d=guideThick+railTolerance, center=true);
                translate([0,-trayHeight/2+5,0])cylinder (h=railThickness, d= guideThick+railTolerance, center=true);
            }
            hull(){
                translate([0,-(trayHeight/2-guideLength*2),0])cylinder (h=railThickness, d=guideThick+railTolerance, center=true);
                translate([20,-trayHeight/2,0])cylinder (h=railThickness, d= guideThick+railTolerance, center=true);
            }
        }
    }
}

module trayRailRight(){
    $fn=40;
    translate([railScrewHolderSide/2,trayHeight/2-guideThick-railThickness,guideThick/2+railTolerance+railThickness-railScrewHolderThick]){
        difference(){
            cube([railScrewHolderSide,railScrewHolderSide,railScrewHolderThick], center=true);
            cylinder(h=railScrewHolderThick, d=Screw3MDiameter, center=true);
        }
    }
    translate([railScrewHolderSide/2,-(trayHeight/2-guideThick-railThickness),guideThick/2+railTolerance+railThickness-railScrewHolderThick]){
        difference(){
            cube([railScrewHolderSide,railScrewHolderSide,railScrewHolderThick], center=true);
            cylinder(h=railScrewHolderThick, d=Screw3MDiameter, center=true);
        }
    }
    rotate([0, 90, 0]){
        difference(){
            union(){
                hull(){
                    translate([0,trayHeight/2,0])cylinder (h=railThickness, d=guideThick+railTolerance+railThickness*2, center=true);
                    translate([0,-trayHeight/2,0])cylinder (h=railThickness, d= guideThick+railTolerance+railThickness*2, center=true);
                }
                hull(){
                    translate([0,trayHeight/2-guideLength,0])cylinder (h=railThickness, d=guideThick+railTolerance+railThickness*2, center=true);
                    translate([0,-trayHeight/2,0])cylinder (h=railThickness, d= guideThick+railTolerance+railThickness*2, center=true);
                    translate([20,-trayHeight/2,0])cylinder (h=railThickness, d= guideThick+railTolerance+railThickness*2, center=true);
                }
            }
            hull(){
                translate([0,trayHeight/2-guideLength,0])cylinder (h=railThickness, d=guideThick+railTolerance, center=true);
                translate([0,-trayHeight/2+8,0])cylinder (h=railThickness, d= guideThick+railTolerance, center=true);
                translate([15,-trayHeight/2+8,0])cylinder (h=railThickness, d= guideThick+railTolerance, center=true);
            }
            hull(){
                translate([0,trayHeight/2,0])cylinder (h=railThickness, d=guideThick+railTolerance, center=true);
                translate([0,-trayHeight/2+10,0])cylinder (h=railThickness, d= guideThick+railTolerance, center=true);
            }
            hull(){
                translate([0,-(trayHeight/2-guideLength*2),0])cylinder (h=railThickness, d=guideThick+railTolerance, center=true);
                translate([20,-trayHeight/2,0])cylinder (h=railThickness, d= guideThick+railTolerance, center=true);
            }
        }
    }
}



/*
 * Close tray
 *
*/
tray();

/*
 * Open tray
translate([0,-trayHeight+guideLength+14,-45]){
    rotate([25,0,0]){
        tray();
    }
}
*/

/*
translate([0,-trayHeight/2-10,trayThick/2-trayHookRadius/2+0.5]){
    hookHolder();
}

translate([-trayWidth/2-guideWidth/2,0,trayThick/2-guideThick/2]){
    trayRailLeft();
}
translate([trayWidth/2+guideWidth/2,0,trayThick/2-guideThick/2]){
    trayRailRight();
}
*/

/*
 * Table
 *
translate([0,0,18])
cube([300, 220, 10], center=true);
 */
 


/*
//Spine Rigth
union(){
    difference(){
        translate([spineWidth/2,0,-6.5]){
            cube([spineWidth-spineTolerance,trayHeight,trayBaseThickness], center=true);
        }
        translate([spineWidth/2,-(trayHeight/4-spineTolerance/2),-6.5-trayBaseThickness/4]){
            cube([spineWidth,trayHeight/2+spineTolerance,trayBaseThickness/2], center=true);
        }
    }
    //Pins
    for(i=[1:1:3]){
        translate([spineWidth/2,-trayHeight*i/8,-6.5-trayBaseThickness/4]){
            cylinder(d=spineCylindDiam-spineTolerance, h=trayBaseThickness/2, center=true);
        }
    }
    
    difference(){
        translate([-(spineWidth/2-spineTolerance),trayHeight/4+spineTolerance/2,-6.5-trayBaseThickness/4]){
            cube([spineWidth-spineTolerance,trayHeight/2-spineTolerance,trayBaseThickness/2], center=true);
        }
        //Holes
        for(i=[1:1:3]){
            translate([-spineWidth/2,trayHeight*i/8,-6.5-trayBaseThickness/4]){
                cylinder(d=spineCylindDiam+spineTolerance, h=trayBaseThickness/2, center=true);
            }
        }
    }
}


//Spine Left
union(){
    difference(){
        translate([-spineWidth/2,0,-6.5]){
            cube([spineWidth-spineTolerance,trayHeight,trayBaseThickness], center=true);
        }
        translate([-spineWidth/2,trayHeight/4-spineTolerance/2,-6.5-trayBaseThickness/4]){
            cube([spineWidth,trayHeight/2+spineTolerance,trayBaseThickness/2], center=true);
        }
    }
    //Pins
    for(i=[1:1:3]){
        translate([-spineWidth/2,trayHeight*i/8,-6.5-trayBaseThickness/4]){
            cylinder(d=spineCylindDiam-spineTolerance, h=trayBaseThickness/2, center=true);
        }
    }
    
    difference(){
        translate([spineWidth/2-spineTolerance,-(trayHeight/4+spineTolerance/2),-6.5-trayBaseThickness/4]){
            cube([spineWidth-spineTolerance,trayHeight/2-spineTolerance,trayBaseThickness/2], center=true);
        }
        //Holes
        for(i=[1:1:3]){
            translate([spineWidth/2,-trayHeight*i/8,-6.5-trayBaseThickness/4]){
                cylinder(d=spineCylindDiam+spineTolerance, h=trayBaseThickness/2, center=true);
            }
        }
    }
}
*/