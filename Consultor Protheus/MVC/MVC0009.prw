
#include "protheus.ch"
#include "fwmvcdef.ch"


User Function MVC0001()
Local oBrowse
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZZB')
	oBrowse:SetDescription('Cadastro de Artistas')
	oBrowse:SetMenuDef('MVC0001')
	oBrowse:Activate()
		
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC0001' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC0001' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC0001' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC0001' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC0001' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC0001' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
Local oModel
Local oStruZZB := FWFormStruct(1,"ZZB")

	oModel := MPFormModel():New("MD_Artista")
	oModel:SetDescription("Cadastro de Artista")
	
	oModel:addFields('MASTERZZB',,oStruZZB)
	oModel:getModel('MASTERZZB'):SetDescription('Dados do Artista')
	oModel:SetPrimaryKey({"ZZB->ZZB_COD"})
	 
Return oModel

Static Function ViewDef()
Local oModel := ModelDef()
Local oView
Local oStrZZB:= FWFormStruct(2, 'ZZB')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM_ARTISTA' , oStrZZB,'MASTERZZB' ) 
	oView:CreateHorizontalBox( 'BOX_FORM_ARTISTA', 100)
	oView:SetOwnerView('FORM_ARTISTA','BOX_FORM_ARTISTA')	
	
Return oView
