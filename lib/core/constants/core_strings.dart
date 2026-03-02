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
  static const String deleteAccount = 'Excluir sua Conta';
  static const String deleteAccountTitle = 'Excluir Conta';

  //E
  static const String email = 'Email';
  static const String emailInvalid = 'Email Inválido!';
  static const String emailRegistered = 'Digite o email cadastrado';
  static const String emailRegister = 'Email de Cadastro';
  static const String enter = 'Entrar';
  static const String enterEmailAndPassword = 'Entrar com e-mail e senha';
  static const String enterLogin = 'Entrar com Login';
  // static const String enterPin = 'Entrar com PIN';
  static const String enterYourPinForDecryption = 'Digite seu PIN para descriptografar sua lista de logins.';

  //F
  static const String fieldRequired = 'Campo obrigatório';
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
  static const String restoreListLogins = 'Restaurar Lista de Logins';
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
  static const String passwordRequired = "A senha é obrigatória";
  static const String passwordMinLength = "Mínimo de 6 caracteres";
  static const String pin = 'PIN';
  static const String pinDoesNotMatch = 'O PIN não corresponde a senha do arquivo.';
  static const String pinMustContain = 'O PIN deve conter 5 números.';
  static const String pinRemoved = 'Seu PIN foi removido!';
  static const String pinWeak = "PIN muito fraco. Escolha uma combinação menos previsível.";
  static const String provideEmail = 'Informe o Email';

  //R
  // static const String regExpValidatePin = r'^(?:([0-9])(?!\1)){5}$';
  static const String regExpValidateEmail = r'^[^@]+@[^@]+\.[^@]+$';
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
  static const String searchLogin = 'Buscar Item';
  static const String selectGroup = 'Selecione um grupo já criado ou cadastre um novo grupo abaixo';
  static const String send = 'Enviar';
  static const String sending = "Enviando...";
  static const String service = 'Serviço';
  static const String showAnymore = 'Não mostrar mais!';

  //T
  static const String typeItPin = 'Digite o PIN';

  //U
  static const String updatePin = 'Atualizar PIN';
  static const String userCreateSuccess = 'Usuário criado com Sucesso!';

  //W
  static const String wantDeleteRegisteredPin = 'Deseja excluir o PIN cadastrado?';
  static const String wantLogout = 'Você realmente quer deslogar?';
  static const String webSite = 'Site';
  static const String wantDeleteAccount =
      'Você está prestes a excluir o seu login.\n\nSe tiver certeza sobre isso, apenas aperta o botão excluir.';

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
  static const String fUserDisabled = 'Este usuário foi desabilitado.';

  //Page Navigation
  static const String homePage = '/home';
  static const String loginPage = '/login';

  //Info
  static const String invalidSignatureZip = 'Assinatura do PIN inválida.';
  static const String infoChooseFileUpload = '''
    Escolha o arquivo contendo o backup de logins que você salvou!

    Você poderá encontrar os seus arquivos manuais com o nome 'LPB' + (data) + (hora) na pasta que você criou para salvar sua lista de logins.

    Caso nunca tenha exportado sua lista manualmente, você pode carregar o backup salvo automaticamente pelo sistema. O nome desse arquivo é LPB_automatic.

    O backup automático salva a sua última lista de logins no momento exato em que você acessa o app."
  ''';
  static const String manyEmptyFields = 'Um ou mais campos necessários não foram preenchidos.';
  static const String updateSucess = 'Você atualizou as informações com sucesso!';
  static const String updateError = 'Houve um erro na atualização.';
  static const String updateCardItem = 'Você atualizou as informações com sucesso!';
  static const String infoEmailInvalid =
      'Utilize um email válido para criar seu cadastro. Após a criação do cxadastro, poderá acessar o app.';
  static const String noticeCreatePin = 'Crie um PIN para facilitar e proteger o acesso ao aplicativo.\n'
      'O PIN permite que você desbloqueie o app de forma rápida e segura após o login.\n'
      'Sempre que o aplicativo for reaberto, será necessário autenticação.';
  static const String pinNotCreated = 'Você ainda não criou um PIN!';
  static const String enterYourPin = 'Você não digitou o seu PIN!';
  static const String pinIncorrect = 'O PIN digitado está incorreto!';
  static const String needCreateNewPin = 'Caso você tenha esquecido seu PIN, precisará criar um novo. '
      'Utilize seu login para poder criar um novo PIN.';
  static const String receivePasswordResetLink =
      'Utilize seu email cadastrado para receber um link de redefinição de senha.';
  static const String wantSaveListLogin = 'Escolha como deseja salvar sua lista de logins:';
  static const String infoSaveList = 'Você irá salvar um arquivo zip contendo sua lista de logins salvos no App.';
  static const String infoSaveListIos = "Um arquivo ZIP contendo sua lista de logins será gerado. "
      "Você pode optar por salvar o arquivo no dispositivo, escolhendo uma pasta de sua preferência, "
      "ou compartilhá-lo por meio de um aplicativo ou serviço de nuvem.\n\n"
      "Dica: Caso não consiga selecionar uma pasta, toque no ícone de três pontos (...) "
      "e crie uma nova pasta para autorizar o salvamento no seu iPhone.";
  static const String infoSaveListAndroid = "Um arquivo ZIP contendo sua lista de logins será gerado. "
      "Você pode optar por salvar o arquivo no dispositivo, escolhendo uma pasta de sua preferência, "
      "ou compartilhá-lo por meio de um aplicativo ou serviço de nuvem.";
  static const String choiceFile = 'Você precisa escolher um arquivo para ser carregado.';
  static const String loadedList = 'Sua lista de logins salva, foi carregada.';
  static const String pinInfo = '''Para proteger seus dados, o PIN deve seguir estas regras:\n
Sem sequências simples: Evite números em ordem (ex: 12345 ou 54321).\n
Sem repetições excessivas: Não use o mesmo número 3 ou mais vezes seguidas (ex: 11123 ou 24666).\n
Evite o óbvio: Não use datas de nascimento ou padrões previsíveis (ex: 11111).\n
Um bom PIN é aquele que só você conhece e que não segue padrões previsíveis."\n''';
  static const String pinVazio = 'O PIN está vazio ou contém menos do que 5 números.\n'
      '\n'
      'Digite um valor contendo 5 números.'
      '\n'
      'Ex: 14279 ou 43835.\n'
      '\n';
  static const String pinCreated = 'PIN criado com Sucesso';
  static const String pinUseInfo = 'Guarde o número do seu PIN, para poder acessar o App e ter acesso as suas senhas.';
  static const String invalidePin = 'PIN Inválido';
  static const String infoSaveBackUpIos = 'Para acessar seu arquivo de backup, acesse "No Meu iPhone" '
      'e procure pela pasta que você criou para salvar o backup. Nela estará o arquivo '
      'que se inicia com "LPB", contendo a data e hora em que foi salvo.\n\n'
      'Você poderá utilizar esse backup para recuperar suas senhas, '
      'caso você troque de aparelho celular.\n';

  static const String infoSaveBackUpAndroid = 'Para acessar seu arquivo de backup, acesse o "Gerenciador de Arquivos" '
      'e procure pela pasta onde você salvou o backup. Nela você encontrará o arquivo '
      'que inicia com "LPB", seguido pela data e hora de criação.\n\n'
      'Você poderá utilizar esse backup para recuperar suas senhas, '
      'caso você troque de aparelho celular.\n';

  static const String passwordResetEmailSent =
      'Enviamos um e-mail para o endereço que você digitou. O e-mail contém um link para redefinir sua senha!';
  static const String loginWithPin = "Logar com PIN";
  static const String validating = "Validando...";
  static const String signInWithPin = "Entrar com PIN";
  static const String signingIn = "Entrando...";
  static const String moveToTrash = "Mover para Lixeira";
  static const String noItemsFound = "Nenhum item foi encontrado! Adicione um item.";
  static const String notInformed = "Não informado!";
  static const String showDeleted = "Mostrar Excluídos";
  static const String loading = "Carregando...";
  static const String enterFiveDigitPin = "Digite seu PIN de 5 dígitos para prosseguir.";
  static const String insertAccessCredentials = "Insira suas credenciais de acesso.";
  static const String showDeletedExplanation =
      "Caso deseje rever itens que foram excluídos, prossiga com a validação de segurança.\n\nApós a validação, a tela de listagem exibirá todos os itens excluídos até o momento. Lá, você poderá restaurar um item, apagá-lo permanentemente ou sair do modo de visualização a qualquer momento.";
  static const String showDeletedItemsAction = "Mostrar Itens Excluídos";
  static const String securityValidation = "Validação de Segurança";
  static const String credentialsValid = "Suas credenciais estão válidas";
  static const String close = "Fechar";
  static const String restore = "Restaurar";
  static const String deletePermanently = "Excluir Permanentemente";
  static const String irreversibleActionWarning = "Essa ação é irreversível. Você não poderá recuperar esse item!";
  static const String saving = "Salvando...";
  static const String itemRestoredSuccess = "Item restaurado";
  static const String itemDeletedPermanentlySuccess = "Item excluído permanentemente";
  static const String itemUpdatedSuccess = "Item atualizado com sucesso!";

  // Busca e Filtros
  static const String noItemsFoundInSearch = "Nenhum item foi encontrado na busca!";
  
  // Lixeira
  static const String emptyTrash = "Lixeira Vazia!";
  static const String trashMode = "Modo Lixeira";
  static const String showDeletedItemsQuestion = "Mostrar itens Excluídos?";


  static const String pinValidationError = "Erro ao validar PIN.";
static const String credentialsValidationError = "Erro ao validar credenciais.";
static const String deletePermanentlyError = "Erro ao excluir permanentemente";
static const String restoreItemError = "Erro ao restaurar item";
static const String moveToTrashError = "Erro ao mover item para lixeira";
static const String deleteItemError = "Erro ao excluir item! Tente novamente.";
static const String updateItemError = "Não foi possível atualizar o item.";
static const String loadItemsError = "Erro ao carregar itens";

static const String movedToTrashSuccess = "Item movido para lixeira";
static const String itemRemovedSuccess = "Item removido com sucesso";
static const String loggedInAs = "Logado:";
static const String shareListExplanation = "Escolha essa opcao, caso queira compartilhar a lista em um aplicativo ou servico de nuvem.";
static const String shareListAction = "Compartilhar Lista";
static const String backupSharedSuccess = "Backup compartilhado com sucesso.";
static const String saveToDeviceAction = "Salvar no Dispositivo";
static const String saveToDeviceExplanation = "Escolha essa opcao, caso queira salvar a lista em uma pasta no seu proprio aparelho celular.";
static const String automaticBackup = "Backup Automático";
static const String automaticBackupExplanation = "O app seleciona o backup feito no seu último login.";

static const String manualBackup = "Backup Manual";
static const String manualBackupExplanation = "Selecione o arquivo de logins que você mesmo salvou (LPB).";
static const String loadAutomaticBackupQuestion = "Deseja carregar o backup automático?";
static const String loadAutomaticBackupDetail = "O backup automático é salvo toda vez que você loga no app para garantir a segurança dos seus dados. Ao carregar um backup automático, você estará restaurando seus dados para o estado mais recente salvo automaticamente pelo sistema. Certifique-se de que deseja prosseguir com esta ação, pois ela substituirá dados salvos após o último login.";
static const String resetting = "Resetando... ";
static const String resetPinAction = "Resetar PIN";
static const String resetPinExplanation = "Confirme sua identidade digitando seu e-mail e senha cadastrados. Após a validação, você poderá criar um novo PIN de acesso.";
static const String removing = "Removendo... ";
static const String removePinAction = "Remover PIN";
static const String forgotPinAction = "Esqueceu o PIN? Clique Aqui!";
static const String enterCurrentPin = "Digite seu PIN atual";
static const String removePinExplanation = "Digite o PIN atual para confirmar sua identidade.\n\nAo remover o PIN, o acesso ao aplicativo passará a ser realizado utilizando o e-mail e a senha cadastrados.\n\nCaso deseje, será possível criar um novo PIN posteriormente.";
static const String signingOut = "Deslogando... ";
static const String logoutAction = "Deslogar";
static const String logoutConfirmationQuestion = "Você tem certeza que deseja deslogar?\n\nApós sair, será necessário entrar novamente com seu e-mail e senha. O PIN poderá ser usado novamente após o login.";

static const String screenLockTitle = "Bloqueio de Tela";
static const String screenLockExplanation = "Escolha em quanto tempo o app será bloqueado.\n\nIsso vale quando você ficar sem mexer ou alternar para outro app.\n\nObs: Não bloquear é menos seguro.";

static const String doNotLock = "Não Bloquear";
static const String duration15s = "15 segundos";
static const String duration30s = "30 segundos";
static const String duration45s = "45 segundos";
static const String duration60s = "60 segundos";
static const String deleteAccountAction = "Excluir Conta";
static const String deleteAccountConfirmation = "Você está prestes a excluir sua conta. Essa ação é irreversível. Tem certeza que deseja continuar?";
static const String deleting = "Excluindo... ";
static const String enterPin = "Digite o PIN";
static const String enterNewPin = "Digite o novo PIN";

static const String changing = "Alterando... ";
static const String change = "Alterar";
static const String changePasswordAction = "Alterar Senha";

static const String enterCurrentPassword = "Digite sua senha atual";
static const String enterNewPassword = "Digite sua nova senha";

static const String passwordRequirementsTitle = "Requisitos de Senha";
static const String passwordRequirementsExplanation = "Para garantir a segurança dos seus dados, sua nova senha deve conter no mínimo 6 caracteres.\n\nRecomendamos o uso de combinações de letras, números e caracteres para tornar seu cofre ainda mais protegido.";

static const String changePasswordConfirmation = "Tem certeza que deseja alterar sua senha de login? Essa ação irá deslogar sua conta e você precisará fazer login novamente com a nova senha.";
static const String screenLockTimer = "Timer: Bloqueio de Tela";
static const String saveLockTimerError = "Ocorreu um erro ao tentar salvar o timer de bloqueio.";
static const String saveLockTimerSuccess = "Timer de bloqueio salvo com sucesso!";
static const String saveLockTimerImpossible = "Não foi possível salvar o timer de bloqueio no momento.";

static const String changePasswordError = "Não foi possível alterar a senha.";
static const String changePasswordSuccess = "Sua senha foi alterada!";

static const String restoreAutomaticBackupError = "Não foi possível restaurar o backup automático.";
static const String restoreAutomaticBackupSuccess = "Backup automático restaurado!";

static const String restoreFileInvalidError = "Falha ao restaurar: arquivo inválido ou corrompido.";
static const String backupRestoredSuccess = "Backup restaurado com sucesso!";
static const String noFileSelected = "Nenhum arquivo selecionado.";

static const String shareBackupError = "Erro ao compartilhar backup.";
static const String shareBackupSuccess = "Backup compartilhado!";
static const String backupCreatedSuccess = "Backup salvo com sucesso!";
static const String createManualBackupError = "Error ao criar backup manual!";

static const String selectFileError = "Falha ao selecionar arquivo.";

static const String removePinError = "Não foi possível remover o PIN.";
static const String pinMismatchError = "O PIN informado não corresponde ao PIN cadastrado.";
static const String removePinSuccess = "PIN removido com sucesso.";

static const String savePinError = "O PIN não pode ser salvo!";
static const String savePinSuccess = "PIN salvo com sucesso.";

static const String updatePinSuccess = "PIN atualizado com sucesso.";

static const String deleteAccountError = "Não foi possível excluir a conta.";
static const String accountRemovedSuccess = "Conta removida com sucesso.";

static const String identityValidationError = "Não foi possível confirmar sua identidade. Verifique e-mail e senha e tente novamente.";
static const String identityConfirmedAndPinRemoved = "Identidade confirmada. PIN removido com sucesso.";

static const String pinVerificationError = "Erro ao verificar PIN";
static const String unauthenticatedUser = "Usuário não autenticado";

static const String itemCreatedSuccess = "Item criado com sucesso!";

static const String saveItemError = "Não foi possível salvar o item. Tente novamente.";
static const String dataProtectionError = "Falha ao proteger os dados. Tente novamente.";

static const String criticalRestoreError = "Falha crítica na restauração. O banco original foi preservado:";

static const String itemUpdateIdError = "O ID do item não pode ser nulo na atualização";

static const String unlocking = "Desbloqueando...";
static const String unlockAction = "Desbloquear";
static const String unlockScreenTitle = "Desbloquear Tela";
static const String insertCredentialsPrompt = "Por favor, insira suas credenciais.";

static const String incorrectPin = "PIN incorreto.";
static const String enterValidPin = "Digite um PIN válido.";
static const String invalidCredentials = "Credenciais inválidas.";
static const String fillEmailAndPassword = "Preencha e-mail e senha corretamente.";

static const String backupFileHeader = "Backup criptografado da lista de logins - LockPass";
static const String databaseNotFound = "Arquivo do banco de dados não encontrado.";
static const String encryptionBackupError = "Falha ao criptografar o banco para backup.";
static const String backupFileNotFound = "Arquivo de backup não encontrado.";
static const String autoBackupNotFound = "Nenhum backup automático encontrado.";
static const String invalidBackupFile = "O arquivo de backup é inválido ou não contém dados compatíveis.";
static const String decryptionBackupError = "Falha na descriptografia. O backup pode ser de outra conta ou a chave está incorreta.";
static const String replaceDatabaseError = "Erro ao substituir o banco de dados:";
static const String restoreProcessError = "Erro durante a restauração:";

static const String saveBackupLocationPrompt = "Onde deseja salvar o backup?";
static const String exportCancelled = "Exportação cancelada.";

static const String tooManyAttempts = "Muitas tentativas. Tente novamente em alguns minutos.";
static const String noConnection = "Sem conexão. Verifique sua internet.";
static const String passwordTooShort = "A nova senha deve ter no mínimo 6 caracteres.";
static const String sessionExpired = "Sessão expirada. Por segurança, faça login novamente.";
static const String infoValidationFailed = "Não foi possível validar suas informações. Verifique sua senha atual e sua conexão e tente novamente.";
static const String genericError = "Algo deu errado. Tente novamente.";
}
