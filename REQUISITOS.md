# 🧩 Teste Fullstack – Vue.js + AdonisJS

## 🎯 Objetivo

Desenvolver uma aplicação **Fullstack** utilizando **Vue.js (frontend)** e **AdonisJS (backend)** que consome a [API Geek Joke](https://github.com/sameerkumar18/geek-joke-api).
A aplicação deve permitir login via **JWT**, exibir diferentes estados de humor em rotas distintas e apresentar **piadas geek** através de uma modal interativa.

---

## 🏗️ Estrutura Geral do Projeto

### 📁 Organização

```
/projeto-fullstack
│
├── frontend/              # Aplicação Vue.js
│   ├── src/
│   │   ├── components/
│   │   ├── store/
│   │   ├── views/
│   │   ├── router/
│   │   └── App.vue
│   └── package.json
│
├── backend/               # API REST AdonisJS
│   ├── app/
│   ├── database/
│   ├── start/
│   ├── .env
│   └── package.json
│
├── docker-compose.yml     # Configuração Docker
└── README.md              # Documentação do projeto
```

---

## 🧠 Tecnologias Principais

| Stack        | Tecnologia | Função                                  |
| ------------ | ---------- | --------------------------------------- |
| **Frontend** | Vue.js     | Framework SPA reativo                   |
|              | Pinia      | Gerenciamento de estado                 |
|              | Vuetify    | Componentes visuais (UI Library)        |
|              | ESLint     | Análise estática de código              |
| **Backend**  | AdonisJS   | Framework Node.js MVC                   |
|              | Lucid ORM  | Migrações e models                      |
|              | JWT        | Autenticação segura                     |
|              | Axios      | Consumo da API Geek Joke                |
| **Testes**   | Jest       | Testes unitários e de integração        |
| **Infra**    | Docker     | Containerização e execução simplificada |

---

## ⚙️ Backend – AdonisJS

### 1. Estrutura e Rotas Principais

- `POST /auth/login` → Autentica o usuário e retorna um JWT.
- `GET /jokes/random` → Retorna uma piada aleatória consumida da **API Geek Joke**.
- Rotas protegidas por middleware JWT.

### 2. Migrações e Banco de Dados

- Criar tabela `users` com campos `email`, `password`, `created_at`, `updated_at`.
- Inserir usuário inicial via _seed_:

  ```bash
  email: cliente@incuca.com.br
  senha: seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga
  ```

- Scripts:

  ```bash
  node ace migration:run
  node ace db:seed
  ```

### 3. Autenticação JWT

- Implementada via `@adonisjs/auth`.
- Token armazenado no **localStorage** (ou sessionStorage) do frontend.
- Persistência de sessão: usuário continua logado após atualizar a página.

### 4. Integração com API Geek Joke

- Backend chama `https://geek-jokes.sameerkumar.website/api?format=json`.
- Endpoint `/jokes/random` devolve o resultado ao frontend.

---

## 🎨 Frontend – Vue.js

### 1. Fluxo de Navegação

| Rota          | Estado de Humor                               | Ação                                |
| ------------- | --------------------------------------------- | ----------------------------------- |
| `/login`      | Tela de login com validação de e-mail e senha | Autentica usuário                   |
| `/inicial`    | 😐 Neutra                                     | Estado inicial                      |
| `/triste`     | 😢 Triste                                     | Após 1º clique                      |
| `/poker-face` | 🫣 Neutra curiosa                              | Exibe modal com piada               |
| `/feliz`      | 😄 Feliz                                      | Fecha modal e retorna ao `/inicial` |

### 2. Componentes

- `LoginForm.vue` → Formulário com validação (e-mail e senha >= 8 caracteres).
- `MoodView.vue` → Controla o estado de humor e cliques na tela.
- `JokeModal.vue` → Exibe piadas vindas do backend.

### 3. Gerenciamento de Estado (Pinia)

- `useAuthStore` → Armazena token JWT e dados do usuário.
- `useMoodStore` → Controla o estado emocional e rotas.

### 4. Interface (Vuetify)

- Utilizar componentes prontos (`v-btn`, `v-card`, `v-dialog`, etc.) para layout e modal.
- Aplicar tema responsivo e leve.

### 5. Lint

- Configurar **ESLint** + **Prettier** para manter padrão de código e boas práticas.

---

## 🧪 Testes (Jest)

### Tipos de testes:

- **Unitários:** Funções isoladas (ex: validação de e-mail, mudança de humor).
- **Integração:** Fluxo completo (login → mudança de rota → exibição da piada).
- **Backend:** Testar autenticação e retorno da piada (mock da API externa).

---

## 🐳 Docker

### Objetivo

Permitir executar todo o sistema com:

```bash
docker-compose up
```

### Serviços

- **frontend** → Vue.js app rodando em `http://localhost:8080`
- **backend** → API AdonisJS em `http://localhost:3333`
- **database** → PostgreSQL configurado via variáveis de ambiente

---

## 📋 Planejamento e Estimativa (Horas)

| Etapa                     | Descrição                                  | Estimativa   |
| ------------------------- | ------------------------------------------ | ------------ |
| **Setup inicial**         | Criação de pastas, Docker, configs base    | 4h           |
| **Backend**               | AdonisJS + JWT + API Geek + Migrações      | 16h          |
| **Frontend**              | Vue.js + Vuetify + Pinia + Rotas           | 18h          |
| **Integração**            | Comunicação front ↔ back + testes de fluxo | 6h           |
| **Testes (Jest)**         | Unitários e integração                     | 6h           |
| **Documentação (README)** | Explicações, setup e decisões técnicas     | 2h           |
| **Total estimado**        |                                            | **52 horas** |

---

## 🧱 Boas Práticas

- **Clean Code:** nomes claros, funções curtas, responsabilidades únicas.
- **SOLID:** especialmente _Single Responsibility_ e _Dependency Inversion_.
- **Commits semânticos:** `feat:`, `fix:`, `refactor:` etc.
- **Arquitetura modular:** separar serviços, stores e componentes.

---

## 🧾 README.md – Conteúdo Sugerido

1. **Descrição do projeto**
2. **Arquitetura e tecnologias utilizadas**
3. **Como rodar o projeto (Docker e manualmente)**
4. **Endpoints principais**
5. **Instruções para rodar testes**
6. **Estimativa de tempo e aprendizado**
7. **Autores e contribuições**

---

## 🌟 Diferenciais

- Testes unitários e de integração completos
- Projeto rodando via Docker
- Uso de **TypeScript (opcional)**
- Layout responsivo e agradável
- Estrutura clara e organizada, com Clean Code e SOLID

---

## 💬 Dica Final

> O detalhamento é propositalmente incompleto — use a criatividade para tornar a aplicação divertida, fluida e bem estruturada.
> O objetivo é demonstrar **organização, boas práticas e clareza técnica**.
