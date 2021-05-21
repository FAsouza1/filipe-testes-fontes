#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'


User Function MVC0013()
	Local oBrowse := FWMBrowse():New()
	
	oBrowse:SetAlias('ZZB')
    oBrowse:SetMenuDef('MVC0013')
	oBrowse:SetDescription('Cadastro de ARTISTA x ÁLBUM x Música')

	oBrowse:Activate()
Return

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC0013' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC0013' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC0013' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC0013' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC0013' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC0013' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
	Local oModel

	Local oStruZZB 	:= FwFormStruct(1, "ZZB")
	Local oStruZZC 	:= FwFormStruct(1, "ZZC")
	Local oStruZZD 	:= FwFormStruct(1, "ZZD")

	oModel:= MPFormModel():New("MDREJECT")

	oModel:AddFields( "ZZBMASTER" ,			    , oStruZZB)
	oModel:AddGrid(	  "ZZCDETAIL" , "ZZBMASTER" , oStruZZC)
	oModel:AddGrid(	  "ZZDDETAIL" , "ZZCDETAIL" , oStruZZD)

	oModel:GetModel( "ZZBMASTER" ):SetOnlyView(.T.)

	oModel:SetRelation( 'ZZCDETAIL',  {{ 'ZZC_FILIAL', 'xFilial( "ZZB" ) ' } , { 'ZZC_ARTS', 'ZZB_COD' } } , ZZC->( IndexKey( 1 ) ) )
	oModel:SetRelation( 'ZZDDETAIL',  {{ 'ZZD_FILIAL', 'xFilial( "ZZC" ) ' } , { 'ZZD_ALBM', 'ZZC_COD' } } , ZZD->( IndexKey( 1 ) ) )

	oModel:setPrimarykey({ })

Return oModel

Static Function ViewDef()
	
	Local oModel    := modeldef()
	Local oView 	:= FwFormView():New()
	
	Local oStruZZB  := FwFormStruct(2, "ZZB")
	Local oStruZZC  := FWFormStruct(2, "ZZC")
	Local oStruZZD  := FWFormStruct(2, "ZZD")

	oView:SetModel(oModel)

	oView:AddField(	"VIEW_ZZB"	, oStruZZB, "ZZBMASTER")
	oView:AddGrid(	"VIEW_ZZC"	, oStruZZC, "ZZCDETAIL")
	oView:AddGrid(	"VIEW_ZZD"	, oStruZZD, "ZZDDETAIL")

	oView:CreateHorizontalBox("EMCIMA"	, 20)
	oView:CreateHorizontalBox("EMBAIXO"	, 80)

	oView:CreateVerticalBox("Esquerda"	,50, "EMBAIXO")
	oView:CreateVerticalBox("Direita"	,50, "EMBAIXO")

	oView:SetOwnerView("VIEW_ZZB", "EMCIMA")
	oView:SetOwnerView("VIEW_ZZC", "Esquerda")
	oView:SetOwnerView("VIEW_ZZD", "Direita")

	oView:EnableTitleView("VIEW_ZZB")
	oView:EnableTitleView("VIEW_ZZC", "Cadastro de Álbuns")
	oView:EnableTitleView("VIEW_ZZD", "Cadastro de Músicas")

Return oView
