Include "transfo_common_3ph.pro";

Solver.AutoShowLastStep = 0; // don't automatically show the last time step

//==================================================================
// 2. CORE (Unchanged)
//==================================================================
// 12 points for the 3-legged core
p_Leg_1_L_0=newp; Point(newp) = {-width_Core_3ph/2., 0, 0, c_Core};
p_Leg_1_R_0=newp; Point(newp) = {-width_Core_3ph/2.+width_Core_Leg, 0, 0, c_Core};
p_Leg_1_L_1=newp; Point(newp) = {-width_Core_3ph/2., y_yoke_top, 0, c_Core};
p_Leg_1_R_1=newp; Point(newp) = {-width_Core_3ph/2.+width_Core_Leg, y_yoke_bottom, 0, c_Core};
p_Leg_2_L_0=newp; Point(newp) = {-width_Core_Leg_Mid/2., 0, 0, c_Core};
p_Leg_2_R_0=newp; Point(newp) = {width_Core_Leg_Mid/2., 0, 0, c_Core};
p_Leg_2_L_1=newp; Point(newp) = {-width_Core_Leg_Mid/2., y_yoke_bottom, 0, c_Core};
p_Leg_2_R_1=newp; Point(newp) = {width_Core_Leg_Mid/2., y_yoke_bottom, 0, c_Core};
p_Leg_3_L_0=newp; Point(newp) = {width_Core_3ph/2.-width_Core_Leg, 0, 0, c_Core};
p_Leg_3_R_0=newp; Point(newp) = {width_Core_3ph/2., 0, 0, c_Core};
p_Leg_3_L_1=newp; Point(newp) = {width_Core_3ph/2.-width_Core_Leg, y_yoke_bottom, 0, c_Core};
p_Leg_3_R_1=newp; Point(newp) = {width_Core_3ph/2., y_yoke_top, 0, c_Core};
// --- Core Line Definitions ---
l_Core_In_L_1=newl; Line(newl) = {p_Leg_1_R_0, p_Leg_1_R_1};
l_Core_In_L_2=newl; Line(newl) = {p_Leg_1_R_1, p_Leg_2_L_1};
l_Core_In_L_3=newl; Line(newl) = {p_Leg_2_L_1, p_Leg_2_L_0};
l_Core_In_R_1=newl; Line(newl) = {p_Leg_2_R_0, p_Leg_2_R_1};
l_Core_In_R_2=newl; Line(newl) = {p_Leg_2_R_1, p_Leg_3_L_1};
l_Core_In_R_3=newl; Line(newl) = {p_Leg_3_L_1, p_Leg_3_L_0};
l_Core_Out_1=newl; Line(newl) = {p_Leg_3_R_0, p_Leg_3_R_1};
l_Core_Out_2=newl; Line(newl) = {p_Leg_3_R_1, p_Leg_1_L_1}; // Top Yoke
l_Core_Out_3=newl; Line(newl) = {p_Leg_1_L_1, p_Leg_1_L_0};
l_Core_Y0_1=newl; Line(newl) = {p_Leg_1_L_0, p_Leg_1_R_0};
l_Core_Y0_2=newl; Line(newl) = {p_Leg_2_L_0, p_Leg_2_R_0};
l_Core_Y0_3=newl; Line(newl) = {p_Leg_3_L_0, p_Leg_3_R_0};
// --- Core Surface (Unchanged) ---
ll_Core=newll; Curve Loop(newll) = {
  l_Core_In_L_1, l_Core_In_L_2, l_Core_In_L_3,  // Path along Window 1
  l_Core_Y0_2,                                // Path along bottom of Leg 2
  l_Core_In_R_1, l_Core_In_R_2, l_Core_In_R_3,  // Path along Window 2
  l_Core_Y0_3,                                // Path along bottom of Leg 3
  l_Core_Out_1, l_Core_Out_2, l_Core_Out_3,   // Outer path
  l_Core_Y0_1                                 // Path along bottom of Leg 1 (closes loop)
};
s_Core=news; Plane Surface(news) = {ll_Core};
Physical Surface("CORE", CORE) = {s_Core};

//==================================================================
// 3. COILS (NOW 12 TOTAL)
//==================================================================

// --- LEG 1 COILS (LV and HV) ---
// COIL_1_PLUS (LV)
x_[]=Point{p_Leg_1_R_0};
p_C1p_LV_i0=newp; Point(newp) = {x_[0]+gap_Core_Coil_1, 0, 0, c_Coil_1};
p_C1p_LV_e0=newp; Point(newp) = {x_[0]+gap_Core_Coil_1+width_Coil_1/2, 0, 0, c_Coil_1};
p_C1p_LV_i1=newp; Point(newp) = {x_[0]+gap_Core_Coil_1, height_Coil_1/2, 0, c_Coil_1};
p_C1p_LV_e1=newp; Point(newp) = {x_[0]+gap_Core_Coil_1+width_Coil_1/2, height_Coil_1/2, 0, c_Coil_1};
l_C1p_LV_1=newl; Line(newl) = {p_C1p_LV_e0, p_C1p_LV_e1};
l_C1p_LV_2=newl; Line(newl) = {p_C1p_LV_e1, p_C1p_LV_i1};
l_C1p_LV_3=newl; Line(newl) = {p_C1p_LV_i1, p_C1p_LV_i0};
l_C1p_LV_Y0=newl; Line(newl) = {p_C1p_LV_i0, p_C1p_LV_e0};
ll_C1p_LV=newll; Curve Loop(newll) = {l_C1p_LV_1, l_C1p_LV_2, l_C1p_LV_3, l_C1p_LV_Y0};
s_C1p_LV=news; Plane Surface(news) = {ll_C1p_LV};
Physical Surface("COIL_1_LV_PLUS", COIL_1_LV_PLUS) = {s_C1p_LV};

// COIL_1_HV_PLUS (HV)
x_[]=Point{p_C1p_LV_e0}; // Base on LV coil
p_C1p_HV_i0=newp; Point(newp) = {x_[0] + gap_LV_HV_1, 0, 0, c_Coil_1};
p_C1p_HV_e0=newp; Point(newp) = {x_[0] + gap_LV_HV_1 + width_Coil_1/2, 0, 0, c_Coil_1};
p_C1p_HV_i1=newp; Point(newp) = {x_[0] + gap_LV_HV_1, height_Coil_1/2, 0, c_Coil_1};
p_C1p_HV_e1=newp; Point(newp) = {x_[0] + gap_LV_HV_1 + width_Coil_1/2, height_Coil_1/2, 0, c_Coil_1};
l_C1p_HV_1=newl; Line(newl) = {p_C1p_HV_e0, p_C1p_HV_e1};
l_C1p_HV_2=newl; Line(newl) = {p_C1p_HV_e1, p_C1p_HV_i1};
l_C1p_HV_3=newl; Line(newl) = {p_C1p_HV_i1, p_C1p_HV_i0};
l_C1p_HV_Y0=newl; Line(newl) = {p_C1p_HV_i0, p_C1p_HV_e0};
ll_C1p_HV=newll; Curve Loop(newll) = {l_C1p_HV_1, l_C1p_HV_2, l_C1p_HV_3, l_C1p_HV_Y0};
s_C1p_HV=news; Plane Surface(news) = {ll_C1p_HV};
Physical Surface("COIL_1_HV_PLUS", COIL_1_HV_PLUS) = {s_C1p_HV};

// COIL_1_MINUS (LV)
x_[]=Point{p_Leg_1_L_0};
p_C1m_LV_i0=newp; Point(newp) = {x_[0]-gap_Core_Coil_1, 0, 0, c_Coil_1};
p_C1m_LV_e0=newp; Point(newp) = {x_[0]-(gap_Core_Coil_1+width_Coil_1/2), 0, 0, c_Coil_1};
p_C1m_LV_i1=newp; Point(newp) = {x_[0]-gap_Core_Coil_1, height_Coil_1/2, 0, c_Coil_1};
p_C1m_LV_e1=newp; Point(newp) = {x_[0]-(gap_Core_Coil_1+width_Coil_1/2), height_Coil_1/2, 0, c_Coil_1};
l_C1m_LV_1=newl; Line(newl) = {p_C1m_LV_e0, p_C1m_LV_e1};
l_C1m_LV_2=newl; Line(newl) = {p_C1m_LV_e1, p_C1m_LV_i1};
l_C1m_LV_3=newl; Line(newl) = {p_C1m_LV_i1, p_C1m_LV_i0};
l_C1m_LV_Y0=newl; Line(newl) = {p_C1m_LV_i0, p_C1m_LV_e0};
ll_C1m_LV=newll; Curve Loop(newll) = {l_C1m_LV_1, l_C1m_LV_2, l_C1m_LV_3, l_C1m_LV_Y0};
s_C1m_LV=news; Plane Surface(news) = {ll_C1m_LV};
Physical Surface("COIL_1_LV_MINUS", COIL_1_LV_MINUS) = {s_C1m_LV};

// COIL_1_HV_MINUS (HV)
x_[]=Point{p_C1m_LV_e0}; // Base on LV coil
p_C1m_HV_i0=newp; Point(newp) = {x_[0] - gap_LV_HV_1, 0, 0, c_Coil_1};
p_C1m_HV_e0=newp; Point(newp) = {x_[0] - (gap_LV_HV_1 + width_Coil_1/2), 0, 0, c_Coil_1};
p_C1m_HV_i1=newp; Point(newp) = {x_[0] - gap_LV_HV_1, height_Coil_1/2, 0, c_Coil_1};
p_C1m_HV_e1=newp; Point(newp) = {x_[0] - (gap_LV_HV_1 + width_Coil_1/2), height_Coil_1/2, 0, c_Coil_1};
l_C1m_HV_1=newl; Line(newl) = {p_C1m_HV_e0, p_C1m_HV_e1};
l_C1m_HV_2=newl; Line(newl) = {p_C1m_HV_e1, p_C1m_HV_i1};
l_C1m_HV_3=newl; Line(newl) = {p_C1m_HV_i1, p_C1m_HV_i0};
l_C1m_HV_Y0=newl; Line(newl) = {p_C1m_HV_i0, p_C1m_HV_e0};
ll_C1m_HV=newll; Curve Loop(newll) = {l_C1m_HV_1, l_C1m_HV_2, l_C1m_HV_3, l_C1m_HV_Y0};
s_C1m_HV=news; Plane Surface(news) = {ll_C1m_HV};
Physical Surface("COIL_1_HV_MINUS", COIL_1_HV_MINUS) = {s_C1m_HV};

// --- LEG 2 COILS (LV and HV) ---
// COIL_2_PLUS (LV)
x_[]=Point{p_Leg_2_R_0};
p_C2p_LV_i0=newp; Point(newp) = {x_[0]+gap_Core_Coil_2, 0, 0, c_Coil_2};
p_C2p_LV_e0=newp; Point(newp) = {x_[0]+gap_Core_Coil_2+width_Coil_2/2, 0, 0, c_Coil_2};
p_C2p_LV_i1=newp; Point(newp) = {x_[0]+gap_Core_Coil_2, height_Coil_2/2, 0, c_Coil_2};
p_C2p_LV_e1=newp; Point(newp) = {x_[0]+gap_Core_Coil_2+width_Coil_2/2, height_Coil_2/2, 0, c_Coil_2};
l_C2p_LV_1=newl; Line(newl) = {p_C2p_LV_e0, p_C2p_LV_e1};
l_C2p_LV_2=newl; Line(newl) = {p_C2p_LV_e1, p_C2p_LV_i1};
l_C2p_LV_3=newl; Line(newl) = {p_C2p_LV_i1, p_C2p_LV_i0};
l_C2p_LV_Y0=newl; Line(newl) = {p_C2p_LV_i0, p_C2p_LV_e0};
ll_C2p_LV=newll; Curve Loop(newll) = {l_C2p_LV_1, l_C2p_LV_2, l_C2p_LV_3, l_C2p_LV_Y0};
s_C2p_LV=news; Plane Surface(news) = {ll_C2p_LV};
Physical Surface("COIL_2_LV_PLUS", COIL_2_LV_PLUS) = {s_C2p_LV};

// COIL_2_HV_PLUS (HV)
x_[]=Point{p_C2p_LV_e0};
p_C2p_HV_i0=newp; Point(newp) = {x_[0] + gap_LV_HV_2, 0, 0, c_Coil_2};
p_C2p_HV_e0=newp; Point(newp) = {x_[0] + gap_LV_HV_2 + width_Coil_2/2, 0, 0, c_Coil_2};
p_C2p_HV_i1=newp; Point(newp) = {x_[0] + gap_LV_HV_2, height_Coil_2/2, 0, c_Coil_2};
p_C2p_HV_e1=newp; Point(newp) = {x_[0] + gap_LV_HV_2 + width_Coil_2/2, height_Coil_2/2, 0, c_Coil_2};
l_C2p_HV_1=newl; Line(newl) = {p_C2p_HV_e0, p_C2p_HV_e1};
l_C2p_HV_2=newl; Line(newl) = {p_C2p_HV_e1, p_C2p_HV_i1};
l_C2p_HV_3=newl; Line(newl) = {p_C2p_HV_i1, p_C2p_HV_i0};
l_C2p_HV_Y0=newl; Line(newl) = {p_C2p_HV_i0, p_C2p_HV_e0};
ll_C2p_HV=newll; Curve Loop(newll) = {l_C2p_HV_1, l_C2p_HV_2, l_C2p_HV_3, l_C2p_HV_Y0};
s_C2p_HV=news; Plane Surface(news) = {ll_C2p_HV};
Physical Surface("COIL_2_HV_PLUS", COIL_2_HV_PLUS) = {s_C2p_HV};

// COIL_2_MINUS (LV)
x_[]=Point{p_Leg_2_L_0};
p_C2m_LV_i0=newp; Point(newp) = {x_[0]-gap_Core_Coil_2, 0, 0, c_Coil_2};
p_C2m_LV_e0=newp; Point(newp) = {x_[0]-(gap_Core_Coil_2+width_Coil_2/2), 0, 0, c_Coil_2};
p_C2m_LV_i1=newp; Point(newp) = {x_[0]-gap_Core_Coil_2, height_Coil_2/2, 0, c_Coil_2};
p_C2m_LV_e1=newp; Point(newp) = {x_[0]-(gap_Core_Coil_2+width_Coil_2/2), height_Coil_2/2, 0, c_Coil_2};
l_C2m_LV_1=newl; Line(newl) = {p_C2m_LV_e0, p_C2m_LV_e1};
l_C2m_LV_2=newl; Line(newl) = {p_C2m_LV_e1, p_C2m_LV_i1};
l_C2m_LV_3=newl; Line(newl) = {p_C2m_LV_i1, p_C2m_LV_i0};
l_C2m_LV_Y0=newl; Line(newl) = {p_C2m_LV_i0, p_C2m_LV_e0};
ll_C2m_LV=newll; Curve Loop(newll) = {l_C2m_LV_1, l_C2m_LV_2, l_C2m_LV_3, l_C2m_LV_Y0};
s_C2m_LV=news; Plane Surface(news) = {ll_C2m_LV};
Physical Surface("COIL_2_LV_MINUS", COIL_2_LV_MINUS) = {s_C2m_LV};

// COIL_2_HV_MINUS (HV)
x_[]=Point{p_C2m_LV_e0};
p_C2m_HV_i0=newp; Point(newp) = {x_[0] - gap_LV_HV_2, 0, 0, c_Coil_2};
p_C2m_HV_e0=newp; Point(newp) = {x_[0] - (gap_LV_HV_2 + width_Coil_2/2), 0, 0, c_Coil_2};
p_C2m_HV_i1=newp; Point(newp) = {x_[0] - gap_LV_HV_2, height_Coil_2/2, 0, c_Coil_2};
p_C2m_HV_e1=newp; Point(newp) = {x_[0] - (gap_LV_HV_2 + width_Coil_2/2), height_Coil_2/2, 0, c_Coil_2};
l_C2m_HV_1=newl; Line(newl) = {p_C2m_HV_e0, p_C2m_HV_e1};
l_C2m_HV_2=newl; Line(newl) = {p_C2m_HV_e1, p_C2m_HV_i1};
l_C2m_HV_3=newl; Line(newl) = {p_C2m_HV_i1, p_C2m_HV_i0};
l_C2m_HV_Y0=newl; Line(newl) = {p_C2m_HV_i0, p_C2m_HV_e0};
ll_C2m_HV=newll; Curve Loop(newll) = {l_C2m_HV_1, l_C2m_HV_2, l_C2m_HV_3, l_C2m_HV_Y0};
s_C2m_HV=news; Plane Surface(news) = {ll_C2m_HV};
Physical Surface("COIL_2_HV_MINUS", COIL_2_HV_MINUS) = {s_C2m_HV};

// --- LEG 3 COILS (LV and HV) ---
// COIL_3_PLUS (LV)
x_[]=Point{p_Leg_3_R_0};
p_C3p_LV_i0=newp; Point(newp) = {x_[0]+gap_Core_Coil_3, 0, 0, c_Coil_3};
p_C3p_LV_e0=newp; Point(newp) = {x_[0]+gap_Core_Coil_3+width_Coil_3/2, 0, 0, c_Coil_3};
p_C3p_LV_i1=newp; Point(newp) = {x_[0]+gap_Core_Coil_3, height_Coil_3/2, 0, c_Coil_3};
p_C3p_LV_e1=newp; Point(newp) = {x_[0]+gap_Core_Coil_3+width_Coil_3/2, height_Coil_3/2, 0, c_Coil_3};
l_C3p_LV_1=newl; Line(newl) = {p_C3p_LV_e0, p_C3p_LV_e1};
l_C3p_LV_2=newl; Line(newl) = {p_C3p_LV_e1, p_C3p_LV_i1};
l_C3p_LV_3=newl; Line(newl) = {p_C3p_LV_i1, p_C3p_LV_i0};
l_C3p_LV_Y0=newl; Line(newl) = {p_C3p_LV_i0, p_C3p_LV_e0};
ll_C3p_LV=newll; Curve Loop(newll) = {l_C3p_LV_1, l_C3p_LV_2, l_C3p_LV_3, l_C3p_LV_Y0};
s_C3p_LV=news; Plane Surface(news) = {ll_C3p_LV};
Physical Surface("COIL_3_LV_PLUS", COIL_3_LV_PLUS) = {s_C3p_LV};

// COIL_3_HV_PLUS (HV)
x_[]=Point{p_C3p_LV_e0};
p_C3p_HV_i0=newp; Point(newp) = {x_[0] + gap_LV_HV_3, 0, 0, c_Coil_3};
p_C3p_HV_e0=newp; Point(newp) = {x_[0] + gap_LV_HV_3 + width_Coil_3/2, 0, 0, c_Coil_3};
p_C3p_HV_i1=newp; Point(newp) = {x_[0] + gap_LV_HV_3, height_Coil_3/2, 0, c_Coil_3};
p_C3p_HV_e1=newp; Point(newp) = {x_[0] + gap_LV_HV_3 + width_Coil_3/2, height_Coil_3/2, 0, c_Coil_3};
l_C3p_HV_1=newl; Line(newl) = {p_C3p_HV_e0, p_C3p_HV_e1};
l_C3p_HV_2=newl; Line(newl) = {p_C3p_HV_e1, p_C3p_HV_i1};
l_C3p_HV_3=newl; Line(newl) = {p_C3p_HV_i1, p_C3p_HV_i0};
l_C3p_HV_Y0=newl; Line(newl) = {p_C3p_HV_i0, p_C3p_HV_e0};
ll_C3p_HV=newll; Curve Loop(newll) = {l_C3p_HV_1, l_C3p_HV_2, l_C3p_HV_3, l_C3p_HV_Y0};
s_C3p_HV=news; Plane Surface(news) = {ll_C3p_HV};
Physical Surface("COIL_3_HV_PLUS", COIL_3_HV_PLUS) = {s_C3p_HV};

// COIL_3_MINUS (LV)
x_[]=Point{p_Leg_3_L_0};
p_C3m_LV_i0=newp; Point(newp) = {x_[0]-gap_Core_Coil_3, 0, 0, c_Coil_3};
p_C3m_LV_e0=newp; Point(newp) = {x_[0]-(gap_Core_Coil_3+width_Coil_3/2), 0, 0, c_Coil_3};
p_C3m_LV_i1=newp; Point(newp) = {x_[0]-gap_Core_Coil_3, height_Coil_3/2, 0, c_Coil_3};
p_C3m_LV_e1=newp; Point(newp) = {x_[0]-(gap_Core_Coil_3+width_Coil_3/2), height_Coil_3/2, 0, c_Coil_3};
l_C3m_LV_1=newl; Line(newl) = {p_C3m_LV_e0, p_C3m_LV_e1};
l_C3m_LV_2=newl; Line(newl) = {p_C3m_LV_e1, p_C3m_LV_i1};
l_C3m_LV_3=newl; Line(newl) = {p_C3m_LV_i1, p_C3m_LV_i0};
l_C3m_LV_Y0=newl; Line(newl) = {p_C3m_LV_i0, p_C3m_LV_e0};
ll_C3m_LV=newll; Curve Loop(newll) = {l_C3m_LV_1, l_C3m_LV_2, l_C3m_LV_3, l_C3m_LV_Y0};
s_C3m_LV=news; Plane Surface(news) = {ll_C3m_LV};
Physical Surface("COIL_3_LV_MINUS", COIL_3_LV_MINUS) = {s_C3m_LV};

// COIL_3_HV_MINUS (HV)
x_[]=Point{p_C3m_LV_e0};
p_C3m_HV_i0=newp; Point(newp) = {x_[0] - gap_LV_HV_3, 0, 0, c_Coil_3};
p_C3m_HV_e0=newp; Point(newp) = {x_[0] - (gap_LV_HV_3 + width_Coil_3/2), 0, 0, c_Coil_3};
p_C3m_HV_i1=newp; Point(newp) = {x_[0] - gap_LV_HV_3, height_Coil_3/2, 0, c_Coil_3};
p_C3m_HV_e1=newp; Point(newp) = {x_[0] - (gap_LV_HV_3 + width_Coil_3/2), height_Coil_3/2, 0, c_Coil_3};
l_C3m_HV_1=newl; Line(newl) = {p_C3m_HV_e0, p_C3m_HV_e1};
l_C3m_HV_2=newl; Line(newl) = {p_C3m_HV_e1, p_C3m_HV_i1};
l_C3m_HV_3=newl; Line(newl) = {p_C3m_HV_i1, p_C3m_HV_i0};
l_C3m_HV_Y0=newl; Line(newl) = {p_C3m_HV_i0, p_C3m_HV_e0};
ll_C3m_HV=newll; Curve Loop(newll) = {l_C3m_HV_1, l_C3m_HV_2, l_C3m_HV_3, l_C3m_HV_Y0};
s_C3m_HV=news; Plane Surface(news) = {ll_C3m_HV};
Physical Surface("COIL_3_HV_MINUS", COIL_3_HV_MINUS) = {s_C3m_HV};

//==================================================================
// 4. AIR GAPS (Manually stitched)
//==================================================================
// This section is now extremely complex due to 12 coils.

// --- AIR_WINDOW_1 (LEFT) ---
// Gap Lines at Y=0
l_aw1_g1=newl; Line(newl) = {p_Leg_1_R_0, p_C1p_LV_i0}; // Core to LV1+
l_aw1_g2=newl; Line(newl) = {p_C1p_LV_e0, p_C1p_HV_i0}; // LV1+ to HV1+
l_aw1_g3=newl; Line(newl) = {p_C1p_HV_e0, p_C2m_HV_e0}; // HV1+ to HV2-
l_aw1_g4=newl; Line(newl) = {p_C2m_HV_i0, p_C2m_LV_e0}; // HV2- to LV2-
l_aw1_g5=newl; Line(newl) = {p_C2m_LV_i0, p_Leg_2_L_0}; // LV2- to Core
// Stitch the loop
ll_Air_Window_1=newll; Curve Loop(newll) = {
  l_Core_In_L_1, l_Core_In_L_2, l_Core_In_L_3,  // Core inner boundary
  -l_aw1_g5, // Gap 5
  -l_C2m_LV_3, -l_C2m_LV_2, -l_C2m_LV_1,      // LV2- boundary
  -l_aw1_g4, // Gap 4
  -l_C2m_HV_3, -l_C2m_HV_2, -l_C2m_HV_1,      // HV2- boundary
  -l_aw1_g3, // Gap 3
  l_C1p_HV_1, l_C1p_HV_2, l_C1p_HV_3,         // HV1+ boundary
  -l_aw1_g2, // Gap 2
  l_C1p_LV_1, l_C1p_LV_2, l_C1p_LV_3,         // LV1+ boundary
  -l_aw1_g1  // Gap 1 (closes loop)
};
s_Air_Window_1=news; Plane Surface(news) = {ll_Air_Window_1};

// --- AIR_WINDOW_2 (RIGHT) ---
// Gap Lines at Y=0
l_aw2_g1=newl; Line(newl) = {p_Leg_2_R_0, p_C2p_LV_i0}; // Core to LV2+
l_aw2_g2=newl; Line(newl) = {p_C2p_LV_e0, p_C2p_HV_i0}; // LV2+ to HV2+
l_aw2_g3=newl; Line(newl) = {p_C2p_HV_e0, p_C3m_HV_e0}; // HV2+ to HV3-
l_aw2_g4=newl; Line(newl) = {p_C3m_HV_i0, p_C3m_LV_e0}; // HV3- to LV3-
l_aw2_g5=newl; Line(newl) = {p_C3m_LV_i0, p_Leg_3_L_0}; // LV3- to Core
// Stitch the loop
ll_Air_Window_2=newll; Curve Loop(newll) = {
  l_Core_In_R_1, l_Core_In_R_2, l_Core_In_R_3,  // Core inner boundary
  -l_aw2_g5, // Gap 5
  -l_C3m_LV_3, -l_C3m_LV_2, -l_C3m_LV_1,      // LV3- boundary
  -l_aw2_g4, // Gap 4
  -l_C3m_HV_3, -l_C3m_HV_2, -l_C3m_HV_1,      // HV3- boundary
  -l_aw2_g3, // Gap 3
  l_C2p_HV_1, l_C2p_HV_2, l_C2p_HV_3,         // HV2+ boundary
  -l_aw2_g2, // Gap 2
  l_C2p_LV_1, l_C2p_LV_2, l_C2p_LV_3,         // LV2+ boundary
  -l_aw2_g1  // Gap 1 (closes loop)
};
s_Air_Window_2=news; Plane Surface(news) = {ll_Air_Window_2};

Physical Surface("AIR_WINDOW", AIR_WINDOW) = {s_Air_Window_1, s_Air_Window_2};

// --- AIR_EXT ---
x_[]=Point{p_Leg_3_R_1};
p_Air_Ext_1_R_0=newp; Point(newp) = {x_[0]+gap_Core_Box_X, 0, 0, c_Box};
p_Air_Ext_1_R_1=newp; Point(newp) = {x_[0]+gap_Core_Box_X, x_[1]+gap_Core_Box_Y, 0, c_Box};

x_[]=Point{p_Leg_1_L_1};
p_Air_Ext_1_L_0=newp; Point(newp) = {x_[0]-gap_Core_Box_X, 0, 0, c_Box};
p_Air_Ext_1_L_1=newp; Point(newp) = {x_[0]-gap_Core_Box_X, x_[1]+gap_Core_Box_Y, 0, c_Box};

l_Air_Ext_R=newl; Line(newl) = {p_Air_Ext_1_R_0, p_Air_Ext_1_R_1};
l_Air_Ext_T=newl; Line(newl) = {p_Air_Ext_1_R_1, p_Air_Ext_1_L_1};
l_Air_Ext_L=newl; Line(newl) = {p_Air_Ext_1_L_1, p_Air_Ext_1_L_0};
l_Air_Ext[] = {l_Air_Ext_R, l_Air_Ext_T, l_Air_Ext_L};

// Gap Lines at Y=0
l_ae_g1=newl; Line(newl) = {p_Leg_3_R_0, p_C3p_LV_i0}; // Core to LV3+
l_ae_g2=newl; Line(newl) = {p_C3p_LV_e0, p_C3p_HV_i0}; // LV3+ to HV3+
l_ae_g3=newl; Line(newl) = {p_C3p_HV_e0, p_Air_Ext_1_R_0}; // HV3+ to Air Box
l_ae_g4=newl; Line(newl) = {p_Air_Ext_1_L_0, p_C1m_HV_e0}; // Air Box to HV1-
l_ae_g5=newl; Line(newl) = {p_C1m_HV_i0, p_C1m_LV_e0}; // HV1- to LV1-
l_ae_g6=newl; Line(newl) = {p_C1m_LV_i0, p_Leg_1_L_0}; // LV1- to Core

ll_Air_Ext=newll; Curve Loop(newll) = {
  -l_Core_Out_3, -l_Core_Out_2, -l_Core_Out_1,
  l_ae_g1,
  -l_C3p_LV_3, -l_C3p_LV_2, -l_C3p_LV_1,
  l_ae_g2,
  -l_C3p_HV_3, -l_C3p_HV_2, -l_C3p_HV_1,
  l_ae_g3,
  l_Air_Ext_R, l_Air_Ext_T, l_Air_Ext_L,
  l_ae_g4,
  l_C1m_HV_1, l_C1m_HV_2, l_C1m_HV_3,
  l_ae_g5,
  l_C1m_LV_1, l_C1m_LV_2, l_C1m_LV_3,
  l_ae_g6
};
s_Air_Ext=news; Plane Surface(news) = {ll_Air_Ext};

Physical Surface("AIR_EXT", AIR_EXT) = {s_Air_Ext};
Physical Curve("SUR_AIR_EXT", SUR_AIR_EXT) = {l_Air_Ext[]};//+
Physical Curve("outside_surfacee", 1349) = {1340, 1339, 1338, 1343, 1344};
