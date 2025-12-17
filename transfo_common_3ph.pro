// --- Dimensions (from transfo_common.pro) ---
width_Core = 3.2;
height_Core = 1.;
thickness_Core = 0.3;
width_Window = 0.5;
height_Window = 0.5;
width_Core_Leg = (width_Core-width_Window)/2.; // (0.25)

width_Coil_1 = 0.10;
height_Coil_1 = 0.25;
gap_Core_Coil_1 = 0.005; // Gap between Core and LV
gap_LV_HV_1 = 0.005;     // Gap between LV and HV

width_Coil_2 = 0.10;
height_Coil_2 = 0.25;
gap_Core_Coil_2 = 0.005;
gap_LV_HV_2 = 0.005;

gap_Core_Box_X = 1.;
gap_Core_Box_Y = 1.;

//-solve -pos Analysis -pos Circuit_OCSC

// --- Characteristic lenghts (from transfo_common.pro) ---
s = 1;
c_Core = width_Core_Leg/10. *s;
c_Coil_1 = height_Coil_1/2/5 *s;
c_Coil_2 = height_Coil_2/2/5 *s;
c_Box = gap_Core_Box_X/6. *s;

// --- Physical regions (from transfo_common.pro) ---
AIR_EXT = 1001;
SUR_AIR_EXT = 1002;
AIR_WINDOW = 1011;
CORE = 1050;
COIL_1_LV_PLUS = 1101;     // LV 1+
COIL_1_LV_MINUS = 1102;    // LV 1-
COIL_2_LV_PLUS = 1201;     // LV 2+
COIL_2_LV_MINUS = 1202;    // LV 2-
// --- NEW Physical regions for HV coils ---
COIL_1_HV_PLUS = 1111;  // HV 1+
COIL_1_HV_MINUS = 1112; // HV 1-
COIL_2_HV_PLUS = 1211;  // HV 2+
COIL_2_HV_MINUS = 1212; // HV 2-
COIL_3_LV_PLUS = 1301;  // LV 3+
COIL_3_LV_MINUS = 1302; // LV 3-
COIL_3_HV_PLUS = 1311;  // HV 3+
COIL_3_HV_MINUS = 1312; // HV 3-

// --- 3-Phase Variable Definitions (Extrapolated) ---
width_Core_Leg_Mid = width_Core_Leg; 
width_Core_3ph = width_Core_Leg * 2 + width_Core_Leg_Mid + width_Window * 2; // (1.75)
y_yoke_bottom = height_Window / 2.; // (0.25)
y_yoke_top = height_Core / 2.; // (0.5)

// Define Coil 3 (copying Coil 2)
width_Coil_3 = width_Coil_2;
height_Coil_3 = height_Coil_2;
gap_Core_Coil_3 = gap_Core_Coil_2;
gap_LV_HV_3 = gap_LV_HV_2;
c_Coil_3 = c_Coil_2;