![Geek Joke](https://codde.dev/gj/logo-gj.png)

# Geek Joke API - Fullstack Application

> **Aplicação Fullstack** desenvolvida com **Vue.js** e **AdonisJS** que consome a [API Geek Joke](https://geek-jokes.sameerkumar.website/api) para entreter desenvolvedores com piadas geek através de uma interface interativa baseada em estados de humor.

---

## 📖 Índice

- [Visão Geral](#-visão-geral)
- [Metodologia de Desenvolvimento](#-metodologia-de-desenvolvimento)
- [Stack Tecnológica](#-stack-tecnológica)
- [Defesa da Arquitetura](#-defesa-da-arquitetura)
- [Arquitetura do Sistema](#-arquitetura-do-sistema)
- [Funcionalidades](#-funcionalidades)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação e Execução](#-instalação-e-execução)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Credenciais de Acesso](#-credenciais-de-acesso)
- [Endpoints da API](#-endpoints-da-api)
- [Testes](#-testes)
- [Contribuindo](#-contribuindo)

---

## 🎯 Visão Geral

Este projeto é uma **Single Page Application (SPA)** que demonstra a integração entre um frontend moderno (Vue.js) e um backend robusto (AdonisJS), implementando:

- ✅ **Autenticação com Access Tokens** (stateful, mais seguro que JWT puro)
- ✅ **Integração com API externa** (Geek Joke API)
- ✅ **Roteamento dinâmico** baseado em estados de humor
- ✅ **Gerenciamento de estado** com Pinia
- ✅ **Containerização completa** com Docker e Docker Compose
- ✅ **Proxy reverso** com Nginx e SSL/TLS
- ✅ **Testes unitários e de integração**
- ✅ **Validação robusta** com VineJS Validators

### 🎭 Fluxo de Interação

```
Login → 😐 Inicial → 😢 Triste → 🫣 Poker Face (piada) → 😄 Feliz → 😐 Inicial
```

Cada clique na tela muda o estado de humor, criando uma experiência interativa e divertida para o usuário.

---

## 📚 Metodologia de Desenvolvimento

### Documentation-Driven Development (DDD)

Este projeto foi desenvolvido seguindo a metodologia **Documentation-Driven Development**, uma abordagem moderna onde:

1. **A documentação é escrita PRIMEIRO**, antes de qualquer linha de código
2. **Os requisitos são detalhados** em documentos técnicos estruturados
3. **O código é implementado** seguindo fielmente a documentação
4. **A documentação é mantida atualizada** durante todo o ciclo de vida

#### ✨ Princípios Fundamentais

```
📝 DOCUMENTAR → 🔍 REVISAR → 💻 IMPLEMENTAR → ✅ VALIDAR → 🔄 ITERAR
```

#### 🚀 Vantagens do Documentation-Driven Development

| Vantagem                       | Descrição                                                                                      |
| ------------------------------ | ---------------------------------------------------------------------------------------------- |
| 🎯 **Clareza de Requisitos**   | Requisitos definidos antes de codificar reduzem ambiguidade e retrabalho                       |
| 🤝 **Melhor Comunicação**      | Documentação clara facilita alinhamento entre stakeholders técnicos e não-técnicos             |
| ⚡ **Menos Retrabalho**        | Especificações detalhadas evitam implementações incorretas e bugs conceituais                  |
| 📖 **Documentação Atualizada** | A documentação é parte do processo, não uma tarefa posterior negligenciada                     |
| 🎓 **Onboarding Facilitado**   | Novos desenvolvedores entendem o projeto rapidamente sem depender de tribal knowledge          |
| 🤖 **Otimizado para IA/LLM**   | LLMs como Claude podem implementar código seguindo especificações detalhadas com alta precisão |
| 🧪 **Testabilidade**           | Requisitos claros facilitam criação de testes abrangentes e significativos                     |
| 🏗️ **Arquitetura Consistente** | Decisões arquiteturais são documentadas, justificadas e seguidas consistentemente              |
| 📊 **Rastreabilidade**         | Fácil rastrear código para requisito e vice-versa, essencial para auditorias                   |
| 💰 **Redução de Custos**       | Menor custo de manutenção a longo prazo devido à clareza e consistência                        |

#### 💡 Por que DDD é superior ao desenvolvimento tradicional?

**Desenvolvimento tradicional:**

```
Código → Documentação (se sobrar tempo) → Manutenção difícil
```

**Documentation-Driven Development:**

```
Requisitos → Design → Documentação → Código → Validação → Manutenção facilitada
```

#### 🌟 Desenvolvimento Moderno com IA

Documentation-Driven Development é **especialmente poderoso quando combinado com LLMs**:

1. **Especificações claras** → LLMs geram código preciso
2. **Documentação estruturada** → LLMs entendem contexto completo
3. **Requisitos atômicos** → LLMs implementam incrementalmente
4. **Validação contra specs** → LLMs verificam conformidade
5. **Refatoração segura** → LLMs mantêm comportamento esperado

**Este projeto foi desenvolvido inteiramente seguindo DDD + Claude Sonnet 4.5**, demonstrando o poder dessa combinação.

---

## 🧠 Stack Tecnológica

### Backend

| Tecnologia        | Versão | Função                    | Por que escolhemos?                                            |
| ----------------- | ------ | ------------------------- | -------------------------------------------------------------- |
| **Node.js**       | 22.x   | Runtime JavaScript        | Performance excepcional, ecossistema maduro, TypeScript nativo |
| **AdonisJS**      | 6.x    | Framework MVC             | Framework completo, ORM integrado, segurança built-in          |
| **Lucid ORM**     | 20.x   | Object-Relational Mapping | Active Record elegante, migrations robustas                    |
| **PostgreSQL**    | 18.x   | Banco de dados relacional | ACID completo, performance superior, extensível                |
| **Access Tokens** | -      | Autenticação stateful     | Mais seguro que JWT: revogação imediata, auditoria             |
| **VineJS**        | -      | Validação de dados        | Type-safe, nativo do AdonisJS                                  |
| **Axios**         | 1.x    | Cliente HTTP              | API clara, interceptors, timeout                               |

### Frontend

| Tecnologia     | Versão | Função               | Por que escolhemos?                                 |
| -------------- | ------ | -------------------- | --------------------------------------------------- |
| **Vue.js**     | 3.x    | Framework JavaScript | Composition API moderna, performance, TypeScript    |
| **Vite**       | 5.x    | Build tool           | HMR instantâneo, build otimizado, DX excepcional    |
| **Pinia**      | 2.x    | State management     | API simples, TypeScript, substituto oficial do Vuex |
| **Vue Router** | 4.x    | Roteamento SPA       | Guards de navegação, lazy loading                   |
| **Vuetify**    | 3.x    | UI Component Library | Material Design 3, componentes prontos              |
| **Axios**      | 1.x    | Cliente HTTP         | Interceptors para token, erro centralizado          |

### DevOps & Infraestrutura

| Tecnologia         | Versão | Função                  | Por que escolhemos?                          |
| ------------------ | ------ | ----------------------- | -------------------------------------------- |
| **Docker**         | 24.x   | Containerização         | Ambiente consistente, portabilidade, CI/CD   |
| **Docker Compose** | 2.x    | Orquestração            | Definição declarativa, networks isoladas     |
| **Nginx**          | latest | Reverse proxy           | Performance, SSL termination, load balancing |
| **mkcert**         | -      | Certificados SSL locais | HTTPS local sem warnings                     |

---

## 🏛️ Defesa da Arquitetura

### Por que Access Tokens ao invés de JWT Stateless?

| Aspecto            | Access Tokens (Stateful)      | JWT Stateless                  |
| ------------------ | ----------------------------- | ------------------------------ |
| **Revogação**      | ✅ Imediata (deleta do banco) | ❌ Impossível até expirar      |
| **Auditoria**      | ✅ Last used, IP, device      | ❌ Sem rastreamento            |
| **Tamanho**        | ✅ Pequeno (token ID)         | ❌ Grande (payload codificado) |
| **Sessões ativas** | ✅ Listagem no banco          | ❌ Impossível listar           |
| **Segurança**      | ✅ Compromisso isolado        | ⚠️ Compromisso até expirar     |

**Minha escolha**: Access Tokens

**Justificativa**:

- Segurança > Escalabilidade prematura
- Auditoria é crítica (compliance, LGPD)
- Revogação imediata é requisito (logout, compromisso)
- Banco já existe (PostgreSQL), overhead é mínimo
- Cache pode otimizar (Redis) se necessário no futuro

---

## 🏗️ Arquitetura do Sistema

### Diagrama de Arquitetura

```
┌─────────────────────────────────────────────────────────┐
│                       USUÁRIO                            │
│                    (Navegador)                           │
└────────────────────┬────────────────────────────────────┘
                     │ HTTPS (TLS 1.2/1.3)
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  NGINX PROXY                             │
│              (Reverse Proxy + SSL)                       │
│    • Porta 80 → 443 (redirect)                          │
│    • Porta 443 (SSL/TLS termination)                    │
└──────────┬──────────────────────┬───────────────────────┘
           │                      │
           │ /                    │ /api/*
           ▼                      ▼
┌──────────────────┐    ┌──────────────────────────────┐
│   FRONTEND       │    │       BACKEND                │
│   (Vue.js SPA)   │    │       (AdonisJS)             │
│   Porta: 5173    │    │       Porta: 3333            │
│                  │    │                              │
│   • Pinia Store  │    │   • Controllers              │
│   • Vue Router   │    │   • Models (Lucid ORM)       │
│   • Vuetify UI   │◄───┤   • Middleware (Auth)        │
│   • Axios HTTP   │────┤   • Services (Business)      │
│   • Guards       │    │   • Validators (VineJS)      │
└──────────────────┘    └───────┬──────────────────────┘
                                │ Lucid ORM
                                ▼
                    ┌───────────────────────┐
                    │   POSTGRESQL          │
                    │   Porta: 5432         │
                    │                       │
                    │   • users             │
                    │   • auth_access_tokens│
                    └───────────────────────┘
                                │ HTTP
                                ▼
                    ┌───────────────────────┐
                    │   API EXTERNA         │
                    │   Geek Jokes API      │
                    └───────────────────────┘
```

### Fluxo de Autenticação (Access Tokens)

```
1. User → POST /api/auth/login → Backend
2. Backend valida credenciais no PostgreSQL (Scrypt hash)
3. Backend gera Access Token e salva na tabela auth_access_tokens
4. Backend retorna token + dados do usuário
5. Frontend armazena token no localStorage
6. Requisições subsequentes incluem: Authorization: Bearer <token>
7. Middleware valida token consultando banco de dados
8. Request processado e resposta retornada
```

**Vantagens deste fluxo:**

- ✅ Revogação instantânea (delete token do banco)
- ✅ Auditoria completa (last_used_at, expires_at)
- ✅ Gerenciamento de sessões ativas
- ✅ Segurança superior (compromisso isolado)

### Padrões de Arquitetura Aplicados

#### Backend (AdonisJS)

- **MVC (Model-View-Controller)**: Separação clara de responsabilidades
- **Service Layer**: Lógica de negócio isolada (GeekJokeService)
- **Repository Pattern**: Lucid ORM abstrai acesso a dados
- **Middleware Pattern**: Autenticação, CORS, Body Parser
- **Validator Pattern**: VineJS para validação de entrada
- **Dependency Injection**: AdonisJS IoC container

#### Frontend (Vue.js)

- **MVVM (Model-View-ViewModel)**: Reatividade Vue
- **Store Pattern**: Pinia para estado global (auth, mood)
- **Component Pattern**: Componentes reutilizáveis
- **Composition API**: Lógica reusável e type-safe
- **Guard Pattern**: Router guards para proteção de rotas

---

## ✨ Funcionalidades

### Implementadas

- ✅ **Autenticação Stateful**

  - Login com email e senha
  - Validação de formulário (frontend + backend)
  - Persistência de sessão (localStorage)
  - Proteção de rotas via middleware
  - Logout com revogação de token

- ✅ **Estados de Humor Interativos**

  - `/inicial` - Estado neutro 😐
  - `/triste` - Estado triste 😢
  - `/poker-face` - Estado curioso 🫣 (exibe piada)
  - `/feliz` - Estado feliz 😄

- ✅ **Sistema de Piadas**

  - Consumo da API Geek Joke
  - Modal interativa
  - Tratamento de erros

- ✅ **Infraestrutura**

  - Docker e Docker Compose
  - Nginx com SSL/TLS (HTTPS)
  - PostgreSQL com persistência
  - Health checks

- ✅ **Segurança**
  - HTTPS obrigatório
  - CORS configurado
  - Validação de entrada (VineJS)
  - Password hashing (Scrypt)
  - Access Tokens stateful
  - SQL injection prevention (Lucid ORM)
  - XSS prevention (Vue escaping)

---

## 📋 Pré-requisitos

### Obrigatórios

- **Docker** >= 24.0
- **Docker Compose** >= 2.0
- **Git** >= 2.30

### Opcionais (desenvolvimento local)

- **Node.js** >= 22.x
- **PostgreSQL** >= 14.x
- **pnpm** ou **npm**

---

## 🚀 Instalação e Execução

### Opção 1: Docker (Recomendado)

```bash
# 1. Clone o repositório
git clone <repository-url>
cd geek_joke

# 2. Gere certificados SSL (primeira vez)
mkdir -p certs && cd certs
mkcert localhost 127.0.0.1 ::1
cd ..

# 3. Suba os containers
docker-compose up --build

# 4. Execute as migrations (outro terminal - opcional, pois o schema já foi populado na fase anterior)
docker exec -it geekjoke-backend sh
cd /app && node ace migration:run && node ace db:seed
exit

# 5. Acesse
# Frontend: https://localhost
# Backend: https://localhost/api
```

### Opção 2: Desenvolvimento Local

```bash
# Backend
cd backend
npm install
cp .env.example .env
# Editar .env com credenciais PostgreSQL
node ace generate:key
node ace migration:run
node ace db:seed
node ace serve --watch

# Frontend (outro terminal)
cd frontend
npm install
echo "VITE_API_URL=http://localhost:3333" > .env.local
npm run dev

# Acesse: http://localhost:5173
```

---

## 📁 Estrutura do Projeto

```
geek_joke/
├── backend/                    # API REST AdonisJS
│   ├── app/
│   │   ├── controllers/       # HTTP Controllers
│   │   ├── models/            # Lucid Models
│   │   ├── middleware/        # Middlewares
│   │   ├── services/          # Business Logic
│   │   └── validators/        # VineJS Validators
│   ├── database/
│   │   ├── migrations/        # Database Migrations
│   │   └── seeders/           # Data Seeders
│   ├── config/                # Configurações
│   └── tests/                 # Testes
│
├── frontend/                   # SPA Vue.js
│   ├── src/
│   │   ├── components/        # Componentes
│   │   ├── views/             # Views de rota
│   │   ├── stores/            # Pinia stores
│   │   ├── router/            # Configuração rotas
│   │   └── services/          # API services
│   └── public/                # Assets estáticos
│
├── nginx/                      # Configurações Nginx
├── certs/                      # Certificados SSL
├── docker-compose.yml          # Orquestração
├── REQUISITOS.md              # Especificação completa
└── README.md                  # Este arquivo
```

---

## 🔑 Credenciais de Acesso

### Usuário Padrão (Seeder)

```
Email:    cliente@incuca.com.br
Senha:    seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga
```

### Banco de Dados

```
Host:     postgres (ou localhost se fora do Docker)
Porta:    5432
Database: geekjoke
Usuário:  geekjoke
Senha:    <conforme .env>
```

---

## 🔌 Endpoints da API

### Autenticação

#### `POST /auth/login`

Autentica um usuário e retorna um Access Token.

**Request:**

```json
{
  "email": "cliente@incuca.com.br",
  "password": "seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga"
}
```

**Response (200):**

```json
{
  "token": "oat_NjQuMT...YxNTM4",
  "user": {
    "id": 1,
    "email": "cliente@incuca.com.br"
  }
}
```

#### `GET /auth/me`

Retorna dados do usuário autenticado.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**

```json
{
  "user": {
    "id": 1,
    "email": "cliente@incuca.com.br"
  }
}
```

#### `POST /auth/logout`

Revoga o token atual.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**

```json
{
  "message": "Logged out successfully"
}
```

### Piadas

#### `GET /jokes/random`

Retorna uma piada aleatória (requer autenticação).

**Headers:** `Authorization: Bearer <token>`

**Response (200):**

```json
{
  "joke": "Why do programmers prefer dark mode? Because light attracts bugs!"
}
```

---

## 🧪 Testes

### Backend

```bash
cd backend

# Rodar todos os testes
npm test

# Com coverage
npm test -- --coverage
```

**Testes implementados:**

- ✅ Login (válido, inválido, sem credenciais)
- ✅ Autenticação (/me, logout)
- ✅ Piadas (autenticado, não autenticado)

---

## 🤝 Contribuindo

Este projeto segue **Documentation-Driven Development**:

1. **Documente primeiro** antes de codificar
2. **Siga o TO_DO.md** para verificar roadmap
3. **Adicione testes** para toda nova feature
4. **Use Conventional Commits**

```bash
git checkout -b feature/minha-feature
# Documente, implemente, teste
git commit -m "feat: adiciona feature X"
git push origin feature/minha-feature
```

---

## 📄 Licença

MIT License - veja arquivo `LICENSE` para detalhes.

---

## 👥 Autores

- **Desenvolvedor**: Jesse Santos
- **Metodologia**: Documentation-Driven Development

---

## 🙏 Agradecimentos

- [Geek Joke API](https://github.com/sameerkumar18/geek-joke-api)
- [AdonisJS](https://adonisjs.com)
- [Vue.js](https://vuejs.org)
- [PostgreSQL](https://www.postgresql.org)
- Comunidade open-source

---

## 📈 Status do Projeto

![Status](https://img.shields.io/badge/status-completo-green)
![Metodologia](https://img.shields.io/badge/metodologia-Documentation--Driven%20Development-blue)
![Node](https://img.shields.io/badge/node-%3E%3D22.x-green)
![Vue](https://img.shields.io/badge/vue-3.x-brightgreen)
![AdonisJS](https://img.shields.io/badge/adonisjs-6.x-purple)

---

**Desenvolvido com ❤️ usando Documentation-Driven Development**
