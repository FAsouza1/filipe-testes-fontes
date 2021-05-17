
#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'


User Function MVC0013()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZZB')
	oBrowse:SetDescription('Cadastro de ARTISTA x ÁLBUM x Música')
    oBrowse:SetMenuDef('MVC0013')

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
Local oStruZZB := FWFormStruct(1,"ZZB") 
Local oStruZZC := FWFormStruct(1,"ZZC") 
Local oStruZZD := FWFormStruct(1,"ZZD") 

    oModel := MPFormModel():New("MD_ARTISTA_ÁLBUM")  
    oModel:setDescription("Cadastro de ARTISTA x ÁLBUM x Música")    

    oModel:addFields('MASTERZZB',,oStruZZB)
    oModel:getModel('MASTERZZB'):SetDescription('Dados da ARTISTA')  

    oModel:addGrid('DETAILZZC','MASTERZZB',oStruZZC)    
    oModel:getModel('DETAILZZC'):SetDescription('Dados do ÁLBUM') 
    
    oModel:setRelation("DETAILZZC", ;       
 					{{"ZZC_FILIAL",'xFilial("ZZC")'},;        
 						{"ZZC_ARTS","ZZB_COD"  }}, ;       
 						ZZC->(IndexKey(1)))         

    oModel:addGrid('DETAILZZD','DETAILZZB',oStruZZD)
    oModel:getModel('DETAILZZD'):SetDescription('Dados das Músicas do ÁLBUM')     						
    oModel:setRelation("DETAILZZD", ;       
 					{{"ZZD_FILIAL",'xFilial("ZZD")'},;        
 					{"ZZD_ARTS","ZZB_COD"  },;        
 					{"ZZD_ALBM","ZZC_COD"}}, ;       
 					ZZD->(IndexKey(1))) 	

    oModel:SetPrimaryKey({})			
 
Return oModel 

Static Function ViewDef() 
Local oModel := ModelDef() 
Local oView 
Local oStrZZB:= FWFormStruct(2, 'ZZB')   
Local oStrZZC:= FWFormStruct(2, 'ZZC')
Local oStrZZD:= FWFormStruct(2, 'ZZD')

    oStrZZC:RemoveField('ZZC_CODTUR')

	oView := FWFormView():New()  
	oView:SetModel(oModel)    
	oView:AddField('FORM_ARTISTA'   , oStrZZB,'MASTERZZB' )  
	oView:AddGrid('FORM_ALBUMS'     , oStrZZC,'DETAILZZC')  
	oView:AddGrid('FORM_MUSICAS'    , oStrZZD,'DETAILZZD')  

	oView:CreateHorizontalBox(  'BOX_CABEC'         ,20)  
	oView:CreateVerticalBox(    'BOX_FORM_ARTISTA'  ,10,'BOX_CABEC')  

	oView:CreateHorizontalBox(  'BOX_RODAP'         ,80)  
	oView:CreateVerticalBox(    'BOX_FORM_ALBUM'    ,50,'BOX_RODAP')  
    oView:CreateVerticalBox(    'BOX_FORM_MUSICAS'  ,50,'BOX_RODAP')  
	 			
 	oView:SetOwnerView('FORM_ARTISTA'   ,'BOX_FORM_ARTISTA')  
 	oView:SetOwnerView('FORM_ALBUMS'    ,'BOX_FORM_ALBUM')  	
 	oView:SetOwnerView('FORM_MUSICAS'   ,'BOX_FORM_MUSICAS')  	
		
Return oView 
