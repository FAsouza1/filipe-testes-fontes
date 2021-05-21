#include 'Protheus.ch'
#include 'FwMvcDef.ch'

User Function MVC0007()
    Local aArea     := GetArea()
    Local oBrowse   := FwmBrowse():New() 

    oBrowse:SetAlias("SZ7")
    oBrowse:SetDescription("Solicitação de Compras")

    oBrowse:Activate()
    RestArea(aArea)
Return 

Static Function MenuDef()
    Local aRotina := FwMvcMenu("MVC0007")
Return aRotina

Static Function ModelDef()
    Local oStCabec   :=  FWFormModelStruct():New()
    Local oStItens   :=  FwFormStruct(1,"SZ7")
    Local bVldPos    :=  {|| u_VldSZ7()} 
    Local bVldCom    :=  {|| u_GrvSZ7()} 
    Local oModel     :=  MPFormModel():New("MVC0007m",/*bPre*/, bVldPos /*bPos*/, bVldCom /*bCommit*/,/*bCancel*/)
    Local aTrigQuant :=  {}
    Local aTrgPreco  :=  {}

    oStCabec:AddTable(  "SZ7",{"Z7_FILIAL","Z7_NUM","Z7_ITEM"},"Cabeçalho SZ7"  )

    oStCabec:AddField(  "Filial"    ,"Filial"    ,"Z7_FILIAL" ,"C",TamSX3("Z7_FILIAL" )[1],0,Nil,Nil,{},.F.,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif( !INCLUI , SZ7->Z7_FILIAL    , FWxFilial('SZ7'))"         ),.T.,.F.,.F.)      
    oStCabec:AddField(  "Pedido"    ,"Pedido"    ,"Z7_NUM"    ,"C",TamSX3("Z7_NUM"    )[1],0,Nil,Nil,{},.F.,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif( !INCLUI , SZ7->Z7_NUM       , GetSXENum("SZ7","Z7_NUM"))"),.T.,.F.,.F.)      
    oStCabec:AddField(  "Emissao"   ,"Emissao"   ,"Z7_EMISSAO","D",TamSX3("Z7_EMISSAO")[1],0,Nil,Nil,{},.T.,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif( !INCLUI , SZ7->Z7_EMISSAO   , dDataBase)"                ),.T.,.F.,.F.)
    oStCabec:AddField(  "Fornecedor","Fornecedor","Z7_FORNECE","C",TamSX3("Z7_FORNECE")[1],0,Nil,Nil,{},.T.,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif( !INCLUI , SZ7->Z7_FORNECE   , '')"                       ),.F.,.F.,.F.)                                                                        
    oStCabec:AddField(  "Loja"      ,"Loja"      ,"Z7_LOJA"   ,"C",TamSX3("Z7_LOJA"   )[1],0,Nil,Nil,{},.T.,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif( !INCLUI , SZ7->Z7_LOJA      , '')"                       ),.F.,.F.,.F.)                                                                          
    oStCabec:AddField(  "Usuario"   ,"Usuario"   ,"Z7_USER"   ,"C",TamSX3("Z7_USER"   )[1],0,Nil,Nil,{},.T.,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif( !INCLUI , SZ7->Z7_USER      , __cuserid)"                ),.F.,.F.,.F.)                                                                            


    oStItens:SetProperty(   "Z7_NUM",      MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD , '"*"'       ) )
    oStItens:SetProperty(   "Z7_USER",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD , '__cUserId' ) ) 
    oStItens:SetProperty(   "Z7_EMISSAO",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD , 'dDatabase' ) ) 
    oStItens:SetProperty(   "Z7_FORNECE",  MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD , '"*"'       ) )
    oStItens:SetProperty(   "Z7_LOJA",     MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD , '"*"'       ) )

    aTrigQuant  := FwStruTrigger("Z7_QUANT", "Z7_TOTAL", "M->Z7_QUANT * M->Z7_PRECO", .F.)
    aTrigPreco  := FwStruTrigger("Z7_PRECO", "Z7_TOTAL", "M->Z7_QUANT * M->Z7_PRECO", .F.)

    oStItens:AddTrigger(  aTrigQuant[1],aTrigQuant[2],aTrigQuant[3],aTrigQuant[4] )
    oStItens:AddTrigger(  aTrigPreco[1],aTrigPreco[2],aTrigPreco[3],aTrigPreco[4] )

    oModel:AddFields(   "SZ7MASTER",           , oStCabec   ) 
    oModel:AddGrid(     "SZ7DETAIL","SZ7MASTER", oStItens   )

    oModel:AddCalc("SZ7TOTAIS","SZ7MASTER","SZ7DETAIL","Z7_PRODUTO" ,"QTDITENS","COUNT",,, "Número de Produtos")
    oModel:AddCalc("SZ7TOTAIS","SZ7MASTER","SZ7DETAIL","Z7_QUANT"   ,"QTDTOTAL","SUM"  ,,, "Total de Itens")
    oModel:AddCalc("SZ7TOTAIS","SZ7MASTER","SZ7DETAIL","Z7_TOTAL"   ,"PRCTOTAL","SUM"  ,,, "Preço total da Solicitação de Compras")


    aRelations := {}
    aAdd(aRelations,{"Z7_FILIAL",'Iif(!INCLUI, SZ7->Z7_FILIAL, FWxFilial("SZ7"))'})
    aAdd(aRelations,{"Z7_NUM","SZ7->Z7_NUM"})

    oModel:SetRelation("SZ7DETAIL",aRelations,SZ7->(IndexKey(1)))
    oModel:SetRelation('SZ7DETAIL',{{'Z7_FILIAL','Iif(!INCLUI, SZ7->Z7_FILIAL, FWxFilial("SZ7"))'},{'Z7_NUM','SZ7->Z7_NUM'}},SZ7->(IndexKey(1)))
    oModel:SetPrimaryKey({})


    oModel:GetModel("SZ7DETAIL"):SetUniqueline({"Z7_ITEM"}) 
    oModel:GetModel("SZ7MASTER"):SetDescription("CABEÇALHO DA SOLICITAÇÃO DE COMPRAS")
    oModel:GetModel("SZ7DETAIL"):SetDescription("ITENS DA SOLICITAÇÃO DE COMPRAS")
    oModel:GetModel("SZ7DETAIL"):SetUseOldGrid(.T.) 

Return oModel

Static Function ViewDef()
    Local oView         := Nil
    Local oModel        := FwLoadModel("MVC0007")
    Local oStCabec      := FwFormViewStruct():New()
    Local oStItens      := FwFormStruct(2,"SZ7")
    Local oStTotais     := FWCalcStruct( oModel:GetModel('SZ7TOTAIS') )

    oStCabec:AddField(  "Z7_NUM"     , "01" , "Pedido"      , X3Descric('Z7_NUM')     ,, "C" ,X3Picture("Z7_NUM")     ,,      , .F.                   )                 
    oStCabec:AddField(  "Z7_EMISSAO" , "02" , "Emissao"     , X3Descric('Z7_EMISSAO') ,, "D" ,X3Picture("Z7_EMISSAO") ,,      , Iif(INCLUI, .T., .F.) )  
    oStCabec:AddField(  "Z7_FORNECE" , "03" , "Fornecedor"  , X3Descric('Z7_FORNECE') ,, "C" ,X3Picture("Z7_FORNECE") ,, "SA2", .T.                   ) 
    oStCabec:AddField(  "Z7_LOJA"    , "04" , "Loja"        , X3Descric('Z7_LOJA')    ,, "C" ,X3Picture("Z7_LOJA")    ,,      , Iif(INCLUI, .T., .F.) )
    oStCabec:AddField(  "Z7_USER"    , "05" , "Usuário"     , X3Descric('Z7_USER')    ,, "C" ,X3Picture("Z7_USER")    ,,      , .F.                   ) 

    oStItens:RemoveField(   "Z7_NUM"      )
    oStItens:RemoveField(   "Z7_EMISSAO"  )
    oStItens:RemoveField(   "Z7_FORNECE"  )            
    oStItens:RemoveField(   "Z7_LOJA"     )      
    oStItens:RemoveField(   "Z7_USER"     ) 

    oStItens:SetProperty(   "Z7_ITEM" , MVC_VIEW_CANCHANGE, .F.)
    oStItens:SetProperty(   "Z7_TOTAL", MVC_VIEW_CANCHANGE, .F.)


    oView := FwFormView():New()
    oView:SetModel(oModel)
    oView:AddField( "VIEW_SZ7M"  ,oStCabec , "SZ7MASTER" ) 
    oView:AddGrid(  "VIEW_SZ7D"  ,oStItens , "SZ7DETAIL" ) 
    oView:AddField( "VIEW_TOTAL" ,oStTotais, "SZ7TOTAIS" )

    oView:AddIncrementField("SZ7DETAIL","Z7_ITEM")

    oView:CreateHorizontalBox( "CABEC" ,20 )
    oView:CreateHorizontalBox( "GRID"  ,50 )
    oView:CreateHorizontalBox( "TOTAL" ,30 )

    oView:SetOwnerView( "VIEW_SZ7M" , "CABEC" ) 
    oView:SetOwnerView( "VIEW_SZ7D" , "GRID"  )  
    oView:SetOwnerView( "VIEW_TOTAL", "TOTAL" )

    oView:EnableTitleView(  "VIEW_SZ7M"  , "Cabeçalho Solicitação de Compras"            )
    oView:EnableTitleView(  "VIEW_SZ7D"  , "Itens de Solicitacao de Compras"             )
    oView:EnableTitleView(  "VIEW_TOTAL" , "Resumo da Solicitação de compras TOTALIZADA" )

    oView:SetCloseOnOk({|| .T.})

Return oView


User Function GrvSZ7()
    Local aArea       := GetArea()  
    Local lRet        := .T.
    Local oModel      := FwModelActive()
    Local oModelCabec := oModel:GetModel("SZ7MASTER")
    Local oModelItem  := oModel:GetModel("SZ7DETAIL") 
    Local cFilSZ7     := oModelCabec:GetValue("Z7_FILIAL")
    Local cNum        := oModelCabec:GetValue("Z7_NUM")
    Local dEmissao    := oModelCabec:GetValue("Z7_EMISSAO")
    Local cFornece    := oModelCabec:GetValue("Z7_FORNECE")
    Local cLoja       := oModelCabec:GetValue("Z7_LOJA")
    Local cUser       := oModelCabec:GetValue("Z7_USER")
    Local aHeaderAux  := oModelItem:aHeader
    Local aColsAux    := oModelItem:aCols  
    Local nPosItem    := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_ITEM")})
    Local nPosProd    := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRODUTO")})
    Local nPosQtd     := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_QUANT")})
    Local nPosPrc     := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_PRECO")})
    Local nPosTotal   := aScan(aHeaderAux, {|x| AllTrim(Upper(x[2])) == AllTrim("Z7_TOTAL")})
    Local nLinAtu     := 0
    Local cOption     := oModelCabec:GetOperation()

    DbSelectArea("SZ7")
    SZ7->(DbSetOrder(1))

    IF cOption == MODEL_OPERATION_INSERT
        For nLinAtu:= 1 to Len(aColsAux)
            IF !aColsAux[nLinAtu][Len(aHeaderAux)+1]
                RecLock("SZ7",.T.)
                    Z7_FILIAL       :=  cFilSZ7
                    Z7_NUM          :=  cNum   
                    Z7_EMISSAO      :=  dEmissao
                    Z7_FORNECE      :=  cFornece
                    Z7_LOJA         :=  cLoja
                    Z7_USER         :=  cUser

                    //DADOS DO GRID
                    Z7_ITEM         :=  aColsAux[nLinAtu,nPosItem]
                    Z7_PRODUTO      :=  aColsAux[nLinAtu,nPosProd]
                    Z7_QUANT        :=  aColsAux[nLinAtu,nPosQtd]
                    Z7_PRECO        :=  aColsAux[nLinAtu,nPosPrc]
                    Z7_TOTAL        :=  aColsAux[nLinAtu,nPosTotal] 
                SZ7->(MSUNLOCK())
            ENDIF
        Next
    ELSEIF  cOption == MODEL_OPERATION_UPDATE
        For nLinAtu:= 1 to Len(aColsAux)
            IF aColsAux[nLinAtu][Len(aHeaderAux)+1]
                SZ7->(DbSetOrder(2))
                IF SZ7->(DbSeek(cFilSZ7 + cNum + aColsAux[nLinAtu,nPosItem]))
                    RECLOCK("SZ7",.F.)
                        DbDelete()
                    SZ7->(MSUnlock())
                ENDIF

            ELSE
                SZ7->(DbSetOrder(2))
                IF SZ7->(DbSeek(cFilSZ7 + cNum + aColsAux[nLinAtu,nPosItem]))
                    RecLock("SZ7",.F.)
                        //DADOS DO CABEÇALHO
                        Z7_FILIAL       :=  cFilSZ7 
                        Z7_NUM          :=  cNum    
                        Z7_EMISSAO      :=  dEmissao
                        Z7_FORNECE      :=  cFornece
                        Z7_LOJA         :=  cLoja
                        Z7_USER         :=  cUser
                        //DADOS DO GRID
                        Z7_ITEM         :=  aColsAux[nLinAtu,nPosItem]
                        Z7_PRODUTO      :=  aColsAux[nLinAtu,nPosProd]
                        Z7_QUANT        :=  aColsAux[nLinAtu,nPosQtd]
                        Z7_PRECO        :=  aColsAux[nLinAtu,nPosPrc]
                        Z7_TOTAL        :=  aColsAux[nLinAtu,nPosTotal] 
                    SZ7->(MSUNLOCK())
                ELSE
                    RecLock("SZ7",.T.)
                        Z7_FILIAL       :=  cFilSZ7 
                        Z7_NUM          :=  cNum    
                        Z7_EMISSAO      :=  dEmissao
                        Z7_FORNECE      :=  cFornece
                        Z7_LOJA         :=  cLoja
                        Z7_USER         :=  cUser
                        //DADOS DO GRID
                        Z7_ITEM         :=  aColsAux[nLinAtu,nPosItem]
                        Z7_PRODUTO      :=  aColsAux[nLinAtu,nPosProd]
                        Z7_QUANT        :=  aColsAux[nLinAtu,nPosQtd]
                        Z7_PRECO        :=  aColsAux[nLinAtu,nPosPrc]
                        Z7_TOTAL        :=  aColsAux[nLinAtu,nPosTotal] 
                    SZ7->(MSUNLOCK())            
                ENDIF        
            ENDIF
        Next 

    ELSEIF cOption == MODEL_OPERATION_DELETE
        SZ7->(DbSetOrder(1))
        WHILE !SZ7->(EOF()) .AND. SZ7->Z7_FILIAL = cFilSZ7 .AND. SZ7->Z7_NUM = cNum 
            RECLOCK("SZ7",.F.)
                DbDelete()
            SZ7->(MSUNLOCK())

        SZ7->(dbSkip())
        ENDDO
    ENDIF  

    RestArea(aArea)
return lRet

User Function VldSZ7()
    Local lRet      :=  .T.
    Local aArea     := GetArea()
    Local oModel        := FwModelActive()
    Local oModelCabec    := oModel:GetModel("SZ7MASTER")
    Local cFilSZ7   :=  oModelCabec:GetValue("Z7_FILIAL")
    Local cNum      :=  oModelCabec:GetValue("Z7_NUM")
    Local cOption   := oModelCabec:GetOperation()

    IF cOption  == MODEL_OPERATION_INSERT
        DbSelectArea("SZ7")
        SZ7->(DbSetOrder(1))
        IF SZ7->(DbSeek(cFilSZ7+cNum))
            Help(NIL, NIL, "Escolha outro número de pedido", NIL, "Este pedido/solicitação de compras já existe em nosso sistema", 1, 0, NIL, NIL, NIL, NIL, NIL, {"ATENÇÃO"})			
            lRet := .F.
        Endif
    ENDIF

    RestArea(aArea)
Return lRet
