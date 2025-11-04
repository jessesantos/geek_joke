import type { HttpContext } from '@adonisjs/core/http'
import GeekJokeService from '#services/geek_joke_service'

export default class JokesController {
  private geekJokeService: GeekJokeService

  constructor() {
    this.geekJokeService = new GeekJokeService()
  }

  /**
   * GET /jokes/random
   * Retorna uma piada aleatória da API Geek Joke
   * Requer autenticação
   */
  async random({ response }: HttpContext) {
    try {
      const joke = await this.geekJokeService.getRandomJoke()
      return response.ok(joke)
    } catch (error) {
      return response.internalServerError({
        error: 'Failed to fetch joke',
        message: error instanceof Error ? error.message : 'Unknown error occurred',
      })
    }
  }
}
