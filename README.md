# Gerenciador de Tarefas

Aplicativo Flutter para gerenciamento de tarefas pessoais com Firebase Authentication e Firebase Realtime Database.

## Requisitos

- Git
- Android Studio com Android SDK e um emulador (ou celular Android com depuração USB)
- Flutter 3.50 ou superior

## Instalação do Flutter (local, dentro da pasta do projeto)

O Flutter fica na pasta `.tools/` (ignorada pelo git). Na pasta do projeto, execute:

```
git clone -b stable --depth 1 https://github.com/flutter/flutter.git .tools/flutter
```

Em cada terminal novo, configure as variáveis (macOS/Linux):

```
export PATH="$PWD/.tools/flutter/bin:$PATH"
export PUB_CACHE="$PWD/.tools/pub-cache"
```

Depois instale as dependências do projeto:

```
flutter pub get
```

## Executar

A configuração do Firebase já está incluída no projeto (`lib/firebase_options.dart` e `android/app/google-services.json`). Com o emulador aberto (ou celular conectado):

```
flutter run
```

## Estrutura dos dados no Realtime Database

```
tarefas/
  <uid do usuario>/
    <id da tarefa>/
      titulo, descricao, dataVencimento, prioridade, concluida
```

## Capturas de tela

<table>
  <tr>
    <td align="center"><img src="capturas/01_login.png" width="180"><br>Login</td>
    <td align="center"><img src="capturas/02_cadastro_validacao.png" width="180"><br>Validação do cadastro</td>
    <td align="center"><img src="capturas/03_cadastro_preenchido.png" width="180"><br>Cadastro de usuário</td>
    <td align="center"><img src="capturas/04_home.png" width="180"><br>Tela inicial</td>
  </tr>
  <tr>
    <td align="center"><img src="capturas/05_drawer.png" width="180"><br>Menu lateral</td>
    <td align="center"><img src="capturas/06_login_erro.png" width="180"><br>Erro de autenticação</td>
    <td align="center"><img src="capturas/07_cadastro_tarefa.png" width="180"><br>Cadastro de tarefa</td>
    <td align="center"><img src="capturas/08_lista_tarefas.png" width="180"><br>Lista de tarefas</td>
  </tr>
  <tr>
    <td align="center"><img src="capturas/09_detalhes.png" width="180"><br>Detalhes da tarefa</td>
    <td align="center"><img src="capturas/10_editar_tarefa.png" width="180"><br>Edição de tarefa</td>
    <td align="center"><img src="capturas/11_lista_editada.png" width="180"><br>Tarefa editada</td>
    <td align="center"><img src="capturas/12_confirmar_exclusao.png" width="180"><br>Exclusão de tarefa</td>
  </tr>
  <tr>
    <td align="center"><img src="capturas/13_lista_apos_exclusao.png" width="180"><br>Após a exclusão</td>
    <td align="center"><img src="capturas/14_lista_concluida.png" width="180"><br>Tarefa concluída</td>
    <td align="center"><img src="capturas/15_home_contadores.png" width="180"><br>Contadores</td>
    <td align="center"><img src="capturas/16_sobre.png" width="180"><br>Sobre o aplicativo</td>
  </tr>
  <tr>
    <td align="center"><img src="capturas/17_config_claro.png" width="180"><br>Configurações (claro)</td>
    <td align="center"><img src="capturas/18_config_escuro.png" width="180"><br>Configurações (escuro)</td>
    <td align="center"><img src="capturas/19_drawer_escuro.png" width="180"><br>Menu (escuro)</td>
    <td align="center"><img src="capturas/20_tarefas_escuro.png" width="180"><br>Tarefas (escuro)</td>
  </tr>
  <tr>
    <td align="center"><img src="capturas/21_cadastro_tarefa_escuro.png" width="180"><br>Cadastro de tarefa (escuro)</td>
    <td align="center"><img src="capturas/22_home_escuro_reaberto.png" width="180"><br>Reaberto no tema escuro</td>
    <td align="center"><img src="capturas/23_login_escuro.png" width="180"><br>Login (escuro)</td>
    <td align="center"><img src="capturas/24_cadastro_usuario_escuro.png" width="180"><br>Cadastro de usuário (escuro)</td>
  </tr>
</table>

## Vídeo de demonstração

[demonstracao.mp4](demonstracao.mp4)
