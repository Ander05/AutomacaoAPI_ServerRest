*** Settings ***
Resource    KeywordChamada.robot

# robot .\AutomacaoApi\TestCase.robot

*** Test Cases ***
Abrindo Seção
    Criando Seção
Validação Usuário
    Gerando Dados Usuario
    Criando Login
    Login Existente
    Verificando Login Correto
    Verificando Login Incorreto
