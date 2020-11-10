--[[
Guildpanel - Locale/language.es.lua
Traducido por Intar del gremio Glamhoth, servidor Sciath ES
Thanks to Juki for the UTF-8 ASCII Table


   à : \195\160    è : \195\168    ì : \195\172    ò : \195\178    ù : \195\185
   á : \195\161    é : \195\169    í : \195\173    ó : \195\179    ú : \195\186
   â : \195\162    ê : \195\170    î : \195\174    ô : \195\180    û : \195\187
   ã : \195\163    ë : \195\171    ï : \195\175    õ : \195\181    ü : \195\188
   ä : \195\164                    ñ : \195\177    ö : \195\182
   æ : \195\166                                    ø : \195\184
   ç : \195\167                                    ? : \197\147

   Ä : \195\132
   Ö : \195\150
   Ü : \195\156
   ß : \195\159
]]--
    GuildPanel.locale = {
        GP_Description = "Añade mas fucionalidad al panel del gremio.",
        GP_Unloaded = "GuildPanel desactivado.",
        GP_Loaded = "GuildPanel cargado, usa /gp para configurarlo.",
        GP_LoadedInactive = "GuildPanel cargado (actualmente inactivo, no gremio).",
        MainTitleText = "%s (%d de %d miembros conectados, max: %d, Nivel: %d, Lider: %s)",
        SingleDay = "dia",
        MultiDays = "dias",
        dropdown_name = "Nombre",
        dropdown_online = "Conectado",
        dropdown_zone = "Localizaci\195\179 n",
        dropdown_rank = "Rango",
        dropdown_level = "Nivel",
        dropdown_class = "Clase",
        SortTitle = "Ordenar Por",
        MemberList = "Miembros del clan",
        OfflineDesc = "Show offline members",
		Yes = "Sí",
        No = "No",

        Config_Title = "GuildPanel - Configuraci\195\179n",
        Config_Name = "Configuraci\195\179n",
        Config_ShowRank = "Mostrar rango",
        Config_ShowNote = "Mostrar nota",
        Config_ShowColors = "Colorear Filas",
        Config_ColorsOffline = "Colorear Miembros Desconectados",
        Config_ColorsRank = "por rango",
        Config_ColorsClass = "por clase",
        Config_SortOnlineTop = "Miembros conectados arriba",
        Config_CloseText = "Cerrar",
        Config_SwapDruidWarden = "Swap colors for druid and warden",
        Config_SwapDruidWardenRaid = "also do this in raid view",         
        Config_AutoSave = "Autoguardado de configuraci\195\179n.",
    }

    GuildPanel.patterns = {
        day = "d"
    };
