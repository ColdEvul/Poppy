#include "..\script_component.hpp"
params ["_unit"];

if !(isPlayer _unit) then {
    // AI units need to receive a 343 to check if there is enough inventory space for one
    _unit unlinkItem "ItemRadio";
    _unit addItem "ACRE_PRC343";
    switch (true) do {
        case !(_unit canAdd "ACRE_PRC343"):              { GVAR(delayedItems) pushBack "ACRE_PRC343" };
        case (_unit canAddItemToUniform "ACRE_PRC343"):     { _unit addItemToUniform "ACRE_PRC343" };
        case (_unit canAddItemToBackpack "ACRE_PRC343"): { _unit addItemToBackpack "ACRE_PRC343" };
        case (_unit canAddItemToVest "ACRE_PRC343"):     { _unit addItemToVest "ACRE_PRC343" };
    };
};

private _config = missionConfigFile >> "CfgLoadouts" >> typeOf _unit;
if (isArray (_config >> "lrRadios") && {!(getArray (_config >> "lrRadios") isEqualTo [""])}) exitWith {
    [_unit, getArray (_config >> "lrRadios")] call FUNC(addLRRadios);
};

_config = missionConfigFile >> "CfgPoppy" >> "ACRE";
if ((leader _unit == _unit) && {getNumber (_config >> "distributeGroupLeaderRadios") == 1}) exitWith {
    if (isText (_config >> "groupLeaderRadio")) then {
        [_unit, [getText (_config >> "groupLeaderRadio")]] call FUNC(addLRRadios);
    } else {
        ["Poppy was set to distribute long range radios for squad leaders, but it wasn't specified which ones to distribute. "
        + "Please make sure to fill out the ""groupLeaderRadio"" entry in Poppy's config."] call FUNC(logError);
    };
};