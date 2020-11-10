--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
--[[
	%s is a "Wild Card" character. AQB uses these to replace with data
	such as names of items, players, etc.. It is important not to remove
	them or you will receive errors. For translating, you can move them
	where they need to go in the sentence so the data forms a proper
	sentence in your language.
]]
AQB_XML_QDTAILS = "Detalles de la mision";
AQB_XML_DESCR = "Descripcion:";
AQB_XML_REWARDS = "Recompensas:";
AQB_XML_DETAILS = "Detalles:";
AQB_XML_LOCATIONS = "Localizaciones:";
AQB_XML_CONFIG = "Configuracion";
AQB_XML_HSECTION = "Seccion de Ayuda";
AQB_XML_OPENHELP = "Abrir Ayuda";
AQB_XML_CLOSEHELP = "Cerrar Ayuda";
AQB_XML_SHARERES = "Compartir resultados";
AQB_XML_SHOWSHARE = "Ver compartidas";
AQB_XML_HIDESHARE = "Ocultar compartido";
AQB_XML_BACK = "Atras";
AQB_XML_TYPEKEYWORD = "Introduce un texto para buscar";
AQB_XML_SEARCH = "Buscar";
AQB_XML_SEARCHRES = "Resultados de busqueda";
AQB_XML_CONFIG2 = "Configuracion";
AQB_XML_CONFIG3 = "Icon Configuration"; -- New
AQB_XML_RELOADUI1 = "RecargarUI";
AQB_XML_RELOADUI2 = "Recargar UI si los iconos del mapa se descolocan.";
AQB_XML_RELOADUI3 = "AQD Habilitado, RecargarUI Deshabilitado.";
AQB_XML_SHTOOLTIPS = "Tooltips"; -- Edited
AQB_XML_STTOOLTIPS = "Bloquear Tooltips";
AQB_XML_STICONS = "Bloquear Iconos";
AQB_XML_QDONTIPS = "Quest Description"; -- Edited
AQB_XML_RLONTIPS = "Recommended Level"; -- Edited
AQB_XML_REWONTIPS = "Rewards"; -- Edited
AQB_XML_COORDONTIPS = "Coordinates"; -- Edited
AQB_XML_PREINC = "Guardar incompletas";
AQB_XML_AQD = "Herramienta de volcado de Datos (AQD)";
AQB_XML_QS = "Compartir misiones";
AQB_XML_TMBTN = "Mostrar boton AQB";
--AQB_XML_SAVECLOSE = "Guardar/Salir";
--AQB_XML_CLOSECONFIG = "Cerrar Configuracion";
AQB_XML_PURGE = "Purgar datos";
AQB_XML_STPORT = "Snoop Transports"; -- Edited
AQB_XML_ETRAIN = "Elite Trainers"; -- Edited
AQB_XML_SHOWSHARED = "Shared Quests"; -- Edited
AQB_XML_SHOWDAILY = "Daily Quests"; -- New
AQB_XML_SHOWQUESTS = "Quests"; -- New
AQB_XML_AIRPORT = "Airships"; -- New
AQB_XML_MSGONDUMP = "Mostrar mensaje en la descarga de misiones";
AQB_XML_NOTE1 = "Drag this icon on the map to place an icon in that location."; -- New
AQB_XML_NOTE2 = "Shift+Left Click a Note to Edit It"; -- New
AQB_XML_NOTE3 = "Hold Shift+Right Mouse to Move a Note"; -- New
AQB_XML_NOTE4 = "CTRL+Left Click to Delete a Note"; -- New
AQB_XML_NOTE5 = "New Note"; -- New
AQB_XML_NOTE6 = "Edit Note"; -- New
AQB_XML_NOTE7 = "You currently have %s notes for the current map. Please remove a note before trying to add another."; -- New
AQB_XML_NOTE8 = "Map Notes:"; -- New
AQB_XML_NOTE9 = "Save Note"; -- New
AQB_XML_NOTE10 = "Edit Title"; -- New
AQB_XML_NOTE11 = "Edit Note"; -- New
AQB_XML_NOTE12 = "Custom Notes"; -- Edited

AdvQuestBook_Messages = {
	["AQB_AMINFO"] = "una caracteristica muy util para encontrar informacion, realizar un seguimiento y llevar un control de tus misiones.",
	["AQB_AMNOTFOUND"] = "AddonManager no detectado. Es un Addon muy util y de uso recomendado para %s. Escribe %s para abrir el panel de %s o puedes usar el boton provisto en el caso de que AddonManager no este instalado.",
	["AQB_ERRFILELOAD"] = "Error al subir el archivo",
	["AQB_DFAULTSETLOAD"] = "ajustes por defecto cargados",
	["AQB_SETSUPDATE"] = "ajustes actualizados",
	["AQB_GET_PQUEST"] = "Obtener Misiones de Grupo",
	["AQB_SHIFT_RIGHT"] = "Mayus + Click derecho para mover los botones del minimapa.",
	["AQB_RCLICK"] = "Boton derecho",
	["AQB_MOVE_BTN"] = "Manten presionado el boton izquierdo para mover el boton.",
	["AQB_L50ET"] = "Debes tener las habilidades ELite de nivel 45 primarias y secundarias.",
	["AQB_LIST_RECIEVED"] = "Recibida lista de misiones compartidas. Por favor, abre %s para ver las misiones compartidas.",
	["AQB_NOLIST_RECIEVED"] = "No se ha recibido ningun dato de misiones compartidas.",
	["AQB_RECLEVEL"] = "Nivel recomendado",
	["AQB_UNKNOWNQID"] = "ID de mision desconocido",
	["AQB_COORDS"] = "Coordenadas",
	["AQB_NEW_QD"] = "Nueva mision descargada para %s.";
	["AQB_CLEARED_DATA"] = "Limpiadas %s misiones y guardadas %s misiones",
	["AQB_CLEANED_ALL"] = "Limpiados todos los datos guardados.",
	["AQB_UPLOAD"] = "Asegurate de subir tu %s a %s despues de que hayas salido del juego.",
	["AQB_MIN_CHARS"] = "Por favor, escribe al menos %s caracteres para la busqueda...",
	["AQB_TOOMANY"] = "Se han encontrado mas de %s resultados. Si usas unos parametros de busqueda distintos puedes reducir los resultados a algo mas sencillo para poder visionarlos.",
	["AQB_SEARCHING"] = "Buscando %s. Por favor, espera...",
	["AQB_FOUND_RESULTS"] = "Encontrados %s resultados para %s.",
	["AQB_NOTSUB"] = "Esta mision aun no se ha presentado.",
	["AQB_RECLEVEL"] = "Nivel recomendado",
	["AQB_START"] = "Çomienza",
	["AQB_END"] = "Termina",
	["AQB_REWARDS"] = "Recompensas",
	["AQB_COORDS"] = "Coordenadas",
	["AQB_TRANSPORT"] = "Transporte",
	["AQB_LINKSTO"] = "Transporta a",
	["AQB_DUMPED"] = "Descargado",
	["AQB_GOLD"] = "Oro",
	["AQB_XP"] = "Experiencia",
	["AQB_TP"] = "Puntos de Talento",
	["AQB_MAP"] = "Mapa",
	["AQB_AND"] = "y",
	["AQB_OPEN"] = "Abrir",
	["AQB_LOCK"] = "Bloquea",
	["AQB_UNLOCK"] = "Desbloquea",
	["AQB_QSTATUS0"] = "No has completado esta mision.",
	["AQB_QSTATUS1"] = "Actualmente tienes esta mision.",
	["AQB_QSTATUS2"] = "Has completado esta mision.",
};
-- Help topics will be added back later. I need to rewrite them.
