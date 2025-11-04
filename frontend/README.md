# Geek Joke Frontend

Frontend da aplicação Geek Joke desenvolvido com Vue.js 3, Vite, Pinia e Vuetify.

## Stack Tecnológica

- **Vue.js 3** - Framework JavaScript reativo
- **Vite** - Build tool e dev server
- **Pinia** - State management
- **Vue Router** - Roteamento SPA
- **Vuetify 3** - UI Component Library (Material Design)
- **Axios** - Cliente HTTP

## Estrutura de Pastas

```
src/
├── components/         # Componentes reutilizáveis
│   ├── LoginForm.vue
│   ├── MoodView.vue
│   └── JokeModal.vue
├── views/             # Views de rota
│   ├── LoginView.vue
│   ├── InicialView.vue
│   ├── TristeView.vue
│   ├── PokerFaceView.vue
│   └── FelizView.vue
├── stores/            # Pinia stores
│   ├── auth.js
│   └── mood.js
├── router/            # Configuração de rotas
│   └── index.js
├── services/          # Serviços de API
│   └── api.js
├── plugins/           # Plugins Vue
│   └── vuetify.js
├── App.vue            # Componente raiz
└── main.js            # Entry point
```

## Instalação

```bash
# Instalar dependências
npm install

# Rodar servidor de desenvolvimento
npm run dev

# Build para produção
npm run build

# Preview do build de produção
npm run preview
```

## Variáveis de Ambiente

Copie o arquivo `.env.example` para `.env` e configure as variáveis necessárias.

## Rotas

- `/login` - Página de login (pública)
- `/inicial` - Estado inicial 😐 (protegida)
- `/triste` - Estado triste 😢 (protegida)
- `/poker-face` - Poker face 🫣 + piada (protegida)
- `/feliz` - Estado feliz 😄 (protegida)

## Fluxo de Navegação

```
Login → Inicial (😐) → Triste (😢) → Poker Face (🫣) + Piada → Feliz (😄) → Inicial (😐)
```

## Credenciais Padrão

```
Email: cliente@incuca.com.br
Senha: seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga
```

## Desenvolvido com

- 💚 Vue.js
- ⚡ Vite
- 🍍 Pinia
- 🎨 Vuetify
