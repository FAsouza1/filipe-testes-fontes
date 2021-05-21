#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'


User Function MVC0011()
	Local oBrowse := FWMBrowse():New()
	
	oBrowse:SetAlias('ZZB')
    oBrowse:SetMenuDef('MVC0011')
	oBrowse:SetDescription('Cadastro de ARTISTA x ÁLBUM')

	oBrowse:Activate()
Return

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDd EF.MVC0011' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC0011' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC0011' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC0011' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC0011' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC0011' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
	Local oModel

	Local oStruZZB 	:= FwFormStruct(1, "ZZB")
	Local oStruZZC 	:= FwFormStruct(1, "ZZC")

	oModel:= MPFormModel():New("MDREJECT")

	oModel:AddFields( "ZZBMASTER" ,			    , oStruZZB)
	oModel:AddGrid(	  "ZZCDETAIL" , "ZZBMASTER" , oStruZZC)

	oModel:GetModel( "ZZBMASTER" ):SetOnlyView(.T.)

	oModel:SetRelation( 'ZZCDETAIL',  {{ 'ZZC_FILIAL', 'xFilial( "ZZB" ) ' } , { 'ZZC_ARTS', 'ZZB_COD' } } , ZZC->( IndexKey( 1 ) ) )

	oModel:setPrimarykey({ })

Return oModel

Static Function ViewDef()
	
	Local oModel    := modeldef()
	Local oView 	:= FwFormView():New()
	
	Local oStruZZB  := FWFormStruct(2, "ZZB")
	Local oStruZZC  := FWFormStruct(2, "ZZC")

	oView:SetModel(oModel)

	oView:AddField(	"VIEW_ZZB"	, oStruZZB, "ZZBMASTER")
	oView:AddGrid(	"VIEW_ZZC"	, oStruZZC, "ZZCDETAIL")

	oView:CreateHorizontalBox("EMCIMA"	, 20)
	oView:CreateHorizontalBox("EMBAIXO"	, 80)

	oView:SetOwnerView("VIEW_ZZB", "EMCIMA")
	oView:SetOwnerView("VIEW_ZZC", "EMBAIXO")

	oView:EnableTitleView("VIEW_ZZB", "Cadastro de Álbuns")
	oView:EnableTitleView("VIEW_ZZC", "Cadastro de MÚSICAs")

Return oView
