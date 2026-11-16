# Gerenciador de Tarefas

Aplicativo Flutter para gerenciamento de tarefas pessoais com Firebase Authentication e Firebase Realtime Database.

## Requisitos

- Git
- Android Studio com Android SDK e um emulador (ou celular Android com depuração USB)
- Flutter 3.50 ou superior
- Node.js (somente se for usar outro projeto Firebase)

## Instalação do Flutter (local, dentro da pasta do projeto)

O Flutter fica na pasta `.tools/` (ignorada pelo git). Na pasta do projeto, execute:

```
git clone -b stable --depth 1 https://github.com/flutter/flutter.git .tools/flutter
```

Em cada terminal novo, configure as variáveis (macOS/Linux):

```
export PATH="$PWD/.tools/flutter/bin:$PWD/.tools/npm/node_modules/.bin:$PWD/.tools/pub-cache/bin:$PATH"
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

## Usar outro projeto Firebase (opcional)

1. Crie um projeto no console do Firebase (https://console.firebase.google.com).
2. Em Authentication > Método de login, ative "E-mail/senha".
3. Em Realtime Database, crie um banco de dados.
4. Na aba Regras do Realtime Database, cole as regras abaixo e publique (cada usuário só acessa suas próprias tarefas):

```
{
  "rules": {
    "tarefas": {
      "$uid": {
        ".read": "auth != null && auth.uid == $uid",
        ".write": "auth != null && auth.uid == $uid"
      }
    }
  }
}
```

5. Instale o firebase-tools e o FlutterFire CLI na pasta do projeto, faça login e gere a configuração:

```
npm install --prefix .tools/npm firebase-tools
dart pub global activate flutterfire_cli
firebase login
flutterfire configure --platforms=android
```

Esse comando substitui os arquivos `lib/firebase_options.dart` e `android/app/google-services.json`.

## Estrutura dos dados no Realtime Database

```
tarefas/
  <uid do usuario>/
    <id da tarefa>/
      titulo, descricao, dataVencimento, prioridade, concluida
```
