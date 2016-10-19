#define isDev

#define PREFIX GeCo

// Predefines for easy Macro work
#define DOUBLE(var1,var2) var1##_##var2
#define TRIPLE(var1,var2,var3) DOUBLE(var1,DOUBLE(var2,var3))

#define QUOTE(var) #var

// Global Varible Macros
#define EGVAR(var1,var2) TRIPLE(PREFIX,var1,var2)
#define QEGVAR(var1,var2) QUOTE(EGVAR(var1,var2))

#define GVAR(var) EGVAR(MODULE,var)
#define QGVAR(var) QUOTE(GVAR(var))

#define CGVAR(var) DOUBLE(CLib,var)
#define QCGVAR(var) QUOTE(CGVAR(var))

#define UIVAR(var1) QEGVAR(UI,var1)

// Logging/Dumping macros
#ifdef isDev
    #define DUMP(var) \
        diag_log format ["(%1) [%4 DUMP - %2]: %3", diag_frameNo, #MODULE, var, QUOTE(PREFIX)];\
        systemChat format ["(%1) [%4 DUMP - %2]: %3", diag_frameNo, #MODULE, var, QUOTE(PREFIX)];\
        if (hasInterface) then {\
            CGVAR(sendlogfile) = [format ["(%1) [%4 DUMP - %2]: %3", diag_frameNo, #MODULE, var, QUOTE(PREFIX)], format ["%1_%2", profileName, CGVAR(playerUID)]];\
            publicVariableServer QCGVAR(sendlogfile);\
        };
#else
    #define DUMP(var) /* disabled */
#endif

#ifdef isDev
    #define LOG(var) DUMP(var)
#else
    #define LOG(var) diag_log format ["(%1) [%4 LOG - %2]: %3", diag_frameNo, #MODULE, var, QUOTE(PREFIX)];
#endif

/ Function macros
#define EDFUNC(var1,var2) TRIPLE(PREFIX,var1,DOUBLE(fnc,var2))

#define DFUNC(var) EDFUNC(MODULE,var)

#define QEFUNC(var1,var2) QUOTE(EDFUNC(var1,var2))

#define QFUNC(var) QUOTE(DFUNC(var))

#ifdef isDev
    #define EFUNC(var1,var2) (currentNamespace getVariable [QEFUNC(var1,var2), {if (time > 0) then {["Error function %1 dont exist or isNil", QEFUNC(var1,var2)] call BIS_fnc_errorMsg;}; DUMP(QEFUNC(var1,var2) + " Dont Exist")}])
#endif

#ifdef ENABLEFUNCTIONTRACE
    #undef EFUNC
    #define EFUNC(var1,var2) {\
        DUMP("Function " + QEFUNC(var1,var2) + " called with " + str (_this));\
        private _tempRet = _this call EDFUNC(var1,var2);\
        if (!isNil "_tempRet") then {\
            _tempRet\
        }\
    }
#endif

#ifndef EFUNC
    #define EFUNC(var1,var2) EDFUNC(var1,var2)
#endif

#define FUNC(var) EFUNC(MODULE,var)

#define DCFUNC(var) TRIPLE(CLib,fnc,var)
#define QCFUNC(var) QUOTE(DCFUNC(var))

#ifdef isDev
    #define CFUNC(var) (currentNamespace getVariable [QCFUNC(var), {if (time > 0) then {["Error function %1 dont exist or isNil", QCFUNC(var)] call BIS_fnc_errorMsg;}; DUMP(QCFUNC(var) + " Dont Exist")}])
#else
    #define CFUNC(var) TRIPLE(CLib,fnc,var)
#endif

// is Data Type Check of easyer Code reading
#define IS_ARRAY(var) var isEqualType []
#define IS_BOOL(var) var isEqualType false
#define IS_CODE(var) var isEqualType {}
#define IS_CONFIG(var) var isEqualType configNull
#define IS_CONTROL(var) var isEqualType controlNull
#define IS_DISPLAY(var) var isEqualType displayNull
#define IS_GROUP(var) var isEqualType grpNull
#define IS_OBJECT(var) var isEqualType objNull
#define IS_SCALAR(var) var isEqualType 0
#define IS_SCRIPT(var) var isEqualType scriptNull
#define IS_SIDE(var) var isEqualType west
#define IS_STRING(var) var isEqualType "STRING"
#define IS_TEXT(var) var isEqualType text ""
#define IS_LOCATION(var) var isEqualType locationNull
#define IS_INTEGER(var)  if ( IS_SCALAR(var) ) then { (floor(var) == (var)) } else { false }
#define IS_NUMBER(var)   IS_SCALAR(var)

// is Voted Admin Server (not 100% supported the Server Owner can change the comands what the voted Admin can use)
#define IS_ADMIN serverCommandAvailable "#kick"

// is Logged Admin Server (not 100% supported the Server Owner can change the comands what the voted Admin can use)
#define IS_ADMIN_LOGGED serverCommandAvailable "#shutdown"

#ifdef ENABLEPERFORMANCECOUNTER
    #define PERFORMANCECOUNTER_START(var1) [#var1, true] call CFUNC(addPerformanceCounter);
    #define PERFORMANCECOUNTER_END(var1) [#var1, false] call CFUNC(addPerformanceCounter);
#else
    #define PERFORMANCECOUNTER_START(var1) /* Performance Counter disabled */
    #define PERFORMANCECOUNTER_END(var1) /* Performance Counter disabled */
#endif
