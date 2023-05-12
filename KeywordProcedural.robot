*** Settings ***
Library     RequestsLibrary    # pip install robotframework-requests
Library     FakerLibrary       # pip install robotframework-faker
Library     String
Library    Collections

*** Keywords ***
Criando Seção
    Create Session    alias=ServerRest
    ...               url=https://serverest.dev/

Gerando Dados Usuario
    ${nome}         FakerLibrary.First Name
    ${email}        FakerLibrary.Email
    ${password}     Generate Random String    length=8    chars=[LETTERS][NUMBERS]
    ${aleatorio}    Generate Random String    length=8    chars=[LETTERS][NUMBERS]

    Set Suite Variable     ${nome}
    Set Suite Variable     ${email}
    Set Suite Variable     ${password}
    Set Suite Variable     ${aleatorio}

    ${Body_CriandoUsuario}    Create Dictionary    
    ...                    nome=${nome}
    ...                    email=${email}
    ...                    password=${password}
    ...                    administrador=true

    Set Suite Variable     ${Body_CriandoUsuario}
Criando Login
    ${CriandoLogin}    POST On Session
    ...            alias=ServerRest
    ...            url=/usuarios
    ...            json=${Body_CriandoUsuario}
    ...            expected_status=201
    ...            msg=Status foi diferente de 201
    
    Dictionary Should Contain Item    ${CriandoLogin.json()}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key     ${CriandoLogin.json()}    _id

    Log   ${\n}${CriandoLogin.json()}

    Set Suite Variable    ${idUsuario}    ${CriandoLogin.json()["_id"]}

Login Existente
    ${LoginExistente}    POST On Session
    ...            alias=ServerRest
    ...            url=/usuarios
    ...            json=${Body_CriandoUsuario}
    ...            expected_status=400
    ...            msg=Status foi diferente de 400
    
    Dictionary Should Contain Item    ${LoginExistente.json()}    message    Este email já está sendo usado

    Log   ${\n}${LoginExistente.json()}

Verificando Login Correto
    ${VerificandoLoginCorreto}    GET On Session
    ...            alias=ServerRest
    ...            url=/usuarios/${idUsuario}
    ...            expected_status=200
    
    Dictionary Should Contain Item     ${VerificandoLoginCorreto.json()}    nome               ${nome}    
    Dictionary Should Contain Item     ${VerificandoLoginCorreto.json()}    email              ${email}   
    Dictionary Should Contain Item     ${VerificandoLoginCorreto.json()}    password           ${password}
    Dictionary Should Contain Item     ${VerificandoLoginCorreto.json()}    administrador      true
    Dictionary Should Contain Item     ${VerificandoLoginCorreto.json()}    _id                ${idUsuario}

    Log   ${\n}${VerificandoLoginCorreto.json()}

Verificando Login Incorreto
    ${VerificandoLoginCorreto}    GET On Session
    ...            alias=ServerRest
    ...            url=/usuarios/${aleatorio}
    ...            expected_status=400
    
    Dictionary Should Contain Item    ${VerificandoLoginCorreto.json()}    message                Usuário não encontrado

    Log   ${\n}${VerificandoLoginCorreto.json()}
