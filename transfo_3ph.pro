/* ===================================================================
   3-Phase Transformer - FINAL COMPLETE MODEL
   =================================================================== */

Include "transfo_common_3ph.pro";

DefineConstant[
  // --- 1. ANALYSIS CONTROL ---
  TestMode = {0, Choices{0="Nominal Load", 1="Open Circuit", 2="Short Circuit"}, 
              Name "01 Analysis/01 Test Mode", Highlight "Blue"},
  
  Harmonic = {1, Name "01 Analysis/02 Harmonic Order", Min 1, Max 50},
  
  // --- 2. PHYSICS SETTINGS ---
  CoilType = {0, Choices{0="Stranded (Wire)", 1="Massive (Solid Bar)"}, 
              Name "02 Coil Physics/01 Conductor Type"},
              
  LoadType = {0, Choices{0="Resistive", 1="Inductive", 2="Capacitive"}, 
              Name "03 Load Physics/01 Load Type", Visible (TestMode==0)},

  // --- 3. DESIGN PARAMETERS ---
  Freq_Fund = {50, Name "Design/Fundamental Frequency"},
  S_nom = {200e3, Name "Design/Nominal Power [VA]"},
  V_HV_nom = {2400, Name "Design/HV Voltage [V]"},
  V_LV_nom = {240,  Name "Design/LV Voltage [V]"},
  V_OC_ratio = {1, Name "Design/Test Voltage Scale (OC)", Min 0, Max 1},
  V_SC_ratio = {0.1, Name "Design/Test Voltage Scale (SC)", Min 0, Max 1},
  R_series_HV = {0.5, Name "Design/HV Series Resistance [Ohm]", Min 1e-3, Max 10},
  
  // --- 4. GEOMETRY ---
  width_Coil_1 = {0.10, Name "Design/Coil Width [m]"},
  height_Coil_1 = {0.25, Name "Design/Coil Height [m]"},
  k_fill = {0.6, Name "Design/Coil Fill Factor"},

  // --- 5. MATERIAL DATA ---
  k_core = {1.5, Name "Material/Core Loss k"},
  rho_Cu = {1.72e-8, Name "Material/Copper Resistivity"},
  mur_Core = {1000, Name "Material/Core Permeability"},
  Flag_AirGap = {0, Choices{0,1}, Name "Parameters/AirGap?"}
];

Function {
  Freq = Freq_Fund * Harmonic; 
  I_HV_nom = S_nom / (Sqrt[3] * V_HV_nom);
  I_LV_nom = S_nom / (Sqrt[3] * V_LV_nom);
  
  Z_base = V_LV_nom / I_LV_nom;
  val_Load = (TestMode == 0) ? Z_base : ((TestMode == 1) ? 1e9 : 1e-6); 
  mu0 = 4 * Pi * 10^-7;
  V_src = V_HV_nom;
  If(TestMode == 1)
    V_src = V_HV_nom * V_OC_ratio;
  ElseIf(TestMode == 2)
    V_src = V_HV_nom * V_SC_ratio;
  EndIf

  // Material Properties
  mu[Region[{1001, 1011}]] = mu0; // Air
  mu[Region[{1050}]] = mur_Core * mu0; // Core
  mu[Region[{1101, 1102, 1201, 1202, 1301, 1302, 1111, 1112, 1211, 1212, 1311, 1312}]] = mu0;
  If(Flag_AirGap) mu[Region[100000]] = mu0; EndIf

  // Winding Definition
  Ns_HV = (CoilType == 0) ? 440 : 1; 
  Ns_LV = (CoilType == 0) ? 44 : 1;

  Ns[Region[{1101, 1102, 1201, 1202, 1301, 1302}]] = Ns_LV;
  sigma[Region[{1101, 1102, 1201, 1202, 1301, 1302}]] = 1/rho_Cu;
  
  Ns[Region[{1111, 1112, 1211, 1212, 1311, 1312}]] = Ns_HV;
  sigma[Region[{1111, 1112, 1211, 1212, 1311, 1312}]] = 1/rho_Cu;
  
  // Non-conducting regions
  sigma[Region[{1001, 1011, 1050}]] = 0;

  // Geometry Factors
  Sc[Region[{1101, 1102, 1201, 1202, 1301, 1302}]] = k_fill * width_Coil_1 * height_Coil_1; 
  Sc[Region[{1111, 1112, 1211, 1212, 1311, 1312}]] = k_fill * width_Coil_1 * height_Coil_1;

  nu[] = 1/mu[];
  CoefGeos[] = thickness_Core; 
  CoefGeo = thickness_Core;
  
  // Source Vectors (Geometry Check)
  js0[Region[{1001, 1011, 1050}]] = Vector[0,0,0];
  js0[Region[{1101, 1102, 1201, 1202, 1301, 1302, 1111, 1112, 1211, 1212, 1311, 1312}]] = Vector[0,0,1];
}

Group {
  // --- ROBUST GROUPS ---
  DefineGroup[Air, Core, Coils, Coils_LV, Coils_HV, Vol_Mag, Vol_S_Mag, Vol_C_Mag, AirGapRegion, Sur_Air_Ext];

  Core = Region[1050];
  Air = Region[{1001, 1011}]; 
  Sur_Air_Ext = Region[1002];
  AirGapRegion = Region[100000]; 

  Coil_1_LV_P = Region[1101];  Coil_1_LV_M = Region[1102];
  Coil_1_HV_P = Region[1111];  Coil_1_HV_M = Region[1112];
  Coil_2_LV_P = Region[1201];  Coil_2_LV_M = Region[1202];
  Coil_2_HV_P = Region[1211];  Coil_2_HV_M = Region[1212];
  Coil_3_LV_P = Region[1301];  Coil_3_LV_M = Region[1302];
  Coil_3_HV_P = Region[1311];  Coil_3_HV_M = Region[1312];

  Coils_LV = Region[{Coil_1_LV_P, Coil_1_LV_M, Coil_2_LV_P, Coil_2_LV_M, Coil_3_LV_P, Coil_3_LV_M}];
  Coils_HV = Region[{Coil_1_HV_P, Coil_1_HV_M, Coil_2_HV_P, Coil_2_HV_M, Coil_3_HV_P, Coil_3_HV_M}];
  Coils    = Region[{Coils_LV, Coils_HV}];

  Vol_Mag = Region[{Air, Core, Coils, AirGapRegion}];

  If(CoilType == 0) // Stranded
    Vol_S_Mag = Region[{Coils}];
    Vol_C_Mag = Region[{}];
  Else // Massive
    Vol_S_Mag = Region[{}];
    Vol_C_Mag = Region[{Coils}];
  EndIf
}

Flag_CircuitCoupling = 1;

Group {
  Resistance_Cir  = Region[{}];
  Inductance_Cir  = Region[{}];
  Capacitance_Cir = Region[{}];
  SourceV_Cir     = Region[{}];
  
  E_in_1 = Region[20001]; SourceV_Cir += Region[{E_in_1}]; 
  R_in_1 = Region[20002]; Resistance_Cir += Region[{R_in_1}]; 
  R_out_1 = Region[20101]; 

  E_in_2 = Region[20003]; SourceV_Cir += Region[{E_in_2}]; 
  R_in_2 = Region[20004]; Resistance_Cir += Region[{R_in_2}]; 
  R_out_2 = Region[20102];

  E_in_3 = Region[20005]; SourceV_Cir += Region[{E_in_3}]; 
  R_in_3 = Region[20006]; Resistance_Cir += Region[{R_in_3}]; 
  R_out_3 = Region[20103];
  
  If(LoadType == 0) // Resistive
      Resistance_Cir += Region[{R_out_1, R_out_2, R_out_3}];
  ElseIf(LoadType == 1) // Inductive
      Inductance_Cir += Region[{R_out_1, R_out_2, R_out_3}];
  ElseIf(LoadType == 2) // Capacitive
      Capacitance_Cir += Region[{R_out_1, R_out_2, R_out_3}];
  EndIf
}

Function {
  deg = Pi/180;
  val_R = val_Load;
  val_L = val_Load / (2*Pi*Freq);
  val_C = 1 / (2*Pi*Freq*val_Load);

  Resistance[Region[{R_out_1, R_out_2, R_out_3}]] = val_R; 
  Inductance[Region[{R_out_1, R_out_2, R_out_3}]] = val_L;
  Capacitance[Region[{R_out_1, R_out_2, R_out_3}]] = val_C;
  Resistance[Region[{R_in_1, R_in_2, R_in_3}]] = R_series_HV; // Stabilize circuit with realistic winding resistance
  phase_1 = 0; phase_2 = -120 * deg; phase_3 = 120 * deg;
}

Constraint {
  { Name MagneticVectorPotential_2D; Case { { Region Sur_Air_Ext; Value 0; } } }
  { Name Current_2D; Case {} }
  { Name Voltage_2D; Case {} }
  { Name Current_Cir; Case {} }
  
  { Name Voltage_Cir;
    Case {
      { Region E_in_1; Value V_src; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, phase_1}; }
      { Region E_in_2; Value V_src; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, phase_2}; }
      { Region E_in_3; Value V_src; TimeFunction F_Cos_wt_p[]{2*Pi*Freq, phase_3}; }
    }
  }
  { Name ElectricalCircuit; Type Network;
    Case Circuit_HV_1 { { Region E_in_1; Branch {1,2}; } { Region R_in_1; Branch {2,3}; } { Region Coil_1_HV_P; Branch {3,4}; } { Region Coil_1_HV_M; Branch {4,1}; } }
    Case Circuit_HV_2 { { Region E_in_2; Branch {5,6}; } { Region R_in_2; Branch {6,7}; } { Region Coil_2_HV_P; Branch {7,8}; } { Region Coil_2_HV_M; Branch {8,5}; } }
    Case Circuit_HV_3 { { Region E_in_3; Branch {9,10}; } { Region R_in_3; Branch {10,11}; } { Region Coil_3_HV_P; Branch {11,12}; } { Region Coil_3_HV_M; Branch {12,9}; } }
    
    Case Circuit_LV_1 { { Region R_out_1 ; Branch {19,20}; } { Region Coil_1_LV_P; Branch {20,21}; } { Region Coil_1_LV_M; Branch {21,19}; } }
    Case Circuit_LV_2 { { Region R_out_2; Branch {25,26}; } { Region Coil_2_LV_P; Branch {26,27}; } { Region Coil_2_LV_M; Branch {27,25}; } }
    Case Circuit_LV_3 { { Region R_out_3; Branch {29,30}; } { Region Coil_3_LV_P; Branch {30,31}; } { Region Coil_3_LV_M; Branch {31,29}; } }
  }
}

Include "Lib_Magnetodynamics2D_av_Cir_3ph.pro";

Integration {
  { Name I_Post ; Case { { Type Gauss ; Case { { GeoElement Triangle ; NumberOfPoints 4 ; } { GeoElement Quadrangle ; NumberOfPoints 4 ; } } } } }
}

// --- 6. SAFE POST-PROCESSING ---
PostProcessing {
  { Name Design_Results; NameOfFormulation Magnetodynamics2D_av;
    Quantity {
      // --- 1. Fields ---
      { Name Az_field; Value { Term { [ {a} ]; In Vol_Mag; Jacobian Vol; } } }
      { Name B_field; Value { Term { [ {d a} ]; In Vol_Mag; Jacobian Vol; } } }
      
      // SATURATION CHECK: Magnitude of B
      { Name B_Magnitude; Value { Term { [ Norm[{d a}] ]; In Vol_Mag; Jacobian Vol; } } }

      // --- 2. Current Density (J) ---
      { Name J_Physics_SkinEffect; Value { Term { [ -sigma[] * Dt[{a}] ]; In Coils; Jacobian Vol; } } }

      // Map B: Source Geometry. Valid for STRANDED mode (shows where current is).
      { Name J_Geometry_Source;    Value { Term { [ js0[] ]; In Coils; Jacobian Vol; } } }

      // --- 3. LOSSES ---
      { Name Core_Loss_Watts; Value { Integral { [ k_core * SquNorm[{d a}] ]; In Core; Jacobian Vol; Integration I_Post; } } }
      
      // Massive Coil Loss (Calculated here)
      { Name Joule_Loss_Massive; Value { Integral { [ sigma[] * SquNorm[ Dt[{a}] ] ]; In Coils; Jacobian Vol; Integration I_Post; } } }
      
      // --- 4. Energy ---
      { Name Energy_Mag; Value { Integral { [ 0.5 * {d a} * ({d a} * nu[]) ]; In Vol_Mag; Jacobian Vol; Integration I_Post; } } }
    }
  }
}

PostOperation {
  { Name dyn; NameOfPostProcessing Magnetodynamics2D_av;
    Operation {
      Print[ j, OnElementsOf Region[{Vol_C_Mag, Vol_S_Mag}], Format Gmsh, File "j.pos" ];
      Print[ b, OnElementsOf Vol_Mag, Format Gmsh, File "b.pos" ];
      Print[ az, OnElementsOf Vol_Mag, Format Gmsh, File "az.pos" ];
      
      If (Flag_FrequencyDomain)
        Echo[ "Results UI", Format Table, File "UI.txt" ];
        
        // Phase 1
        Echo[ "Phase 1 Primary (E_in_1)", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion E_in_1, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion E_in_1, Format FrequencyTable, File > "UI.txt"];
        Echo[ "Phase 1 Secondary (R_out_1)", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion R_out_1, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion R_out_1, Format FrequencyTable, File > "UI.txt"];

        // Phase 2
        Echo[ "Phase 2 Primary (E_in_2)", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion E_in_2, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion E_in_2, Format FrequencyTable, File > "UI.txt"];
        Echo[ "Phase 2 Secondary (R_out_2)", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion R_out_2, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion R_out_2, Format FrequencyTable, File > "UI.txt"];

        // Phase 3
        Echo[ "Phase 3 Primary (E_in_3)", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion E_in_3, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion E_in_3, Format FrequencyTable, File > "UI.txt"];
        Echo[ "Phase 3 Secondary (R_out_3)", Format Table, File > "UI.txt" ];
        Print[ U, OnRegion R_out_3, Format FrequencyTable, File > "UI.txt" ];
        Print[ I, OnRegion R_out_3, Format FrequencyTable, File > "UI.txt"];
      EndIf
    }
  }
}
