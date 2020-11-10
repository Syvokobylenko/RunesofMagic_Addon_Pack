yGather.i18n = {};

function yGather.translate(key)
    return yGather.i18n.translate(key);
end

-- make globals available
local GetLanguage = GetLanguage;
local logger = yGather.logger;
local dofile = dofile;
local pcall = pcall;
local ipairs = ipairs;
local table = table;
local string = string;
local error = error;

setfenv(1, yGather.i18n);

local mDefaultLanguage = nil;
local mLocalLanguage = nil;

local mLanguageCodes = {"DE", "EN", "BR", "CN", "ES", "FR", "IT", "JP", "KR", "PL", "PT", "RU", "TW"};
local mLanguages = nil;

local function InitializeLanguages()
    mLanguages = {};
    local langSet;
    for _, code in ipairs(mLanguageCodes) do
        langSet = dofile("Interface/AddOns/yGather/Locales/" .. code .. ".lua");
        if (langSet ~= nil) then
            table.insert(mLanguages, {code, langSet["common/language"]});
        end;
    end;
    table.sort(mLanguages, function(arg1, arg2) return arg1[1] < arg2[1] end);
end;

function GetLanguages()
    if (mLanguages == nil) then
        InitializeLanguages();
    end;
    return mLanguages;
end;

function GetLanguageForCode(code)
    if (mLanguages == nil) then
        InitializeLanguages();
    end;
    for _, entry in ipairs(mLanguages) do
        if (entry[1] == code) then
            return entry[2];
        end;
    end;
end;

function Initialize(languageCode)
    InitializeLanguages();

    if (languageCode == nil) then
        languageCode = GetLanguage();
    end;
    languageCode = string.upper(languageCode)

    -- load default language
    mDefaultLanguage = dofile("Interface/AddOns/yGather/Locales/EN.lua");
    
    -- try to load locale
    local localLoaded, errorOrResult = pcall(dofile, "Interface/AddOns/yGather/Locales/" .. languageCode .. ".lua");
    if (localLoaded) then
        mLocalLanguage = errorOrResult;
    else
        mLocalLanguage = nil;
        logger.warn("error loading language pack: language=" .. languageCode .. " error: " .. errorOrResult);
    end
end

function translate(key)
    if (mDefaultLanguage == nil) then
        -- i18n not (yet) initialized
        return "i18n not initialized";
    end;
    if (mLocalLanguage) then
        local translated = mLocalLanguage[key];
        if (translated) then
            return translated;
        end
    end
    local translated = mDefaultLanguage[key];
    if (translated) then
        return translated;
    end
    return key;
end
