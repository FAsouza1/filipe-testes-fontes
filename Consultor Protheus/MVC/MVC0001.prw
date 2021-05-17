#include 'Protheus.ch'
#include 'FWMVCDEF.ch'

User Function MVC0009()

    Local oBrowseZZA    := FWMBrowse():New()

    oBrowseZZA:SetAlias("ZZA")
    oBrowseZZA:SetDescripition("Browse - Tabela ZZA - Cadastro de Protheuzeiro")

    oBrowseZZA:Activate()
Return 

// Static Function MenuDef()
// Return aRotina
// 
// Static Function ModelDef()
// Return oModel
// 
// Static Function ViewDef()
// Return oView
