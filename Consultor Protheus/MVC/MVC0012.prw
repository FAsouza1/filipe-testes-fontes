#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'


User Function MVC0012()
	Local oBrowse := FWMBrowse():New()
	
	oBrowse:SetAlias('ZZC')
    oBrowse:SetMenuDef('MVC0012')
	oBrowse:SetDescription('Cadastro de ÁLBUM x MÚSICA')

	oBrowse:Activate()
Return

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC0012' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC0012' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC0012' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC0012' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC0012' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC0012' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
	Local oModel

	Local oStruZZC 	:= FwFormStruct(1, "ZZC")
	Local oStruZZD 	:= FwFormStruct(1, "ZZD")

	oModel:= MPFormModel():New("MDREJECT")

	oModel:AddFields( "ZZCMASTER" ,			    , oStruZZC)
	oModel:AddGrid(	  "ZZDDETAIL" , "ZZCMASTER" , oStruZZD)

	oModel:GetModel( "ZZCMASTER" ):SetOnlyView(.T.)

	oModel:SetRelation( 'ZZDDETAIL',  {{ 'ZZD_FILIAL', 'xFilial( "ZZC" ) ' } , { 'ZZD_ALBM', 'ZZC_COD' } } , ZZD->( IndexKey( 1 ) ) )

	oModel:setPrimarykey({ })

Return oModel

Static Function ViewDef()
	
	Local oModel    := modeldef()
	Local oView 	:= FwFormView():New()
	
	Local oStruZZC  := FWFormStruct(2, "ZZC")
	Local oStruZZD  := FWFormStruct(2, "ZZD")

	oView:SetModel(oModel)

	oView:AddField(	"VIEW_ZZC"	, oStruZZC, "ZZCMASTER")
	oView:AddGrid(	"VIEW_ZZD"	, oStruZZD, "ZZDDETAIL")

	oView:CreateHorizontalBox("EMCIMA"	, 20)
	oView:CreateHorizontalBox("EMBAIXO"	, 80)

	oView:SetOwnerView("VIEW_ZZC", "EMCIMA")
	oView:SetOwnerView("VIEW_ZZD", "EMBAIXO")

	oView:EnableTitleView("VIEW_ZZC", "Cadastro de Álbuns")
	oView:EnableTitleView("VIEW_ZZD", "Cadastro de MÚSICAs")

Return oView
