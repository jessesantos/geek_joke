/*
|--------------------------------------------------------------------------
| Routes file
|--------------------------------------------------------------------------
|
| The routes file is used for defining the HTTP routes.
|
*/

import router from '@adonisjs/core/services/router'
import { middleware } from '#start/kernel'

const AuthController = () => import('#controllers/auth_controller')
const JokesController = () => import('#controllers/jokes_controller')

router.get('/', async () => {
  return {
    hello: 'world',
  }
})

/**
 * Rotas de Autenticação
 */
router
  .group(() => {
    // Rota pública de login
    router.post('/login', [AuthController, 'login'])

    // Rotas protegidas
    router.get('/me', [AuthController, 'me']).use(middleware.auth())
    router.post('/logout', [AuthController, 'logout']).use(middleware.auth())
  })
  .prefix('/auth')

/**
 * Rotas de Jokes (protegidas por autenticação)
 */
router
  .group(() => {
    router.get('/random', [JokesController, 'random'])
  })
  .prefix('/jokes')
  .use(middleware.auth())
