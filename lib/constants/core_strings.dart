class CoreStrings {

  //A
  static const String appName = 'LockPass';
  static const String add = 'Add';
  static const String addNewGroup = 'Adicionar Novo Grupo';
  static const String automatic = 'automatic';

  //C
  static const String cancel = 'Cancelar';
  static const String chooseFileUpload = 'Escolha o arquivo para carregar.';
  static const String chooseGroupOrRegisterNew = 'Escolha um Grupo ou Cadastre um Novo';
  static const String config = 'Configurações';
  static const String createYourPin = 'Crie seu PIN';

  //D
  static const String db = '_itens.db';
  static const String decrypt = 'Descriptografar';
  static const String delete = 'Excluir';
  static const String deletePin = 'Excluir PIN';
  static const String deleteThisLogin = "Realmente deseja excluir esse login?";

  //E
  static const String email = 'Email';
  static const String emailInvalid = 'Email Inválido!';
  static const String emailRegistered = 'Digite o email cadastrado';
  static const String emailRegister = 'Email de Cadastro';
  static const String enter = 'Entrar';
  static const String enterLogin = 'Entrar com Login';
  static const String enterPin = 'Entrar com PIN';
  static const String enterYourPinForDecryption = 'Digite seu PIN para descriptografar sua lista de logins.';  
  
  //F
  static const String fillField = 'Por favor preencha o campo!';
  static const String forgotPassword = 'Esqueceu a senha?';
  static const String forgotPin = 'Esqueceu seu PIN?';  

  //G
  static const String group = 'Grupo';

  //I
  static const String iconApp = 'assets/icone_lockpass_.png';
  static const String info = 'Informação';
  static const String itemRemoved = 'Seu item foi removido!';

  //L
  static const String list = 'Lista';
  static const String load = 'Carregar';
  static const String loadList = 'Carregar Lista';
  static const String loadListLogins = 'Carregar Lista de Logins';
  static const String login = 'Login';
  static const String logout = 'Deslogar';
  static const String labelService = 'Ex: Gmail';
  static const String labelWebSite = 'Ex: www.gmail.com';
  static const String labelGroup = 'Ex: Email';
  static const String labelEmailRegister = 'Ex: teste@gmail.com';
  static const String labelPin = 'Ex: 32893';
  
  //M
  static const String manual = 'manual';

  //N
  static const String nameService = 'Nome do Serviço';
  static const String newPin = 'Novo PIN';
  static const String noDefinedGroup = "Sem Grupo Definido";
  static const String notFoundItem = 'Nenhum item encontrado!';  

  //O
  static const String obscurePassword = '****';

  //P
  static const String password = 'Password';
  static const String pin = 'PIN';
  static const String pinDoesNotMatch = 'O PIN não corresponde a senha do arquivo.';
  static const String pinMustContain = 'O PIN deve conter 5 números.';
  static const String pinRemoved = 'Seu PIN foi removido!';
  static const String provideEmail = 'Informe o Email';  
  
  //R
  static const String regExpValidatePin = r'^(?:([0-9])(?!\1)){5}$';
  static const String regExpValidateEmail = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String register1 = 'Cadastro';
  static const String register2 = 'Cadastrar';
  static const String registerHere = 'Não tem login? Crie aqui!';
  static const String registerPin = 'Cadastrar PIN';
  static const String resetPassword = 'Redefinir Senha';
  static const String resetPin = 'Redefinir PIN';  

  //S
  static const String save = 'Salvar';
  static const String saveList = 'Salvar Lista';
  static const String savedBackup = 'Backup Salvo';
  static const String saveListLogins = 'Salvar Lista de Logins';
  static const String searchLogin = 'Busca por Login';
  static const String selectGroup = 'Selecione um grupo já criado ou cadastre um novo grupo abaixo';
  static const String send = 'Enviar';
  static const String service = 'Serviço';
  static const String showAnymore = 'Não mostrar mais!';

  //T
  static const String typeItPin = 'Digite o PIN';

  //U
  static const String updatePin = 'Atualizar PIN';
  static const String userCreateSucess = 'Usuário criado com Sucesso!';  

  //W
  static const String wantDeleteRegisteredPin = 'Deseja excluir o PIN cadastrado?';
  static const String wantLogout = 'Você realmente quer deslogar?';
  static const String webSite = 'Site';

  //Y
  static const String yourUploadedLoginList = 'Sua lista de logins salva foi carregada.';

  //Errors Firebase Authentication
  static const String fWeakPassword = 'A senha é muito fraca!';
  static const String fEmailAlreadyInUse = 'Este email já está cadastrado!';
  static const String fEmailInvalid = 'Este email não é válido!';
  static const String fUserNotFound = 'Email não encontrado!';
  static const String fInvalidLoginCredentials = 'Email ou senha incorretos. Tente novamente!';
  static const String fWrongPassword = 'Um ou mais campos estão vazios!';
  static const String missingEmail = 'Campo de email vazio!';

  //Page Navigation
  static const String nHome = '/home';
  static const String nLogin = '/login';

  //Info
  static const String invalidSignatureZip = 'Assinatura do PIN inválida.';
  static const String infoChooseFileUpload = 'Escolha o arquivo contendo a lista de login que você salvou!\n\n'
                      'Você poderá encontrar a lista com o nome de "lockpass_db_manual".\n\n'
                      'Caso nunca tenha salvo sua lista de logins, poderá carregar'
                      ' a lista salva automaticamente ao entrar no app. O nome do arquivo é'
                      ' lockpass_db_automatic.';
  static const String manyEmptyFields = 'Um ou mais campos necessários não foram preenchidos.';
  static const String updateSucess = 'Você atualizou as informações com sucesso!';
  static const String updateError = 'Houve um erro na atualização.';
  static const String updateCardItem = 'Você atualizou as informações com sucesso!';
  static const String infoEmailInvalid = 'Utilize um email válido para criar seu cadastro. Após a criação do cxadastro, poderá acessar o app.';
  static const String noticeCreatePin = 'Vá até configurações e crie seu PIN para dar mais segurança no acesso as suas senhas.\n'
                  'Você poderá continuar utilizando o APP sem que crie um PIN! Mas lembre-se que qualquer '
                  'pessoa que tiver acesso ao seu celular, poderá ter acesso as senhas, caso você não crie um PIN.';
  static const String pinNotCreated = 'Você ainda não criou um PIN!';
  static const String enterYourPin = 'Você não digitou o seu PIN!';
  static const String pinIncorrect = 'O PIN digitado está incorreto!';
  static const String needCreateNewPin = 'Caso você tenha esquecido seu PIN, precisará criar um novo. '
                      'Utilize seu login para poder criar um novo PIN.';
  static const String receivePasswordResetLink = 'Utilize seu email cadastrado para receber um link de redefinição de senha.';
  static const String wantSaveListLogin = 'Deseja salvar sua lista de logins?';
  static const String infoSaveList = 'Você irá salvar um arquivo zip contendo sua lista de logins salvos no App.';
  static const String choiceFile = 'Você precisa escolher um arquivo para ser carregado.';
  static const String loadedList = 'Sua lista de logins salva, foi carregada.';
  static const String pinInfo = 'Não digite números iguais em sequência\n'
                    '\n'
                    'Ex: 11111, 25400 ou 78883.'
                    '\n\n';                 
                    
  static const String pinVazio = 'O PIN está vazio ou contém menos do que 5 números.\n'
                    '\n'
                    'Digite um valor contendo 5 números.'
                    '\n'
                    'Ex: 14279 ou 43835.\n'
                    '\n';
  static const String pinCreated = 'PIN criado com Sucesso';
  static const String pinUseInfo = 'Guarde o número do seu PIN para poder acessar o App e ter acesso as suas senhas.';
  static const String invalidePin = 'PIN Inválido';
  static const String infoSaveBackUpIos = 'Para acessar seu arquivo de backup, acesse "No Meu Iphone"'
            'e procure pela pasta "LockPass", nessa pasta estará o arquivo "lockpass_db_manual".\n'
            '\n'            
            'Você poderá utilizar esse backup para recuperar suas senhas,'
            'caso você troque de aparelho celular.\n'
            '\n'
            'Caso você tenha cadastrado um PIN, ele será a senha do arquivo.';
  static const String infoSaveBackUpAndroid = 'Para acessar seu arquivo de backup, acesse o "Gerenciador de Arquivos"'
            ' e procure pela pasta "Downloads", você irá encontrar a pasta LockPass e nela o arquivo "lockpass_db_manual".\n'
            '\n'            
            'Você poderá utilizar esse backup para recuperar suas senhas,'
            'caso você troque de aparelho celular.\n'
            '\n'
            'Caso você tenha cadastrado um PIN, ele será a senha do arquivo.';
  

}