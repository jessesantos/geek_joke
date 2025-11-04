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

const JokesController = () => import('#controllers/jokes_controller')

router.get('/', async () => {
  return {
    hello: 'world',
  }
})

/**
 * Rotas de Jokes (protegidas por autenticação)
 */
router
  .group(() => {
    router.get('/random', [JokesController, 'random'])
  })
  .prefix('/jokes')
  .use(middleware.auth())
