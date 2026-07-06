# Educame

O **Educame** é uma plataforma feita em Flutter para ajudar alunos a encontrarem professores particulares.

O aluno poderá buscar professores por disciplina e escolher aulas **online** ou **presenciais**.

O projeto será desenvolvido inicialmente apenas para **Android**.

---

## Integrantes
- Lucas Cunha Almeida - https://github.com/LucasCunhaAlmeida
- Thiago Lima - https://github.com/ThiagoLima09
- Gabriel Fraga - https://github.com/Gabr1elFraga

---
## Tecnologias

* Flutter
* Dart
* Android
* Provider
* SQLite com Sqflite
* GoRouter

---

## Objetivo do Projeto

O objetivo do Educame é facilitar a conexão entre alunos e professores particulares.

Funcionalidades previstas:

* Cadastro de alunos
* Login
* Busca por professores
* Busca por disciplina
* Visualização do perfil do professor
* Solicitação de aula
* Escolha entre aula online ou presencial
* Histórico de aulas
* Perfil do usuário

---

## Arquitetura

O projeto usa uma arquitetura **MVVM simplificada**.

O fluxo principal será:

```text
Page -> ViewModel -> Repository -> Database
```

Ou seja, a tela não acessa o banco diretamente.

A tela chama o ViewModel.
O ViewModel chama o Repository.
O Repository acessa o banco de dados.

---

## Explicação das Camadas

### Page

Representa a tela do aplicativo.

Exemplos:

```text
login_page.dart
cadastro_page.dart
home_page.dart
```

A Page é responsável por mostrar a interface e receber ações do usuário.

---

### ViewModel

Controla o estado e as regras da tela.

Exemplos:

```text
login_viewmodel.dart
cadastro_viewmodel.dart
home_viewmodel.dart
```

O ViewModel pode controlar carregamento, erros, validações e chamadas ao Repository.

---

### Model

Representa os dados do sistema.

Exemplos:

```text
aluno_model.dart
professor_model.dart
aula_model.dart
```

---

### Repository

Responsável por acessar os dados.

Exemplos:

```text
aluno_repository.dart
professor_repository.dart
aula_repository.dart
```

Ele fica entre o ViewModel e o banco de dados.

---

### Database

Responsável pela configuração do banco SQLite.

Exemplo:

```text
app_database.dart
```

---

## Estrutura de Pastas

```text
lib/
│
├── main.dart
├── app.dart
│
├── core/
│   ├── database/
│   ├── routes/
│   └── theme/
│
├── data/
│   ├── models/
│   └── repositories/
│
└── features/
    ├── login/
    ├── cadastro/
    ├── home/
    ├── perfil/
    ├── professores/
    └── aulas/
```

---

## Responsabilidade das Pastas

### core

Contém coisas gerais do app, como banco, rotas e tema.

### data

Contém os models e repositories.

### features

Contém as telas e ViewModels de cada funcionalidade.

Exemplo:

```text
features/login/
├── login_page.dart
└── login_viewmodel.dart
```

---

## Comando para Criar o Projeto

```bash
flutter create --platforms=android educame
```

Entrar na pasta:

```bash
cd educame
```

Rodar o projeto:

```bash
flutter run
```

---

## Padrão de Nomes

Arquivos devem usar `snake_case`:

```text
login_page.dart
login_viewmodel.dart
aluno_model.dart
professor_repository.dart
app_database.dart
```

Classes devem usar `PascalCase`:

```dart
class LoginPage {}

class LoginViewModel {}

class AlunoModel {}

class ProfessorRepository {}

class AppDatabase {}
```

---

## Resumo

A estrutura principal do projeto será:

```text
Page -> ViewModel -> Repository -> Database
```

Essa organização ajuda a manter o código mais limpo e evita colocar regras de negócio diretamente nas telas.
