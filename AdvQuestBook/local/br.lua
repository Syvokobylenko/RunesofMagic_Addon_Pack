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
AQB_XML_QDTAILS = "Detalhes da Missão";
AQB_XML_DESCR = "Descrição:";
AQB_XML_REWARDS = "Recompensas:";
AQB_XML_DETAILS = "Detalhes:";
AQB_XML_LOCATIONS = "Locais:";
AQB_XML_CONFIG = "Config";
AQB_XML_HSECTION = "Seção de Ajuda";
AQB_XML_OPENHELP = "Abrir Ajuda";
AQB_XML_CLOSEHELP = "Fechar Ajuda";
AQB_XML_SHARERES = "Compartilhar Resultados";
AQB_XML_SHOWSHARE = "Mostrar Compartilhados";
AQB_XML_HIDESHARE = "Esconder Compartilhados";
AQB_XML_BACK = "Voltar";
AQB_XML_TYPEKEYWORD = "Palavra chave para busca";
AQB_XML_SEARCH = "Busca";
AQB_XML_SEARCHRES = "Buscar Resultados";
AQB_XML_CONFIG2 = "Configuração";
AQB_XML_CONFIG3 = "Icon Configuration"; -- New
AQB_XML_RELOADUI1 = "RecarregarUI";
AQB_XML_RELOADUI2 = "Recarregar UI se houver problema com os ícones do mapa.";
AQB_XML_RELOADUI3 = "AQD Ativado, RecarregarUI Desativado.";
AQB_XML_SHTOOLTIPS = "Tooltips"; -- Edited
AQB_XML_STTOOLTIPS = "Fixar Tooltips";
AQB_XML_STICONS = "Fixar Icones";
AQB_XML_QDONTIPS = "Quest Description"; -- Edited
AQB_XML_RLONTIPS = "Recommended Level"; -- Edited
AQB_XML_REWONTIPS = "Rewards"; -- Edited
AQB_XML_COORDONTIPS = "Coordinates"; -- Edited
AQB_XML_PREINC = "Preservar Incompletas";
AQB_XML_AQD = "Advanced Quest Dumper";
AQB_XML_QS = "Compartilhar Missões";
AQB_XML_TMBTN = "Ativar Minibutton";
--AQB_XML_SAVECLOSE = "Salvar/Fechar";
--AQB_XML_CLOSECONFIG = "Fechar Config";
AQB_XML_PURGE = "Apagar dados";
AQB_XML_STPORT = "Snoop Transports"; -- Edited
AQB_XML_ETRAIN = "Elite Trainers"; -- Edited
AQB_XML_SHOWSHARED = "Shared Quests"; -- Edited
AQB_XML_SHOWDAILY = "Daily Quests"; -- New
AQB_XML_SHOWQUESTS = "Quests"; -- New
AQB_XML_AIRPORT = "Airships"; -- New
AQB_XML_MSGONDUMP = "Mostrar Mensagens no Quest Dump";
AQB_XML_NOTE1 = "Arraste este ícone no mapa para colocar um ícone naquela região."; -- New
AQB_XML_NOTE2 = "Clique com o botão esquerdo numa Nota para Editá-la"; -- New
AQB_XML_NOTE3 = "Shift+Botão Direito para mover uma Nota"; -- New
AQB_XML_NOTE4 = "Shift+Botão Esquerdo para apagar uma Nota"; -- New
AQB_XML_NOTE5 = "Nova Nota"; -- New
AQB_XML_NOTE6 = "Editar Nota"; -- New
AQB_XML_NOTE7 = "Você tem %s notas para o mapa atual. Por favor remova uma Nota antes de tentar adicionar outra." -- New
AQB_XML_NOTE8 = "Notas de Mapa:"; -- New
AQB_XML_NOTE9 = "Notas Salvas"; -- New
AQB_XML_NOTE10 = "Editar Título"; -- New
AQB_XML_NOTE11 = "Editar Nota"; -- New
AQB_XML_NOTE12 = "Custom Notes"; -- Edited

AdvQuestBook_Messages = {
	["AQB_AMINFO"] = "Uma ótima maneira de encontrar informações, rastrear e gerenciar suas missões no jogo.",
	["AQB_AMNOTFOUND"] = "AddonManager não foi detectado. Ele é um addon útil e altamente recomendado para ser usado por %s. Digite %s para abrir o painel %s ou você pode usar os botões que aparecem quando o AddonManager não está instalado.",
	["AQB_ERRFILELOAD"] = "Erro carregando arquivo",
	["AQB_DFAULTSETLOAD"] = "Configurações padrão carregadas",
	["AQB_SETSUPDATE"] = "Configurações atualizadas",
	["AQB_GET_PQUEST"] = "Buscar Missões de Grupo",
	["AQB_SHIFT_RIGHT"] = "Shift + Botão direito para mover os botões do minimapa.",
	["AQB_RCLICK"] = "Botão Direito",
	["AQB_MOVE_BTN"] = "Segure o botão esquerdo para mover o botão.",
	["AQB_L50ET"] = "Deve ter Habilidades de Elite Primária e Secundária no nível 45.",
	["AQB_LIST_RECIEVED"] = "Lista de missões compartilhadas recebida. Por favor, abra %s para ver as missões compartilhadas.",
	["AQB_NOLIST_RECIEVED"] = "Nenhuma missão compartilhada encontrada.",
	["AQB_RECLEVEL"] = "Nível Recomendado",
	["AQB_UNKNOWNQID"] = "ID de Missão Desconhecido",
	["AQB_COORDS"] = "Coords",
	["AQB_NEW_QD"] = "New Quest Dumped para %s.";
	["AQB_CLEARED_DATA"] = " %s missões eliminadas e %s missões salvas",
	["AQB_CLEANED_ALL"] = "Todos os dados de missões eliminados.",
	["AQB_UPLOAD"] = "Envie o %s para %s após sair do jogo.",
	["AQB_MIN_CHARS"] = "Por favor digite pelo menos %s caracteres para procurar...",
	["AQB_TOOMANY"] = "Mais que %s resultados encontrados. Usar um outro termo de busca pode reduzir seus resultados para uma forma mais fácil de ver.",
	["AQB_SEARCHING"] = "Procurando por %s. Por favor, aguarde...",
	["AQB_FOUND_RESULTS"] = "Encontrado %s resultados para %s.",
	["AQB_NOTSUB"] = "Essa missão não foi submetida ainda.",
	["AQB_RECLEVEL"] = "Nível Recomendado",
	["AQB_START"] = "Começo",
	["AQB_END"] = "Fim",
	["AQB_REWARDS"] = "Recompensas",
	["AQB_COORDS"] = "Coords",
	["AQB_TRANSPORT"] = "Transporte",
	["AQB_LINKSTO"] = "Links para",
	["AQB_DUMPED"] = "Dumped",
	["AQB_GOLD"] = "Ouro",
	["AQB_XP"] = "Experiência",
	["AQB_TP"] = "Pontos de Talento",
	["AQB_MAP"] = "Mapa",
	["AQB_AND"] = "e",
	["AQB_OPEN"] = "Abrir",
	["AQB_LOCK"] = "Travar",
	["AQB_UNLOCK"] = "Destravar",
	["AQB_QSTATUS0"] = "Você não completou essa missão.",
	["AQB_QSTATUS1"] = "Você tem essa missão.",
	["AQB_QSTATUS2"] = "Você completou essa missão.",
};
-- Help topics will be added back later. I need to rewrite them.
